local nixio = require "nixio"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()

local m, s, o
m = Map("pppoe-server")

s = m:section(TypedSection, "firewall")
s.addremove = false
s.anonymous = true

o = s:option(Flag, "isolation", translate("Disable Access Gateway"))
o.rmempty = false
o.default = 1

o = s:option(Value, "conntrackmax", translate("Maximum number of connections"))
o.datatype = "port"
o.default = 655350

return m
