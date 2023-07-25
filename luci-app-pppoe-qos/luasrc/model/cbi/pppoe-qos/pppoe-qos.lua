-- Licensed to the public under the Apache License 2.0.

local uci = require("luci.model.uci").cursor()
local wa = require("luci.tools.webadmin")
local fs = require("nixio.fs")
local ipc = require("luci.ip")

local enable_priority = uci:get("pppoe-qos", "default", "priority_enable")
local ipqos_enable = uci:get("pppoe-qos", "default", "ipqos_enable")
local ip_type = uci:get("pppoe-qos", "default", "ip_type")
local macqos_enable = uci:get("pppoe-qos", "default", "macqos_enable")

local has_ipv6 = fs.access("/proc/net/ipv6_route")

m = Map("pppoe-qos", translate("QoS over Nftables"))

--
-- Taboptions
--
s = m:section(TypedSection, "default", translate("Qos Nft Settings"))
s.addremove = false
s.anonymous = true

s:tab("priority", translate("Traffic Priority"))
s:tab("limitip", translate("Limit Rate by IP Address"))
s:tab("limitmac", translate("Limit Rate by Mac Address"))

--
-- Priority
--
o = s:taboption("priority", Flag, "priority_enable", translate("Traffic Priority"), translate("Enable Traffic Priority"))
o.default = enable_priority or o.enabled
o.rmempty = false

o = s:taboption("priority", ListValue, "priority_netdev", translate("Default Network Interface"), translate("Network Interface for Traffic Shaping, e.g. br-lan, eth0.1, eth0, etc."))
o:depends("priority_enable", "1")
wa.cbi_add_networks(o)

--
-- Static
--
o = s:taboption("limitip", Flag, "ipqos_enable", translate("IP Qos"), translate("Enable Limit IP Rate Feature"))
o.default = ipqos_enable or o.enabled
o.rmempty = false

o = s:taboption("limitip", ListValue, "ip_type", translate("Limit Type"), translate("Type of Limit Rate"))
o.default = "static"
o:depends("ipqos_enable","1")
o:value("static", "Static")
o:value("dynamic", "Dynamic")

--
-- Dynamic
--

o = s:taboption("limitip", Value, "dynamic_bw_up", translate("Upload Bandwidth (Mbps)"), translate("Data Transfer Rate: 100 Mbps/s = 12500 KBytes/s"))
o.placeholder = translate("1 Mbps/s = 125 KBytes/s")
o.default = '100'
o.datatype = "uinteger"
o:depends("ip_type","dynamic")

o = s:taboption("limitip", Value, "dynamic_bw_down", translate("Download Bandwidth (Mbps)"), translate("Data Transfer Rate: 100 Mbps/s = 12500 KBytes/s"))
o.placeholder = translate("1 Mbps/s = 125 KBytes/s")
o.default = '100'
o.datatype = "uinteger"
o:depends("ip_type","dynamic")

o = s:taboption("limitip", Value, "dynamic_cidr", translate("Target Network (IPv4/MASK)"), translate("Network to be applied, e.g. 192.168.100.0/24, 10.2.0.0/16, etc."))
o.placeholder = translate("192.168.100.0/24")
o.datatype = "cidr4"
ipc.routes({ family = 4, type = 1 }, function(rt) o.default = rt.dest end)
o:depends("ip_type","dynamic")

if has_ipv6 then
	o = s:taboption("limitip", Value, "dynamic_cidr6", translate("Target Network6 (IPv6/MASK)"), translate("Network to be applied, e.g. AAAA::BBBB/64, CCCC::1/128, etc."))
	o.placeholder = translate("AAAA::BBBB/64")
	o.datatype = "cidr6"
	o:depends("ip_type","dynamic")
end

o = s:taboption("limitip", DynamicList, "limit_whitelist", translate("White List for Limit Rate"), translate("Network to be applied, e.g. 192.168.100.2, 192.168.100.0/24, etc."))
o.placeholder = translate("192.168.100.2 192.168.99.0/24")
o.datatype = "ipaddr"
o:depends("ipqos_enable","1")

--
-- limit speed by mac address
--
o = s:taboption("limitmac", Flag, "macqos_enable", translate("MAC Qos"), translate("Enable Limit MAC Rate Feature"))
o.default = macqos_enable or o.enabled
o.rmempty = false

--
-- Traffic Priority Settings
--
if enable_priority == "1" then

	s = m:section(TypedSection, "priority", translate("Traffic Priority Settings"))
	s.anonymous = true
	s.addremove = true
	s.template = "cbi/tblsection"

	o = s:option(ListValue, "protocol", translate("Protocol"))
	o.default = "tcp"
	o:value("tcp", "TCP")
	o:value("udp", "UDP")
	o:value("udplite", "UDP-Lite")
	o:value("sctp", "SCTP")
	o:value("dccp", "DCCP")

	o = s:option(ListValue, "priority", translate("Priority"))
	o.default = "1"
	o:value("-400", "1")
	o:value("-300", "2")
	o:value("-225", "3")
	o:value("-200", "4")
	o:value("-150", "5")
	o:value("-100", "6")
	o:value("0", "7")
	o:value("50", "8")
	o:value("100", "9")
	o:value("225", "10")
	o:value("300", "11")

	o = s:option(Value, "service", translate("Service"))
	o.placeholder = translate("e.g. https, 23, (separator is comma)")
	o.default = ''

	o = s:option(Value, "comment", translate("Comment"))
	o.default = '?'

end

--
-- Static Limit Rate
--
if ipqos_enable == "1" and ip_type == "static" then

	y = m:section(TypedSection, "user", translate("Static QoS"), translate("Data Transfer Rate: 125000 Bytes/s = 125 KBytes/s = 0.125 MBytes/s = 1 Mbps/s"))
	y.anonymous = true
	y.addremove = true
	y.template = "cbi/tblsection"

	o = y:option(Value, "hostname", translate("Hostname"))
	o.datatype = "hostname"
	o.default = 'undefined'

	if has_ipv6 then
		o = y:option(Value, "ipaddr", translate("IP Address (v4 / v6)"))
		o.placeholder = translate("192.168.100.2")
	else
		o = y:option(Value, "ipaddr", translate("IP Address (v4 Only)"))
		o.placeholder = translate("192.168.100.2")
	end
	o.datatype = "ipaddr"
	if nixio.fs.access("/tmp/dhcp.leases") or nixio.fs.access("/var/dhcp6.leases") then
		o.titleref = luci.dispatcher.build_url("admin", "status", "overview")
	end

	o = y:option(Value, "urate", translate("Upload Rate"))
	o.placeholder = translate("125 KBytes/s = 1 Mbps/s")
	o.default = '1250'
	o.size = 4
	o.datatype = "uinteger"

	o = y:option(Value, "drate", translate("Download Rate"))
	o.placeholder = translate("125 KBytes/s = 1 Mbps/s")
	o.default = '1250'
	o.size = 4
	o.datatype = "uinteger"

	o = y:option(ListValue, "unit", translate("Rate Unit"))
	o.default = "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

--
-- Static By Mac Address
--
if macqos_enable == "1" then

	x = m:section(TypedSection, "client", translate("MAC QoS"), translate("Data Transfer Rate: 125000 Bytes/s = 125 KBytes/s = 0.125 MBytes/s = 1 Mbps/s"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.datatype = "hostname"
	o.default = ''

	o = x:option(Value, "macaddr", translate("MAC Address"))
	o.placeholder = translate("A1:B2:C3:D4:E5:F6")
	o.rmempty = true
	o.datatype = "macaddr"

	o = x:option(Value, "urate", translate("Upload Rate"))
	o.placeholder = translate("125 KBytes/s = 1 Mbps/s")
	o.default = '1250'
	o.size = 4
	o.datatype = "uinteger"
	
	o = x:option(Value, "drate", translate("Download Rate"))
	o.placeholder = translate("125 KBytes/s = 1 Mbps/s")
	o.default = '1250'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "unit", translate("Rate Unit"))
	o.default = "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")
	
end

return m
