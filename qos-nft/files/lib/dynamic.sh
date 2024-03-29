#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_validate_dynamic() {
	uci_load_validate qos-nft default "$1" "$2" \
		'ipqos_enable:bool:0' \
		'ip_type:maxlength(8)' \
		'dynamic_bw_up:uinteger:100' \
		'dynamic_bw_down:uinteger:100'
}

# return average rate for dhcp leases
qosdef_dynamic_rate() { # <bandwidth>
	local c=0 c6=0

	[ ! -e /tmp/dhcp.leases -a \
	  ! -e /var/dhcp6.leases ] && return

	[ -e /tmp/dhcp.leases ] && \
	  c=$(wc -l < /tmp/dhcp.leases 2>/dev/null)
	[ -e /var/dhcp6.leases ] && \
	  c6=$(wc -l < /var/dhcp6.leases 2>/dev/null)
	[ $c -eq 0 -a $c6 -eq 0 ] && \
	  { echo 12500; return; }

	echo $(($1 / ($c + $c6)))
}

qosdef_append_chain_dym() { # <hook> <name> <bandwidth>
	local cidr cidr6
	local operator rate
	local hook=$1 name=$2 bandwidth=$3

	config_get cidr default 'dynamic_cidr'
	config_get cidr6 default 'dynamic_cidr6'

	[ -z "$cidr" -a -z "$cidr6" ] && return

	case "$2" in
		upload) operator=saddr;;
		download) operator=daddr;;
	esac

	rate=$(qosdef_dynamic_rate $bandwidth)

	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter $hook 0 accept
	qosdef_append_rule_limit_whitelist $name
	[ -n "$cidr" ] && \
		qosdef_append_rule_ip_limit $cidr $operator kbytes $rate
	[ -n "$cidr6" ] && \
		qosdef_append_rule_ip_limit $cidr6 $operator kbytes $rate
	qosdef_appendx "\t}\n"
}

qosdef_flush_dynamic() {
	qosdef_flush_table "$NFT_QOS_INET_FAMILY" qos-dynamic
}

# init dynamic qos
qosdef_init_dynamic() {
	local hook_ul="prerouting" hook_dl="postrouting"

	[ "$2" = 0 ] || {
		logger -t qos-dynamic "validation failed"
		return 1
	}

	[ $ipqos_enable -eq 0 -o \
		"$ip_type" = "static" ] && return 1

	# Transfer mbits/s to mbytes/s
	# e.g. 100,000 kbits == 12,500 kbytes
	dynamic_bw_up=$(($dynamic_bw_up * 1000 / 8))
	dynamic_bw_down=$(($dynamic_bw_down * 1000 / 8))

	[ -z "$NFT_QOS_HAS_BRIDGE" ] && {
		hook_ul="postrouting"
		hook_dl="prerouting"
	}

	qosdef_appendx "table $NFT_QOS_INET_FAMILY qos-dynamic {\n"
	qosdef_append_chain_dym $hook_ul upload $dynamic_bw_up
	qosdef_append_chain_dym $hook_dl download $dynamic_bw_down
	qosdef_appendx "}\n"
}
