local nixio = require "nixio"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()

local m, s, o
m = Map("pppoe-server")

s = m:section(TypedSection, "firewall")
s.anonymous = true

o = s:option(Flag, "isolation", translate("Disable Access Gateway"), translate("Forbid dial-up users to access the PPPoE server management background"))
o.rmempty = false
o.default = 0

o = s:option(Value, "conntrackmax", translate("Maximum number of connections"), translate("Adjust the maximum number of active connections"))
o.datatype = "range(16384,4194304)"
o:value("16384", translate("16384 Memory 1GB"))
o:value("65536", translate("65536 Memory 4GB"))
o:value("262144", translate("262144 Memory 8GB"))
o:value("524288", translate("524288 Memory 16GB"))
o:value("1048576", translate("1048576 Memory 32GB"))
o:value("2097152", translate("2097152 Memory 64GB"))
o:value("4194304", translate("4194304 Memory 128GB"))
o.default = 65536

return m
