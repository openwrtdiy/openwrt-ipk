local nixio = require "nixio"
local net = require "luci.model.network".init()
local sys = require "luci.sys"
local ifaces = sys.net:devices()
local m, s, o

if luci.sys.call("pidof pppoe-server >/dev/null") == 0 then
	status = translate("<b><font color=\"green\">Running</font></b>")
else
	status = translate("<b><font color=\"red\">Not running</font></b>")
end

m = Map("pppoe", translate("Roaring Penguin PPPoE Server Plus"), translate("PPPoE Server Configuration"))

s = m:section(TypedSection, "server")
s.description = translate("Running State : " .. status .. "</br></br>")
s.anonymous = true

e = s:option(Flag, "enabled", translate("Enable"), translate("Enable PPPoE Server"))
e.rmempty = false
e.default = 1

o = s:option(Value, "interface", translate("Interface"), translate("Interface on which to listen."))
o.template = "cbi/network_netlist"
o.nocreate = true

o = s:option(Value, "ac_name", translate("Access Concentrator Name"), translate("Set access concentrator name"))
o.optional = true

o = s:option(DynamicList, "service_name", translate("Service Name"), translate("Advertise specified service-name"))
o.optional = true

o = s:option(Value, "maxsessionsperpeer", translate("Maximum sessions per peer"), translate("Limit to 'n' sessions/MAC address"))
o.placeholder = translate("0")
o.optional = true
o.datatype = "uinteger"

o = s:option(Value, "localip", translate("IP of listening side"), translate("Set local IP address"))
o.placeholder = translate("10.0.0.1")
o.datatype = "ipaddr"

o = s:option(Value, "firstremoteip", translate("First remote IP"), translate("Set start address of remote IP pool"))
o.placeholder = translate("10.67.15.1")
o.datatype = "ipaddr"

o = s:option(Value, "maxsessions", translate("Maximum sessions"), translate("Allow 'num' concurrent sessions"))
o.placeholder = translate("64")
o.optional = true
o.datatype = "uinteger"
o.default = 64

o = s:option(Value, "optionsfile", translate("Options file"), translate("Use PPPD options from specified file"))
o.placeholder = translate("/etc/ppp/pppoe-server-options")
o.default = "/etc/ppp/pppoe-server-options"
o.optional = true

o = s:option(Flag, "randomsessions", translate("Random session selection"), translate("Instead of starting at beginning and going to end, randomize session number"))
o.optional = true

o = s:option(Value, "unit", translate("Unit"), translate("Pass 'unit' option to pppd"))
o.placeholder = translate("0")
o.optional = true
o.datatype = "uinteger"
o.default = 0

o = s:option(Value, "offset", translate("Offset"), translate("Assign session numbers starting at offset+1"))
o.placeholder = translate("0")
o.optional = true
o.datatype = "uinteger"
o.default = 0

o = s:option(Value, "timeout", translate("Timeout"), translate("Specify inactivity timeout in seconds"))
o.placeholder = translate("60")
o.optional = true
o.datatype = "uinteger"
o.default = 60

o = s:option(Value, "mss", translate("MSS"), translate("Clamp incoming and outgoing MSS options"))
o.placeholder = translate("1468")
o.optional = true
o.datatype = "uinteger"
o.default = 1468

o = s:option(Flag, "sync", translate("Sync"), translate("Use synchronous PPP mode"))
o.optional = true
o.default = false

return m
