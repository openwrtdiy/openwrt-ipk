-- Copyright 2018 Rosy Song <rosysong@rosinson.com>
-- Licensed to the public under the Apache License 2.0.

local uci = require("luci.model.uci").cursor()
local wa = require("luci.tools.webadmin")
local fs = require("nixio.fs")
local ipc = require("luci.ip")

local limit_ip_enable = uci:get("nft-qos", "default", "limit_ip_enable")
local limit_mac_enable = uci:get("nft-qos", "default", "limit_mac_enable")

local has_ipv6 = fs.access("/proc/net/ipv6_route")

m = Map("nft-qos", translate("QoS over Nftables"))

--
-- Taboptions
--
s = m:section(TypedSection, "default", translate(""))
s.addremove = false
s.anonymous = true

s:tab("limitip", translate("IP Limit Rate Options"))
s:tab("limitmac", translate("MAC Limit Rate Options"))

--
-- Enable IP address rate limiting
--
o = s:taboption("limitip", Flag, "limit_ip_enable", translate("Limit Rate by IP Address"), translate("Enable Limit Rate Feature"))
o.default = limit_ip_enable or o.disabled
o.rmempty = false

--
-- IP address speed limit
--
if limit_ip_enable == "1" then

	x = m:section(TypedSection, "user", translate("IP address QoS"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.placeholder = translate("Username")
	o.datatype = "hostname"
	o.default = ''

	if has_ipv6 then
		o = x:option(Value, "ipaddr", translate("IP Address"))
		o.placeholder = translate("IP Address")
	else
		o = x:option(Value, "ipaddr", translate("IP Address"))
	end
	o.datatype = "ipaddr"
	if nixio.fs.access("/tmp/dhcp.leases") or nixio.fs.access("/var/dhcp6.leases") then
	end

	o = x:option(ListValue, "drate", translate("Download Rate"))
	o:value("1100", "1 M")
	o:value("5500", "5 M")
	o:value("11000", "10 Mbps")
	o:value("22000", "20 M")
	o:value("33000", "30 M")
	o:value("44000", "40 M")
	o:value("55000", "50 M")
	o:value("66000", "60 M")
	o:value("77000", "70 M")
	o:value("88000", "80 M")
	o:value("99000", "90 M")
	o:value("110000", "100 Mbps")
	o:value("220000", "200 M")
	o:value("330000", "300 M")
	o:value("440000", "400 M")
	o:value("550000", "500 M")
	o:value("660000", "600 M")
	o:value("770000", "700 M")
	o:value("880000", "800 M")
	o:value("990000", "900 M")
	o:value("1100000", "1000 Mbps")

	o = x:option(ListValue, "urate", translate("Upload Rate"))
	o:value("1100", "1 M")
	o:value("5500", "5 M")
	o:value("11000", "10 Mbps")
	o:value("22000", "20 M")
	o:value("33000", "30 M")
	o:value("44000", "40 M")
	o:value("55000", "50 M")
	o:value("66000", "60 M")
	o:value("77000", "70 M")
	o:value("88000", "80 M")
	o:value("99000", "90 M")
	o:value("110000", "100 Mbps")
	o:value("220000", "200 M")
	o:value("330000", "300 M")
	o:value("440000", "400 M")
	o:value("550000", "500 M")
	o:value("660000", "600 M")
	o:value("770000", "700 M")
	o:value("880000", "800 M")
	o:value("990000", "900 M")
	o:value("1100000", "1000 Mbps")

	o = x:option(ListValue, "unit", translate("Unit"))
	o.default = def_unit or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

--
-- Enable Mac address rate limiting
--
o = s:taboption("limitmac", Flag, "limit_mac_enable", translate("Limit Rate by Mac Address"), translate("Enable Limit Rate Feature"))
o.default = limit_mac_enable or o.disabled
o.rmempty = false

--
-- Mac address speed limit
--
if limit_mac_enable == "1" then

	x = m:section(TypedSection, "client", translate("Limit Traffic Rate By Mac Address"))
	x.anonymous = true
	x.addremove = true
	x.template = "cbi/tblsection"

	o = x:option(Value, "hostname", translate("Hostname"))
	o.placeholder = translate("Username")
	o.datatype = "hostname"
	o.default = ''

	o = x:option(Value, "macaddr", translate("MAC Address"))
	o.placeholder = translate("MAC Address")
	o.rmempty = true
	o.datatype = "macaddr"

	o = x:option(ListValue, "drate", translate("Download Rate"))
	o:value("1100", "1 M")
	o:value("5500", "5 M")
	o:value("11000", "10 Mbps")
	o:value("22000", "20 M")
	o:value("33000", "30 M")
	o:value("44000", "40 M")
	o:value("55000", "50 M")
	o:value("66000", "60 M")
	o:value("77000", "70 M")
	o:value("88000", "80 M")
	o:value("99000", "90 M")
	o:value("110000", "100 Mbps")
	o:value("220000", "200 M")
	o:value("330000", "300 M")
	o:value("440000", "400 M")
	o:value("550000", "500 M")
	o:value("660000", "600 M")
	o:value("770000", "700 M")
	o:value("880000", "800 M")
	o:value("990000", "900 M")
	o:value("1100000", "1000 Mbps")

	o = x:option(ListValue, "urate", translate("Upload Rate"))
	o:value("1100", "1 M")
	o:value("5500", "5 M")
	o:value("11000", "10 Mbps")
	o:value("22000", "20 M")
	o:value("33000", "30 M")
	o:value("44000", "40 M")
	o:value("55000", "50 M")
	o:value("66000", "60 M")
	o:value("77000", "70 M")
	o:value("88000", "80 M")
	o:value("99000", "90 M")
	o:value("110000", "100 Mbps")
	o:value("220000", "200 M")
	o:value("330000", "300 M")
	o:value("440000", "400 M")
	o:value("550000", "500 M")
	o:value("660000", "600 M")
	o:value("770000", "700 M")
	o:value("880000", "800 M")
	o:value("990000", "900 M")
	o:value("1100000", "1000 Mbps")

	o = x:option(ListValue, "unit", translate("Unit"))
	o.default = def_unit or "kbytes"
	o:value("bytes", "Bytes/s")
	o:value("kbytes", "KBytes/s")
	o:value("mbytes", "MBytes/s")

end

return m
