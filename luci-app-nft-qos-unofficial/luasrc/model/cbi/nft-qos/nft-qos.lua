-- Copyright 2018 Rosy Song <rosysong@rosinson.com>
-- Licensed to the public under the Apache License 2.0.

local uci = require("luci.model.uci").cursor()
local wa = require("luci.tools.webadmin")
local fs = require("nixio.fs")
local ipc = require("luci.ip")

local def_rate_ul = uci:get("nft-qos", "default", "static_rate_ul")
local def_rate_dl = uci:get("nft-qos", "default", "static_rate_dl")
local def_unit = uci:get("nft-qos", "default", "static_unit")

local def_up = uci:get("nft-qos", "default", "dynamic_bw_up")
local def_down = uci:get("nft-qos", "default", "dynamic_bw_down")

local enable_priority = uci:get("nft-qos", "default", "priority_enable")
local limit_mac_enable = uci:get("nft-qos", "default", "limit_mac_enable")
local limit_ip_enable = uci:get("nft-qos", "default", "limit_ip_enable")
local limit_type = uci:get("nft-qos", "default", "limit_type")

local has_ipv6 = fs.access("/proc/net/ipv6_route")

m = Map("nft-qos", translate("QoS over Nftables"))

--
-- Taboptions
--
s = m:section(TypedSection, "default", translate("NFT-QoS Settings"))
s.addremove = false
s.anonymous = true

s:tab("priority", translate("Traffic Priority"))
s:tab("limitmac", translate("Limit Rate by Mac Address"))
s:tab("limitip", translate("Limit Rate by IP Address"))

--
-- Priority
--
o = s:taboption("priority", Flag, "priority_enable", translate("Enable Traffic Priority"), translate("Enable this feature"))
o.default = enable_priority or o.enabled
o.rmempty = false

o = s:taboption("priority", ListValue, "priority_netdev", translate("Default Network Interface"), translate("Network Interface for Traffic Shaping, e.g. br-lan, eth0.1, eth0, etc."))
o:depends("priority_enable", "1")
wa.cbi_add_networks(o)

--
-- limit speed by mac address
--
o = s:taboption("limitmac", Flag, "limit_mac_enable", translate("Enable MAC address speed limit"), translate("Enable Limit Rate Feature"))
o.default = limit_mac_enable or o.enabled
o.rmempty = false

--
-- Static
--
o = s:taboption("limitip", Flag, "limit_ip_enable", translate("Enable IP address speed limit"), translate("Enable Limit Rate Feature"))
o.default = limit_ip_enable or o.disabled
o.rmempty = false

o = s:taboption("limitip", ListValue, "limit_type", translate("Limit Type"), translate("Type of Limit Rate"))
o.default = limit_static or "static"
o:depends("limit_ip_enable","1")
o:value("static", "Static")
o:value("dynamic", "Dynamic")

o = s:taboption("limitip", Value, "static_rate_ul", translate("Default Upload Rate"), translate("Default value for upload rate"))
o.datatype = "uinteger"
o.default = def_rate_ul or '1250'
o:depends("limit_type","static")

o = s:taboption("limitip", Value, "static_rate_dl", translate("Default Download Rate"), translate("Default value for download rate"))
o.datatype = "uinteger"
o.default = def_rate_dl or '2500'
o:depends("limit_type","static")

o = s:taboption("limitip", ListValue, "static_unit", translate("Default Unit"), translate("Default unit rate"))
o.default = def_unit or "kbytes"
o:depends("limit_type","static")
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

--
-- Dynamic
--

o = s:taboption("limitip", Value, "dynamic_bw_up", translate("Upload Bandwidth (Mbps)"), translate("Default value for upload bandwidth"))
o.default = def_down or '100'
o.datatype = "uinteger"
o:depends("limit_type","dynamic")

o = s:taboption("limitip", Value, "dynamic_bw_down", translate("Download Bandwidth (Mbps)"), translate("Default value for download bandwidth"))
o.default = def_up or '100'
o.datatype = "uinteger"
o:depends("limit_type","dynamic")

o = s:taboption("limitip", Value, "dynamic_cidr", translate("Target Network (IPv4/MASK)"), translate("Network to be applied, e.g. 192.168.1.0/24, 10.2.0.0/16, etc."))
o.datatype = "cidr4"
ipc.routes({ family = 4, type = 1 }, function(rt) o.default = rt.dest end)
o:depends("limit_type","dynamic")

if has_ipv6 then
	o = s:taboption("limitip", Value, "dynamic_cidr6", translate("Target Network6 (IPv6/MASK)"), translate("Network to be applied, e.g. AAAA::BBBB/64, CCCC::1/128, etc."))
	o.datatype = "cidr6"
	o:depends("limit_type","dynamic")
end

o = s:taboption("limitip", DynamicList, "limit_whitelist", translate("White List for Limit Rate"))
o.datatype = "ipaddr"
o:depends("limit_ip_enable","1")

--
-- Static Limit Rate
--
if limit_ip_enable == "1" and limit_type == "static" then

	x = m:section(TypedSection, "user", translate("Static IP QoS"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.datatype = ""
	o.default = ''

	if has_ipv6 then
		o = x:option(Value, "ipaddr", translate("IP Address (v4 / v6)"))
	else
		o = x:option(Value, "ipaddr", translate("IP Address (v4 Only)"))
	end
	o.datatype = "ipaddr"
	if nixio.fs.access("/tmp/dhcp.leases") or nixio.fs.access("/var/dhcp6.leases") then
		o.titleref = luci.dispatcher.build_url("admin", "status", "overview")
	end

	o = x:option(Value, "urate", translate("Upload Rate"))
	o.default = def_rate_ul or '625'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(Value, "drate", translate("Download Rate"))
	o.default = def_rate_dl or '1250'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "unit", translate("Unit"))
	o.default = "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

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

	o = s:option(Value, "service", translate("Service"), translate("e.g. https, 23, (separator is comma)"))
	o.default = '?'

	o = s:option(Value, "comment", translate("Comment"))
	o.default = '?'

end

--
-- Static By Mac Address
--
if limit_mac_enable == "1" then

	x = m:section(TypedSection, "client", translate("Limit Traffic Rate By Mac Address"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Flag, "enabled", translate("Enabled"))
	o.rmempty = false

	o = x:option(Value, "username", translate("User Name"))
	o.placeholder = translate("Username")
	o.datatype = ""
	o.default = ''

	o = x:option(DummyValue, "servicename", translate("Service Name"))
	o.placeholder = translate("Automatically")
	o.default = "*"
	o.rmempty = true
	function o.cfgvalue(e, t)
	    value = e.map:get(t, "servicename")
	    return value == "*" and "" or value
	end
	function o.remove(e, t) Value.write(e, t, "*") end

	o = x:option(Value, "password", translate("Password"))
	o.placeholder = translate("Password")
	o.default = os.date("%Y%m%d")
	o.password = true
	o.rmempty = false

	o = x:option(Value, "macaddr", translate("MAC Address"))
	o.rmempty = true
	o.datatype = "macaddr"

	o = x:option(ListValue, "package", translate("Broadband Package"))
	o.rmempty = true
	o:value("none", translate("None"))
	o:value("family", translate("Family"))
	o:value("office", translate("Office"))
	o:value("free", translate("Free"))
	o:value("test", translate("Test"))

	o = x:option(Value, "urate", translate("Upload Rate"))
	o.default = def_rate_ul or '625'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(Value, "drate", translate("Download Rate"))
	o.default = def_rate_dl or '1250'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "unit", translate("Unit"))
	o.default = "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

	o = x:option(ListValue, "connect", translate("Connections"))
	o.default = "8192"
	o.datatype = "range(64,65536)"
	o.rmempty = true
	o:value("1024", "10M 1024")
	o:value("2048", "20M 2048")
	o:value("4096", "40M 4096")
	o:value("8192", "80M 8192")
	o:value("16384", "100M 16384")
	o:value("32768", "200M 32768")
	o:value("65536", "400M 65536")

	o = x:option(Value, "expires", translate("Expiration date"))
	o.placeholder = translate("Expires")
	o.datatype = "range(20230101,20231231)"
	o.rmempty = true

end

return m
