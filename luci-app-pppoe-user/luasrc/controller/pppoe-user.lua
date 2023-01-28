module("luci.controller.pppoe-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("Broadband User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("pppoe-user/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "realtimetraffic"}, form("pppoe-user/realtimetraffic"), _("Realtime Traffic"), 2).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("pppoe-user/downtimeuser"), _("Downtime User"), 3).leaf = true
	entry({"admin", "status", "userstatus", "onlinelog"}, form("pppoe-user/onlinelog"), _("Online Log"), 4).leaf = true
	entry({"admin", "status", "userstatus", "offlinelog"}, form("pppoe-user/offlinelog"), _("Offline Log"), 5).leaf = true

	entry({"admin", "status", "userstatus", "rate"}, form("nft-qos/rate"), _("Rate"), 6).leaf = true
	entry({"admin", "status", "userstatus", "rate_status"}, call("action_rate"), _("Rate")).leaf = true

	entry({"admin", "services", "pppoe-user"}, alias("admin", "services", "pppoe-user", "user"), _("Broadband Account Management"), 99)
	entry({"admin", "services", "pppoe-user", "user"}, cbi("pppoe-user/user"), _("User Manager")).leaf = true
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
