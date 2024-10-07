#!/bin/sh

. /lib/qos-nft/core.sh

qosdef_monitor_get_ip_handle() { # <family> <chain> <ip>
	echo $(nft -a list chain $1 qos-monitor $2 2>/dev/null | grep $3 | awk '{print $11}')
}

qosdef_monitor_add() { # <mac> <ip> <hostname>
	handle_ul=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY upload $2)
	[ -z "$handle_ul" ] && {
		nft add rule $NFT_QOS_INET_FAMILY qos-monitor upload ip saddr $2 counter
		nft add rule $NFT_QOS_INET_FAMILY qos-monitor upload ip saddr $2 ct state new,established,related counter
	}
	handle_dl=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY download $2)
	[ -z "$handle_dl" ] && {
		nft add rule $NFT_QOS_INET_FAMILY qos-monitor download ip daddr $2 counter
		nft add rule $NFT_QOS_INET_FAMILY qos-monitor download ip daddr $2 ct state new,established,related counter
	}
}

qosdef_monitor_del() { # <mac> <ip> <hostname>
	local handle_ul handle_dl
	handle_ul=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY upload $2)
	handle_dl=$(qosdef_monitor_get_ip_handle $NFT_QOS_INET_FAMILY download $2)
	[ -n "$handle_ul" ] && nft delete handle $handle_ul
	[ -n "$handle_dl" ] && nft delete handle $handle_dl
}

# init qos monitor
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
