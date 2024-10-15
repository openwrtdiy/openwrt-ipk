#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_validate_static() {
	uci_load_validate qos-nft default "$1" "$2" \
		'qos_enable:bool:0' \
		'ip_type:maxlength(8)'
}

qosdef_append_rule_sta() {
    local qos ipaddr rate unit burst connect
    local operator=$2

    config_get qos $1 qos
    config_get ipaddr $1 ipaddr
    if [ "$qos" != "1" ]; then
        return
    fi

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

    if [ "$unit" = "mbps" ]; then
        rate=$((rate * 125))
        unit="kbytes"
    fi
    
    if [ -z "$burst" ] && [ "$rate" -ge 10 ]; then
        burst=$((rate / 10))
    fi

    # Append rule for IP addresses to `table inet qos-static`
    qosdef_append_rule_ip_limit $ipaddr $operator $unit $rate $burst $connect
}

qosdef_append_chain_sta_ip() {
	local hook=$1 name=$2
	local config=$3 operator

	case "$name" in
		upload) operator="saddr";;
		download) operator="daddr";;
	esac

	qosdef_appendx "\ttable inet qos-static {\n"
	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter $hook 0 accept
	qosdef_append_rule_whitelist $name
	config_foreach qosdef_append_rule_sta $config $operator $4 $7
	qosdef_appendx "\t}\n"
	qosdef_appendx "}\n"
}

# MAC address rules
qosdef_append_rule_mac_sta() {
    local macaddr rate unit burst connect
    local operator=$2

    config_get qos $1 qos
    config_get macaddr $1 macaddr
    if [ "$qos" != "1" ]; then
        return
    fi

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

    [ -z "$macaddr" ] && return

    if [ "$unit" = "mbps" ]; then
        rate=$((rate * 125))
        unit="kbytes"
    fi
    
    if [ -z "$burst" ] && [ "$rate" -ge 10 ]; then
        burst=$((rate / 10))
    fi

    # Append rule for MAC addresses to `table bridge qos-static`
    qosdef_append_rule_mac_limit $macaddr $operator $unit $rate $burst $connect
}

qosdef_append_chain_sta_mac() {
	local hook=$1 name=$2
	local config=$3 operator

	case "$name" in
		upload) operator="saddr";;
		download) operator="daddr";;
	esac

	qosdef_appendx "\ttable bridge qos-static {\n"
	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter $hook 0 accept
	qosdef_append_rule_whitelist $name
	config_foreach qosdef_append_rule_mac_sta $config $operator $4 $7
	qosdef_appendx "\t}\n"
	qosdef_appendx "}\n"
}

qosdef_flush_static() {
	qosdef_flush_table "$NFT_QOS_INET_FAMILY" qos-static
	qosdef_flush_table bridge qos-static
}

qosdef_init_static() {
	local hook_ul="prerouting" hook_dl="postrouting"
	
	# Only proceed if IP QoS is enabled and IP type is static
	if [ "$qos_enable" -eq 0 ] || [ "$ip_type" != "static" ]; then
        return 1
	fi

	[ "$2" = 0 ] || {
		logger -t qos-static "validation failed"
		return 1
	}

	# Append static IP and MAC rules
	qosdef_append_chain_sta_ip $hook_ul upload host
	qosdef_append_chain_sta_ip $hook_dl download host
	qosdef_append_chain_sta_mac $hook_ul upload host
	qosdef_append_chain_sta_mac $hook_dl download host
}
