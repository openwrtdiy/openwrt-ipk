#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_validate_static() {
	uci_load_validate qos-nft default "$1" "$2" \
		'ipqos_enable:bool:0' \
		'ip_type:maxlength(8)'
}

# append rule for static qos
qosdef_append_rule_sta() { # <section> <operator> <default-unit> <default-rate>
	local ipaddr unit rate burst connect
	local operator=$2

	config_get ipaddr $1 ipaddr
	if [ "$operator" = "saddr" ]; then
		config_get rate $1 urate $3
		config_get unit $1 unit $4
		config_get burst $1 burst $5
		config_get connect $1 connect $6
	else
		config_get rate $1 drate $3
		config_get unit $1 unit $4
		config_get burst $1 burst $5
	fi

	[ -z "$ipaddr" ] && return

	# Convert units to KBytes (1 Mbps = 125 KBytes)
	if [ "$unit" = "mbps" ]; then
		rate=$((rate * 125))  # Convert to KBytes
		unit="kbytes"
	fi
	
	# If burst is empty and rate is greater than or equal to 10, set burst to rate / 10
	if [ -z "$burst" ] && [ "$rate" -ge 10 ]; then
		burst=$((rate / 10))
	fi

	qosdef_append_rule_ip_limit $ipaddr $operator $unit $rate $burst $connect
}

# append chain for static qos
qosdef_append_chain_sta() { # <hook> <name> <section> <unit> <rate>
	local hook=$1 name=$2
	local config=$3 operator

	case "$name" in
		upload) operator="saddr";;
		download) operator="daddr";;
	esac

	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter $hook 0 accept
	qosdef_append_rule_limit_whitelist $name
	config_foreach qosdef_append_rule_sta $config $operator $4 $7
	qosdef_appendx "\t}\n"
}

qosdef_flush_static() {
	qosdef_flush_table "$NFT_QOS_INET_FAMILY" qos-static
}

# static limit rate init
qosdef_init_static() {
	local hook_ul="prerouting" hook_dl="postrouting"

	[ "$2" = 0 ] || {
		logger -t qos-static "validation failed"
		return 1
	}

	[ $ipqos_enable -eq 0 -o \
		$ip_type = "dynamic" ] && return 1

	[ -z "$NFT_QOS_HAS_BRIDGE" ] && {
		hook_ul="postrouting"
		hook_dl="prerouting"
	}

	qosdef_appendx "table $NFT_QOS_INET_FAMILY qos-static {\n"
	qosdef_append_chain_sta $hook_ul upload user
	qosdef_append_chain_sta $hook_dl download user
	qosdef_appendx "}\n"
}
