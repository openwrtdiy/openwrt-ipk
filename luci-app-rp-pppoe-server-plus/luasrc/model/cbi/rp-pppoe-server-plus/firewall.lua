local nixio = require "nixio"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()

local m, s, o
m = Map("pppoe-server")

s = m:section(TypedSection, "firewall")
s.anonymous = true

o = s:option(Flag, "isolation", translate("Disable Access Gateway"))
o.rmempty = false
o.default = 1

o = s:option(Value, "conntrackmax", translate("Maximum number of connections"))
o.datatype = "range(16384,4194304)"
o:value("16384", translate("16384 Memory 64MB"))
o:value("32768", translate("32768 Memory 128MB"))
o:value("65536", translate("65536 Memory 256MB"))
o:value("131072", translate("131072 Memory 512MB"))
o:value("262144", translate("262144 Memory 1GB"))
o:value("524288", translate("524288 Memory 2GB"))
o:value("1048576", translate("1048576 Memory 4GB"))
o:value("2097152", translate("2097152 Memory 8GB"))
o:value("4194304", translate("4194304 Memory 16GB"))
o.default = 16384

return m
