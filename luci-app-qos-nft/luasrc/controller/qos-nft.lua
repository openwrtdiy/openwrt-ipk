-- Licensed to the public under the Apache License 2.0.

module("luci.controller.qos-nft", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/qos-nft") then
		return
	end

	local e

	e = entry({"admin", "status", "realtime", "qosnft"}, template("qos-nft/realtime"), _("Rate"), 5)
	e.leaf = true
	e.acl_depends = { "luci-app-qos-nft" }

	e = entry({"admin", "status", "realtime", "qosnft_status"}, call("action_rate"))
	e.leaf = true
	e.acl_depends = { "luci-app-qos-nft" }

	e = entry({"admin", "network", "qos-nft"}, cbi("qos-nft/qos-nft"), _("QoS Nftables Beta"), 60)
	e.leaf = true
	e.acl_depends = { "luci-app-qos-nft" }
end

function _action_rate(rv, n)
	local c = nixio.fs.access("/proc/net/ipv6_route") and
		io.popen("nft list chain inet qos-monitor " .. n .. " 2>/dev/null") or
		io.popen("nft list chain ip qos-monitor " .. n .. " 2>/dev/null")

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
						table = "qos-monitor",
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
