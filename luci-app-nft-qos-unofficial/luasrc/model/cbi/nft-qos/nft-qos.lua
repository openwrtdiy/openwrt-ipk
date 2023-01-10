-- Copyright 2018 Rosy Song <rosysong@rosinson.com>
-- Licensed to the public under the Apache License 2.0.

local uci = require("luci.model.uci").cursor()
local wa = require("luci.tools.webadmin")
local fs = require("nixio.fs")
local ipc = require("luci.ip")

local def_rate_dl = uci:get("nft-qos", "default", "static_rate_dl")
local def_rate_ul = uci:get("nft-qos", "default", "static_rate_ul")
local def_unit_dl = uci:get("nft-qos", "default", "static_unit_dl")
local def_unit_ul = uci:get("nft-qos", "default", "static_unit_ul")

local limit_enable = uci:get("nft-qos", "default", "limit_enable")
local limit_mac_enable = uci:get("nft-qos", "default", "limit_mac_enable")
local limit_type = uci:get("nft-qos", "default", "limit_type")
local enable_priority = uci:get("nft-qos", "default", "priority_enable")

local has_ipv6 = fs.access("/proc/net/ipv6_route")

m = Map("nft-qos", translate("QoS over Nftables"))

--
-- Taboptions
--
s = m:section(TypedSection, "default", translate("NFT-QoS Settings"))
s.addremove = false
s.anonymous = true

s:tab("limitopt", translate("Limit Rate Options"))

--
-- Static
--
o = s:taboption("limitopt", Flag, "limit_enable", translate("Limit Rate by IP Address"), translate("Enable Limit Rate Feature"))
o.default = limit_enable or o.disabled
o.rmempty = false

o = s:taboption("limitopt", ListValue, "limit_type", translate("Limit Type"), translate("Type of Limit Rate"))
o.default = limit_static or "static"
o:depends("limit_enable","1")
o:value("static", "Static")

o = s:taboption("limitopt", Value, "static_rate_dl", translate("Default Download Rate"), translate("Default value for download rate"))
o.datatype = "uinteger"
o.default = def_rate_dl or '128'
o:depends("limit_type","static")

o = s:taboption("limitopt", ListValue, "static_unit_dl", translate("Default Download Unit"), translate("Default unit for download rate"))
o.default = def_unit_dl or "kbytes"
o:depends("limit_type","static")
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

o = s:taboption("limitopt", Value, "static_rate_ul", translate("Default Upload Rate"), translate("Default value for upload rate"))
o.datatype = "uinteger"
o.default = def_rate_ul or '128'
o:depends("limit_type","static")

o = s:taboption("limitopt", ListValue, "static_unit_ul", translate("Default Upload Unit"), translate("Default unit for upload rate"))
o.default = def_unit_ul or "kbytes"
o:depends("limit_type","static")
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

--
-- limit speed by mac address
--
o = s:taboption("limitopt", Flag, "limit_mac_enable", translate("Limit Rate by Mac Address"), translate("Enable Limit Rate Feature"))
o.default = limit_mac_enable or o.disabled
o.rmempty = false

--
-- Static Limit Rate - Download Rate
--
if limit_enable == "1" and limit_type == "static" then

	x = m:section(TypedSection, "download", translate("Static QoS-Download Rate"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.datatype = "hostname"
	o.default = 'undefined'

	if has_ipv6 then
		o = x:option(Value, "ipaddr", translate("IP Address (v4 / v6)"))
	else
		o = x:option(Value, "ipaddr", translate("IP Address (v4 Only)"))
	end
	o.datatype = "ipaddr"
	if nixio.fs.access("/tmp/dhcp.leases") or nixio.fs.access("/var/dhcp6.leases") then
		o.titleref = luci.dispatcher.build_url("admin", "status", "overview")
	end

	o = x:option(Value, "rate", translate("Rate"))
	o.default = def_rate_dl or '50'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "unit", translate("Unit"))
	o.default = def_unit_dl or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

--
-- Static Limit Rate - Upload Rate
--
	y = m:section(TypedSection, "upload", translate("Static QoS-Upload Rate"))
	y.anonymous = true
	y.addremove = true
	y.template = "cbi/tblsection"

	o = y:option(Value, "hostname", translate("Hostname"))
	o.datatype = "hostname"
	o.default = 'undefined'

	if has_ipv6 then
		o = y:option(Value, "ipaddr", translate("IP Address (v4 / v6)"))
	else
		o = y:option(Value, "ipaddr", translate("IP Address (v4 Only)"))
	end
	o.datatype = "ipaddr"
	if nixio.fs.access("/tmp/dhcp.leases") or nixio.fs.access("/var/dhcp6.leases") then
		o.titleref = luci.dispatcher.build_url("admin", "status", "overview")
	end

	o = y:option(Value, "rate", translate("Rate"))
	o.default = def_rate_ul or '50'
	o.size = 4
	o.datatype = "uinteger"

	o = y:option(ListValue, "unit", translate("Unit"))
	o.default = def_unit_ul or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

--
-- Static By Mac Address
--
if limit_mac_enable == "1" then

	x = m:section(TypedSection, "client", translate("Limit Traffic Rate By Mac Address"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.datatype = "hostname"
	o.default = ''

	o = x:option(Value, "macaddr", translate("MAC Address"))
	o.rmempty = true
	o.datatype = "macaddr"

	o = x:option(Value, "drate", translate("Download Rate"))
	o.default = def_rate_dl or '128'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "drunit", translate("Unit"))
	o.default = def_unit or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

	o = x:option(Value, "urate", translate("Upload Rate"))
	o.default = def_rate_ul or '128'
	o.size = 4
	o.datatype = "uinteger"

	o = x:option(ListValue, "urunit", translate("Unit"))
	o.default = def_unit or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

return m
