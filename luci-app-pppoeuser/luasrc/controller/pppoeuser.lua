module("luci.controller.pppoeuser", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoeuser") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("pppoeuser/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("pppoeuser/downtimeuser"), _("Downtime User"), 2).leaf = true
	entry({"admin", "status", "userstatus", "userup"}, form("pppoeuser/userup"), _("Online Log"), 3).leaf = true
	entry({"admin", "status", "userstatus", "userdown"}, form("pppoeuser/userdown"), _("Offline Log"), 4).leaf = true
	entry({"admin", "status", "userstatus", "userqos"}, form("pppoeuser/userqos"), _("QOS Log"), 5).leaf = true
	entry({"admin", "status", "userstatus", "realtimetraffic"}, form("pppoeuser/realtimetraffic"), _("Realtime Rate"), 6).leaf = true
	entry({"admin", "status", "userstatus", "rate"}, template("realtime/rate"), _("Rate"), 7).leaf = true
	entry({"admin", "status", "userstatus", "rate_status"}, call("action_rate")).leaf = true

	entry({"admin", "status", "networkstatus"}, alias("admin", "status", "networkstatus", "interfacelog"), _("Network Status"), 888)
	entry({"admin", "status", "networkstatus", "interfacelog"}, form("pppoeuser/interfacelog"), _("Interface Log"), 1).leaf = true
	entry({"admin", "status", "networkstatus", "interface"}, form("pppoeuser/interface"), _("Interface Information"), 2).leaf = true
	entry({"admin", "status", "networkstatus", "network"}, form("pppoeuser/network"), _("Network Information"), 3).leaf = true

	entry({"admin", "services", "pppoeuser"}, alias("admin", "services", "pppoeuser", "user"), _("User Manager"), 777)
	entry({"admin", "services", "pppoeuser", "user"}, cbi("pppoeuser/user"), _("User Manager"), 1).leaf = true
	entry({"admin", "services", "pppoeuser", "options"}, cbi("pppoeuser/options"), _("Management Options"), 2).leaf = true

	entry({"admin", "network", "bandwidth"}, alias("admin", "network", "bandwidth", "speed"), _("Account speed limit"), 666)
	entry({"admin", "network", "bandwidth", "speed"}, cbi("pppoeuser/speed"), _("Traffic Control")).leaf = true
end

function _action_rate(rv, n)
	local c = nixio.fs.access("/proc/net/ipv6_route") and
		io.popen("nft list chain inet nft-qos-monitor " .. n .. " 2>/dev/null") or
		io.popen("nft list chain ip nft-qos-monitor " .. n .. " 2>/dev/null")

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
						table = "nft-qos-monitor",
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
