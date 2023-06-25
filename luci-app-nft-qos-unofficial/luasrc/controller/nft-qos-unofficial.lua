-- Copyright 2018 Rosy Song <rosysong@rosinson.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.nft-qos-unofficial", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/nft-qos-unofficial") then
		return
	end

	local e

	e = entry({"admin", "status", "userstatus", "rate"}, template("nft-qos-unofficial/rate"), _("Rate"), 9)
	e.leaf = true
	e.acl_depends = { "luci-app-nft-qos-unofficial" }

	e = entry({"admin", "status", "userstatus", "rate_status"}, call("action_rate"))
	e.leaf = true
	e.acl_depends = { "luci-app-nft-qos-unofficial" }

	e = entry({"admin", "network", "nft-qos-unofficial"}, cbi("nft-qos-unofficial/nft-qos-unofficial"), _("QoS over Nftables"), 100)
	e.leaf = true
	e.acl_depends = { "luci-app-nft-qos-unofficial" }
end

function _action_rate(rv, n)
	local c = nixio.fs.access("/proc/net/ipv6_route") and
		io.popen("nft list chain inet nft-qos-unofficial-monitor " .. n .. " 2>/dev/null") or
		io.popen("nft list chain ip nft-qos-unofficial-monitor " .. n .. " 2>/dev/null")

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
						table = "nft-qos-unofficial-monitor",
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
