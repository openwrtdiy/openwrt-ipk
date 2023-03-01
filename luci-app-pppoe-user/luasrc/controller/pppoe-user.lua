module("luci.controller.pppoe-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("pppoe-user/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "realtimetraffic"}, form("pppoe-user/realtimetraffic"), _("Realtime Traffic"), 2).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("pppoe-user/downtimeuser"), _("Downtime User"), 3).leaf = true
	entry({"admin", "status", "userstatus", "userup"}, form("pppoe-user/userup"), _("Online Log"), 4).leaf = true
	entry({"admin", "status", "userstatus", "userdown"}, form("pppoe-user/userdown"), _("Offline Log"), 5).leaf = true
	entry({"admin", "status", "userstatus", "userqos"}, form("pppoe-user/userqos"), _("QOS Log"), 6).leaf = true
	entry({"admin", "status", "userstatus", "rate"}, template("pppoe-qos/rate"), _("Rate"), 7).leaf = true
	entry({"admin", "status", "userstatus", "rate_status"}, call("action_rate")).leaf = true

	entry({"admin", "status", "networkstatus"}, alias("admin", "status", "networkstatus", "interfacelog"), _("Network Status"), 888)
	entry({"admin", "status", "networkstatus", "interfacelog"}, form("pppoe-user/interfacelog"), _("Interface Log"), 1).leaf = true
	entry({"admin", "status", "networkstatus", "interface"}, form("pppoe-user/interface"), _("Interface Information"), 2).leaf = true
	entry({"admin", "status", "networkstatus", "network"}, form("pppoe-user/network"), _("Network Information"), 3).leaf = true

	entry({"admin", "services", "pppoe-user"}, alias("admin", "services", "pppoe-user", "user"), _("Broadband Account Management"), 999)
	entry({"admin", "services", "pppoe-user", "user"}, cbi("pppoe-user/user"), _("User Manager")).leaf = true

	entry({"admin", "network", "bandwidth"}, alias("admin", "network", "bandwidth", "speed"), _("Broadband account speed limit"), 999)
	entry({"admin", "network", "bandwidth", "speed"}, cbi("pppoe-user/speed"), _("Traffic Control")).leaf = true
end

function _action_rate(rv, n)
	local c = nixio.fs.access("/proc/net/ipv6_route") and
		io.popen("nft list chain inet pppoe-qos-monitor " .. n .. " 2>/dev/null") or
		io.popen("nft list chain ip pppoe-qos-monitor " .. n .. " 2>/dev/null")

	if c then
		for l in c:lines() do
			local _, i, p, b = l:match(
				'^%s+ip ([^%s]+) ([^%s]+) counter packets (%d+) bytes (%d+)'
			)
			if i and p and b then
				-- handle expression
				rv[#rv + 1] = {
					rule = {
						family = "inet",
						table = "pppoe-qos-monitor",
						chain = n,
						handle = 0,
						expr = {
							{ match = { right = i } },
							{ counter = { packets = p, bytes = b } }
						}
					}
				}
			end
		end
		c:close()
	end
end

function action_rate()
	luci.http.prepare_content("application/json")
	local data = { nftables = {} }
	_action_rate(data.nftables, "upload")
	_action_rate(data.nftables, "download")
	luci.http.write_json(data)
end
