#!/bin/sh

. /lib/pppoe-qos/core.sh

qosdef_validate_static() {
	uci_load_validate pppoe-qos default "$1" "$2" \
		'limit_ip_enable:bool:0' \
		'ip_type:maxlength(8)'
}

# append rule for static qos
qosdef_append_rule_sta() { # <section> <operator> <default-unit> <default-rate>
	local ipaddr unit rate
	local operator=$2

	config_get ipaddr $1 ipaddr
	if [ "$operator" = "saddr" ]; then
		config_get rate $1 urate $3
		config_get unit $1 unit $4
	else
		config_get rate $1 drate $3
		config_get unit $1 unit $4
	fi

	[ -z "$ipaddr" ] && return

	qosdef_append_rule_ip_limit $ipaddr $operator $unit $rate
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
	config_foreach qosdef_append_rule_sta $config $operator $4 $5
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

	[ $limit_ip_enable -eq 0 ] && return 1

	[ -z "$NFT_QOS_HAS_BRIDGE" ] && {
		hook_ul="postrouting"
		hook_dl="prerouting"
	}

	qosdef_appendx "table $NFT_QOS_INET_FAMILY qos-static {\n"
	qosdef_append_chain_sta $hook_ul upload user
	qosdef_append_chain_sta $hook_dl download user
	qosdef_appendx "}\n"
}
