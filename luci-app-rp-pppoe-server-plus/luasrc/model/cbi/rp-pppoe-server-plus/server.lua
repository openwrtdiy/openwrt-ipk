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

m = Map("pppoe-server")

s = m:section(TypedSection, "server")
s.description = translate("Running State : " .. status .. "</br></br>")
s.anonymous = true

e = s:option(Flag, "enabled", translate("Enable"), translate("Enable PPPoE Server"))
e.rmempty = false
e.default = 1

o = s:option(Value, "interface", translate("Interface"), translate("Interface on which to listen."))
o.template = "cbi/network_netlist"
o.nocreate = true

o = s:option(Value, "ac_name", translate("AC-Name"), translate("PPPOE Access Concentrator Name"))
o.rmempty = true

o = s:option(DynamicList, "service_name", translate("Service-Name"), translate("Advertise specified service-name"))
o.rmempty = true

o = s:option(Value, "maxsessionsperpeer", translate("Maximum sessions per peer"), translate("Limit the number of sessions per account"))
o.placeholder = translate("0")
o.rmempty = true
o.datatype = "range(0,9)"

o = s:option(Value, "localip", translate("Server IP address"), translate("Set local IP address"))
o.datatype = "ipaddr"
o.default = "10.0.0.1"
o:value("10.0.0.1")
o:value("10.255.255.1")
o:value("172.16.0.1")
o:value("172.31.255.1")
o:value("192.168.0.1")
o:value("192.168.255.1")

o = s:option(Value, "firstremoteip", translate("Client IP address"), translate("Set start address of remote IP pool"))
o.datatype = "ipaddr"
o.default = "10.67.0.1"
o:value("10.10.0.1")
o:value("10.10.16.1")
o:value("10.50.0.1")
o:value("10.50.16.1")
o:value("10.67.0.1")
o:value("10.67.16.1")
o:value("10.100.0.1")
o:value("10.100.16.1")
o:value("10.150.0.1")
o:value("10.150.16.1")
o:value("10.200.0.1")
o:value("10.200.16.1")
o:value("10.250.0.1")
o:value("10.250.16.1")

o = s:option(ListValue, "maxsessions", translate("Number of client IP addresses"), translate("Allow 'num' concurrent sessions"))
o.default = "1024"
o.rmempty = true
o:value("1", translate("1 Max Subnet 255.255.255.255 Mask"))
o:value("2", translate("2 Max Subnet 255.255.255.254 Mask"))
o:value("4", translate("4 Max Subnet 255.255.255.252 Mask"))
o:value("8", translate("8 Max Subnet 255.255.255.248 Mask"))
o:value("16", translate("16 Max Subnet 255.255.255.240 Mask"))
o:value("32", translate("32 Max Subnet 255.255.255.224 Mask"))
o:value("64", translate("64 Max Subnet 255.255.255.192 Mask"))
o:value("128", translate("128 Max Subnet 255.255.255.128 Mask"))
o:value("256", translate("256 Max Subnet 255.255.255.0 Mask"))
o:value("512", translate("512 Max Subnet 255.255.254.0 Mask"))
o:value("1024", translate("1024 Max Subnet 255.255.252.0 Mask"))
o:value("2048", translate("2048 Max Subnet 255.255.248.0 Mask"))
o:value("4096", translate("4096 Max Subnet 255.255.240.0 Mask"))
o:value("8192", translate("8192 Max Subnet 255.255.224.0 Mask"))
o:value("16384", translate("16384 Max Subnet 255.255.192.0 Mask"))
o:value("32768", translate("32768 Max Subnet 255.255.128.0 Mask"))
o:value("65536", translate("65536 Max Subnet 255.255.0.0 Mask"))

o = s:option(Value, "optionsfile", translate("Options file"), translate("Use PPPD options from specified file"))
o.placeholder = translate("/etc/ppp/pppoe-server-options")
o.default = "/etc/ppp/pppoe-server-options"
o.rmempty = true

o = s:option(Flag, "randomsessions", translate("Random Sessions"), translate("Randomly assign client IP addresses"))
o.rmempty = false

o = s:option(Flag, "unit", translate("Unit"), translate("Randomly assign ppp interface numbers"))
o.rmempty = false

o = s:option(Value, "offset", translate("Offset"), translate("Random PPPoE session number"))
o.placeholder = translate("0")
o.rmempty = true
o.datatype = "range(0,9)"
o.default = 0

o = s:option(Value, "timeout", translate("Timeout"), translate("Specify inactivity timeout in seconds"))
o.placeholder = translate("60")
o.rmempty = true
o.datatype = "range(60,180)"
o.default = 60

o = s:option(Value, "mss", translate("MSS"), translate("Clamp incoming and outgoing MSS options"))
o.placeholder = translate("1468")
o.rmempty = true
o.datatype = "uinteger"
o.default = 1468

o = s:option(Flag, "sync", translate("Sync"), translate("Use synchronous PPP mode"))
o.rmempty = true
o.default = false

return m
