local nixio = require "nixio"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()

local m, s, o
m = Map("pppoe-server", translate("Roaring Penguin PPPoE Server Plus"))

s = m:section(TypedSection, "firewall")
s.addremove = true
s.anonymous = true

o = s:option(Flag, "ENNAT", translate("Enabled NAT"))
o.rmempty = false

o = s:option(Flag, "ENISO", translate("Isolate Firewall"))
o.rmempty = false

o = s:option(ListValue, "export_interface", translate("Export Interface"), translate("Specify interface forwarding traffic."))
o:value("", translate("--Default--"))
o.rmempty = true
for _, iface in ipairs(ifaces) do
    if (iface:match("^br*") or iface:match("^eth*") or iface:match("^pppoe*") or
        iface:match("wlan*")) then
        local nets = net:get_interface(iface)
        nets = nets and nets:get_networks() or {}
        for k, v in pairs(nets) do nets[k] = nets[k].sid end
        nets = table.concat(nets, ",")
        o:value(iface, ((#nets > 0) and "%s (%s)" % {iface, nets} or iface))
    end
end
o:depends("ENNAT", "1")

o = s:option(Value, "conntrackmax", translate("Maximum number of connections"))
o.datatype = "port"
o.default = 16384

return m
