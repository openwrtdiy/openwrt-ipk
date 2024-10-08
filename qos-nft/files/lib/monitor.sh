#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_monitor_get_ip_handle() { # <family> <chain> <ip>
    echo $(nft -a list chain $1 qos-monitor $2 2>/dev/null | grep $3 | awk '{print $11}')
}

qosdef_monitor_add() { # <mac> <ip> <hostname>
    for direction in upload download; do
        local key="saddr"
        [ "$direction" = "download" ] && key="daddr"
        local handle=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY $direction $2)

        [ -z "$handle" ] && {
            nft add rule $NFT_QOS_INET_FAMILY qos-monitor $direction ip $key $2 counter
        }
    done
}

qosdef_monitor_del() { # <mac> <ip> <hostname>
    for direction in upload download; do
        local key="saddr"
        [ "$direction" = "download" ] && key="daddr"
        local handle=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY $direction $2)

        [ -n "$handle" ] && nft delete handle $handle
    done
}

qosdef_init_monitor() {
    local hook_ul="prerouting" hook_dl="postrouting"

    [ -z "$NFT_QOS_HAS_BRIDGE" ] && {
        hook_ul="postrouting"
        hook_dl="prerouting"
    }

    nft add table $NFT_QOS_INET_FAMILY qos-monitor
    nft add chain $NFT_QOS_INET_FAMILY qos-monitor upload { type filter hook $hook_ul priority 0\; }
    nft add chain $NFT_QOS_INET_FAMILY qos-monitor download { type filter hook $hook_dl priority 0\; }
}
