#!/bin/sh
#
# for uci_validate_section()
. /lib/functions/procd.sh

NFT_QOS_HAS_BRIDGE=""
NFT_QOS_INET_FAMILY=""
NFT_QOS_SCRIPT_TEXT=""
NFT_QOS_SCRIPT_FILE="/tmp/qos.nft"

qosdef_appendx() { # <string to be appended>
	NFT_QOS_SCRIPT_TEXT="$NFT_QOS_SCRIPT_TEXT""$1"
}

qosdef_append_chain_def() { # <type> <hook> <priority> <policy>
	qosdef_appendx "\t\ttype $1 hook $2 priority $3; policy $4;\n"
}

qosdef_append_chain_ingress() { # <type> <device> <priority> <policy>
	qosdef_appendx "\t\ttype $1 hook ingress device $2 priority $3; policy $4;\n"
}

qosdef_append_rule_ip_limit() { # <ipaddr> <operator> <unit> <rate>
	local ipaddr=$1
	local operator=$2
	local unit=$3
	local rate=$4
	local burst=$5
	local connect=$6

	qosdef_appendx "\t\tip $operator $ipaddr limit rate over $rate $unit/second burst $burst kbytes drop\n"
    
	if [ -n "$connect" ]; then
	    qosdef_appendx "\t\tip $operator $ipaddr ct state new limit rate $connect/minute accept\n"
	    qosdef_appendx "\t\tip $operator $ipaddr ct count over $connect drop\n"
	fi
}

qosdef_append_rule_mac_limit() { # <macaddr> <operator> <unit> <rate>
	local macaddr=$1
	local operator=$2
	local unit=$3
	local rate=$4
	local burst=$5
	local connect=$6

	qosdef_appendx "\t\tether $operator $macaddr limit rate over $rate $unit/second burst $burst kbytes drop\n"
    
	if [ -n "$connect" ]; then
	    qosdef_appendx "\t\tether $operator $macaddr ct state new limit rate $connect/minute accept\n"
	    qosdef_appendx "\t\tether $operator $macaddr ct count over $connect drop\n"
	fi
}

qosdef_append_rule_dym_limit() { # <ipaddr> <operator> <unit> <rate>
	local cidr4=$1
	local operator=$2
	local unit=$3
	local rate=$4
	local whitelist=$5
	
    if [ -n "$whitelist" ]; then
        for ip in $whitelist; do
            qosdef_appendx "\t\tip $operator $ip accept\n"
        done
        qosdef_appendx "\t\tip $operator $cidr4 limit rate over $rate $unit/second drop\n"
    else
        qosdef_appendx "\t\tip $operator $cidr4 limit rate over $rate $unit/second drop\n"
    fi
}

qosdef_flush_table() { # <family> <table>
	nft flush table $1 $2 2>/dev/null
}

qosdef_remove_table() { # <family> <table>
	nft delete table $1 $2 2>/dev/null
}

qosdef_init_header() { # add header for nft script
	qosdef_appendx "#!/usr/sbin/nft -f\n"
}

qosdef_init_env() {
    local lt="$(uci_get "network.lan.device")"
    [ "$lt" = "br-lan" ] && export NFT_QOS_HAS_BRIDGE="y"

    if [ "$(sysctl net.ipv6.conf.all.disable_ipv6)" != "1" ]; then
        export NFT_QOS_INET_FAMILY="inet"
    fi
}

qosdef_clean_cache() {
    [ -f "$NFT_QOS_SCRIPT_FILE" ] && rm -f "$NFT_QOS_SCRIPT_FILE"
}

qosdef_init_done() {
	printf "%b" "$NFT_QOS_SCRIPT_TEXT" > "$NFT_QOS_SCRIPT_FILE" 2>/dev/null
}

qosdef_start() {
    nft -f $NFT_QOS_SCRIPT_FILE 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Failed to start QoS with nft."
    fi
}
