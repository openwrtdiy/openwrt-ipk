#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_validate_dynamic() {
	uci_load_validate qos-nft default "$1" "$2" \
		'qos_enable:bool:0' \
		'qos_type:maxlength(8)'
}

qosdef_append_rule_dym() {
    local qos cidr4 rate unit whitelist
    local operator=$2

    config_get qos $1 qos
    config_get cidr4 $1 cidr4
    if [ "$qos" != "1" ]; then
        return
    fi

    if [ "$operator" = "saddr" ]; then
        config_get rate $1 urate $3
        config_get unit $1 unit $4
        config_get whitelist $1 whitelist $5
    else
        config_get rate $1 drate $3
        config_get unit $1 unit $4
        config_get whitelist $1 whitelist $5
    fi

    [ -z "$cidr4" ] && return

    if [ "$unit" = "mbps" ]; then
        rate=$((rate * 125))
        unit="kbytes"
    fi
    
   # Append rule for IP addresses to `table inet qos-dynamic`
    qosdef_append_rule_dym_limit $cidr4 $operator $unit $rate $whitelist
}

qosdef_append_chain_dym_subnet() {
	local hook=$1 name=$2
	local config=$3 operator

	case "$name" in
		upload) operator="saddr";;
		download) operator="daddr";;
	esac

	qosdef_appendx "\ttable inet qos-dynamic {\n"
	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter $hook 0 accept
	qosdef_append_rule_whitelist $name
	config_foreach qosdef_append_rule_dym $config $operator $4 $7
	qosdef_appendx "\t}\n"
	qosdef_appendx "}\n"	
}

qosdef_flush_dynamic() {
	qosdef_flush_table "$NFT_QOS_INET_FAMILY" qos-dynamic
}

qosdef_init_dynamic() {
	local hook_ul="prerouting" hook_dl="postrouting"

	# Only proceed if IP QoS is enabled and IP type is dynamic
	if [ "$qos_enable" -eq 0 ] || [ "$qos_type" != "dynamic" ]; then
        return 1
	fi

	[ "$2" = 0 ] || {
		logger -t qos-dynamic "validation failed"
		return 1
	}

	# Append dynamic IP and MAC rules
	qosdef_append_chain_dym_subnet $hook_ul upload subnet
	qosdef_append_chain_dym_subnet $hook_dl download subnet
}
