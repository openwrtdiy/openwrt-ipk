#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_validate_dynamic() {
    uci_load_validate qos-nft default "$1" "$2" \
        'qos_enable:bool:0' \
        'qos_type:maxlength(8)'
}

# Append dynamic rule based on the operator (saddr or daddr)
qosdef_append_rule_dym() {
    local qos cidr4 rate unit operator
    operator=$2

    config_get qos $1 qos
    config_get cidr4 $1 cidr4
    [ "$qos" != "1" ] && return

    if [ "$operator" = "saddr" ]; then
        config_get rate $1 urate $3
        config_get unit $1 unit $4
        config_list_foreach $1 whitelist add_whitelist_rule "saddr"
    else
        config_get rate $1 drate $3
        config_get unit $1 unit $4
        config_list_foreach $1 whitelist add_whitelist_rule "daddr"
    fi

    [ -z "$cidr4" ] && return

    if [ "$unit" = "mbps" ]; then
        rate=$((rate * 125))  # Convert mbps to kbytes per second
        unit="kbytes"
    fi
    
    qosdef_append_rule_dym_limit "$cidr4" "$operator" "$unit" "$rate"
}

# General function to add whitelist rules based on address type (saddr/daddr)
add_whitelist_rule() {
    local ipaddr=$1
    local operator=$2
    qosdef_appendx "\t\tip $operator $ipaddr accept\n"
}

# Append dynamic subnet chain for upload/download
qosdef_append_chain_dym_subnet() {
	local hook=$1 name=$2
	local config=$3 operator

	case "$name" in
		upload) operator="saddr";;
		download) operator="daddr";;
	esac

	qosdef_appendx "\ttable inet qos-dynamic {\n"
	qosdef_appendx "\tchain $name {\n"
	qosdef_append_chain_def filter "$hook" 0 accept
	config_foreach qosdef_append_rule_dym "$config" "$operator" "$4" "$7"
	qosdef_appendx "\t}\n"
	qosdef_appendx "}\n"	
}

# Flush dynamic QoS table
qosdef_flush_dynamic() {
	qosdef_flush_table "$NFT_QOS_INET_FAMILY" qos-dynamic
}

# Initialize dynamic QoS settings
qosdef_init_dynamic() {
	local hook_ul="prerouting" hook_dl="postrouting"

	if [ "$qos_enable" -eq 0 ] || [ "$qos_type" != "dynamic" ]; then
        return 1
	fi

	[ "$2" = 0 ] || {
		logger -t qos-dynamic "validation failed"
		return 1
	}

	qosdef_append_chain_dym_subnet "$hook_ul" "upload" "subnet"
	qosdef_append_chain_dym_subnet "$hook_dl" "download" "subnet"
}
