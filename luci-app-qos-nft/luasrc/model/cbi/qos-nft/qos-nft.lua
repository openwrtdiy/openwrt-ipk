-- Licensed to the public under the Apache License 2.0.

local uci = require("luci.model.uci").cursor()
local wa = require("luci.tools.webadmin")
local fs = require("nixio.fs")
local ipc = require("luci.ip")

local enable_priority = uci:get("qos-nft", "default", "priority_enable")
local qos_enable = uci:get("qos-nft", "default", "qos_enable")
local qos_type = uci:get("qos-nft", "default", "qos_type")

local dhcp_leases_v4 = {}
local dhcp_leases_v6 = {}
local lease_file_v4 = "/tmp/dhcp.leases"
local lease_file_v6 = "/tmp/hosts/odhcpd"

local function load_leases(file_path)
	local leases = {}
	local file = io.open(file_path, "r")
	if file then
		for line in file:lines() do
			local ts, mac, ip, hostname = line:match("^(%d+) (%S+) (%S+) (%S+)")
			if ip and mac and hostname then
				leases[#leases + 1] = { ip = ip, mac = mac, hostname = hostname }
			end
		end
		file:close()
	end
	return leases
end

local dhcp_leases_v4 = load_leases(lease_file_v4)
local dhcp_leases_v6 = load_leases(lease_file_v6)

m = Map("qos-nft", translate("QoS over Nftables"))

--
-- Taboptions
--
s = m:section(TypedSection, "default", translate("Qos Nft Settings"))
s.addremove = false
s.anonymous = true

s:tab("speedlimit", translate("IP and MAC address speed limit"))
--
-- Static
--
o = s:taboption("speedlimit", Flag, "qos_enable", translate("Speed limit switch"), translate("Enable Limit Rate Feature"))
o.default = qos_enable or o.enabled
o.rmempty = false

o = s:taboption("speedlimit", ListValue, "qos_type", translate("Limit Type"))
o.default = "static"
o:depends("qos_enable", "1")
o:value("static", "Static")
o:value("dynamic", "Dynamic")

--
-- Static
--
if qos_enable == "1" and qos_type == "static" then
	y = m:section(
		TypedSection,
		"host",
		translate("Static speed limit"),
		translate("Data Transfer Rate: 1 Mbps/s = 0.125 MBytes/s = 125 KBytes/s = 125000 Bytes/s")
	)
	y.anonymous = true
	y.addremove = true
	y.sortable = true
	y.template = "cbi/tblsection"

	o = y:option(Flag, "qos", translate("Enable"))
	o.rmempty = false

	o = y:option(Value, "hostname", translate("Hostname"))
	o.placeholder = translate("Hostname")
	o.datatype = "hostname"
	o.size = 6

	if #dhcp_leases_v4 > 0 then
		for _, lease in ipairs(dhcp_leases_v4) do
			o:value(lease.hostname, lease.hostname)
		end
	end

	if #dhcp_leases_v6 > 0 then
		for _, lease in ipairs(dhcp_leases_v6) do
			o:value(lease.hostname, lease.hostname)
		end
	end

	o = y:option(Value, "ipaddr", translate("IP Address"))
	o.placeholder = translate("IP Address")
	o.datatype = "ipaddr"
	o.optional = false
	o.rmempty = true
	o.size = 6

	if #dhcp_leases_v4 > 0 then
		for _, lease in ipairs(dhcp_leases_v4) do
			o:value(lease.ip, lease.ip)
		end
	end

	if #dhcp_leases_v6 > 0 then
		for _, lease in ipairs(dhcp_leases_v6) do
			o:value(lease.ip, lease.ip)
		end
	end

	o = y:option(Value, "macaddr", translate("MAC Address"))
	o.placeholder = translate("MAC Address")
	o.datatype = "macaddr"
	o.rmempty = true
	o.size = 6
	if #dhcp_leases_v4 > 0 then
		for _, lease in ipairs(dhcp_leases_v4) do
			o:value(lease.mac, lease.mac)
		end
	end
	if #dhcp_leases_v6 > 0 then
		for _, lease in ipairs(dhcp_leases_v6) do
			o:value(lease.mac, lease.mac)
		end
	end

	o = y:option(Value, "urate", translate("Upload Rate"))
	o.placeholder = "1 to 10000 Mbps"
	o.datatype = "range(1,10000)"
	o.size = 6
	o.default = 10
	o.optional = false

	o = y:option(Value, "drate", translate("Download Rate"))
	o.placeholder = "1 to 10000 Mbps"
	o.datatype = "range(1,10000)"
	o.size = 6
	o.default = 30
	o.optional = false

	o = y:option(Value, "unit", translate("Rate Unit"))
	o.default = "mbps"
	o.readonly = true
	o.size = 6

	function o.cfgvalue(self, section)
		local value = Value.cfgvalue(self, section)
		if value == "mbps" then
			return "Mbps"
		end
		return value
	end

	function o.write(self, section, value)
		if value == "Mbps" then
			value = "mbps"
		end
		Value.write(self, section, value)
	end

	o = y:option(Value, "burst", translate("Burst size"))
	o.placeholder = translate("Burst size")
	o.datatype = "range(10,1000)"
	o.size = 6

	o = y:option(Value, "connect", translate("Connections"))
	o.placeholder = translate("Connections")
	o.datatype = "range(100,10240)"
	o.size = 6
	o:value("1024")
	o:value("2048")
	o:value("3072")
	o:value("4096")
	o:value("5120")
	o:value("6144")
	o:value("7168")
	o:value("8192")
	o:value("9216")
	o:value("10240")

	o = y:option(Value, "comment", translate("Comment"))
	o.placeholder = translate("Comment")
	o.size = 6
end
--
-- Dynamic
--
if qos_enable == "1" and qos_type == "dynamic" then
	y = m:section(
		TypedSection,
		"subnet",
		translate("Dynamic speed limit"),
		translate("Data Transfer Rate: 1 Mbit/s = 1 Mbps/s = 0.125 MBytes/s = 125 KBytes/s = 125000 Bytes/s")
	)
	y.anonymous = true
	y.addremove = true
	y.sortable = false
	y.template = "cbi/tblsection"

	o = y:option(Flag, "qos", translate("Enable"))
	o.rmempty = false
	
	o = y:option(Value, "grouping", translate("Grouping"))
	o.placeholder = translate("Grouping")
	o.size = 6
	
	o = y:option(Value, "cidr4", translate("Subnet Mask(IPv4)"))
	o.placeholder = translate("Target Network (IPv4/MASK)")
	o.datatype = "cidr4"
	o.optional = false
	o.rmempty = true
	o.size = 6
	
	o = y:option(Value, "cidr6", translate("Subnet Mask(IPv6)"))
	o.placeholder = translate("Target Network (IPv6/MASK)")
	o.datatype = "cidr6"
	o.optional = false
	o.rmempty = true
	o.size = 6
	
	o = y:option(Value, "urate", translate("Upload Rate"))
	o.placeholder = "1 to 10000 Mbps"
	o.datatype = "range(1,10000)"
	o.size = 6
	o.default = 50
	o.optional = false

	o = y:option(Value, "drate", translate("Download Rate"))
	o.placeholder = "1 to 10000 Mbps"
	o.datatype = "range(1,10000)"
	o.size = 6
	o.default = 100
	o.optional = false

	o = y:option(Value, "unit", translate("Rate Unit"))
	o.default = "mbps"
	o.readonly = true
	o.size = 6

	function o.cfgvalue(self, section)
		local value = Value.cfgvalue(self, section)
		if value == "mbps" then
			return "Mbps"
		end
		return value
	end

	function o.write(self, section, value)
		if value == "Mbps" then
			value = "mbps"
		end
		Value.write(self, section, value)
	end
	
	o = y:option(DynamicList, "whitelist", translate("White List"))
	o.placeholder = translate("IP Address")
	o.datatype = "ipaddr"
	o.readonly = true
	o.size = 6
end

s:tab("priority", translate("Traffic Priority"))
--
-- Priority
--
o = s:taboption(
	"priority",
	Flag,
	"priority_enable",
	translate("Priority switch"),
	translate("Enable Traffic Priority")
)
o.default = enable_priority or o.enabled
o.rmempty = false

o = s:taboption(
	"priority",
	ListValue,
	"priority_netdev",
	translate("Network Interface")
)
o:depends("priority_enable", "1")
wa.cbi_add_networks(o)

--
-- Traffic Priority Settings
--
if enable_priority == "1" then
	s = m:section(TypedSection, "priority", translate("Traffic Priority Settings"))
	s.anonymous = true
	s.addremove = true
	s.template = "cbi/tblsection"
	
	o = s:option(Flag, "qos", translate("Enable"))
	o.rmempty = false
	
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

	o = s:option(Value, "service", translate("Service"), translate("Port numbers can be separated by commas"))
	o:value("21", "21 FTP")
	o:value("22", "22 SSH")
	o:value("23", "23 TELNET")
	o:value("25", "25 SMTP")
	o:value("53", "53 DNS")
	o:value("69", "69 TFTP")	
	o:value("80", "80 HTTP")
	o:value("119", "119 NNTP")	
	o:value("110", "110 POP3")
	o:value("135", "135 RPC")
	o:value("139", "139 NetBIOS")
	o:value("143", "143 IMAP")
	o:value("161", "161 SNMP")
	o:value("389", "389 LDAP")
	o:value("443", "443 HTTPS")
	o:value("445", "445 SMB")
	o:value("1521", "1521 Oracle SQL")
	o:value("3306", "3306 MySQL")
	o:value("3389", "3389 RDP")
	o:value("5432", "5432 PostgreSQL")
	o:value("5900", "5900 VNC")
	o:value("6379", "6379 Redis")

	o = s:option(Value, "comment", translate("Comment"))
	o.placeholder = translate("Comment")
	o.size = 6
end

return m
