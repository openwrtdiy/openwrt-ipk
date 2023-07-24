-- Licensed to the public under the Apache License 2.0.

module("luci.controller.pppoe-qos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-qos") then
		return
	end

	local e

	e = entry({"admin", "status", "realtime", "rate"}, template("pppoe-qos/rate"), _("Rate"), 5)
	e.leaf = true
	e.acl_depends = { "luci-app-pppoe-qos" }

	e = entry({"admin", "status", "realtime", "rate_status"}, call("action_rate"))
	e.leaf = true
	e.acl_depends = { "luci-app-pppoe-qos" }

	e = entry({"admin", "network", "pppoe-qos"}, cbi("pppoe-qos/pppoe-qos"), _("QoS over Nftables"), 60)
	e.leaf = true
	e.acl_depends = { "luci-app-pppoe-qos" }
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
