local m, s, o
m = Map("pppoe-server", translate("PPPD Options File"))

s = m:section(TypedSection, "pppd")
s.addremove = false
s.anonymous = true

o = s:option(ListValue, "pap", translate("PAP"))
o:value("refuse-pap", translate("reject"))
o:value("require-pap", translate("accept"))
o.default = "refuse-pap"

o = s:option(ListValue, "chap", translate("CHAP"))
o:value("refuse-chap", translate("reject"))
o:value("require-chap", translate("accept"))
o.default = "require-chap"

o = s:option(ListValue, "mschapv2", translate("MSCHAP-V2"))
o:value("refuse-mschap-v2", translate("reject"))
o:value("require-mschap-v2", translate("accept"))
o.default = "require-mschap-v2"

o = s:option(ListValue, "authmode", translate("Auth Mode"))
o:value("login", translate("login"))
o:value("auth", translate("auth"))
o:value("noauth", translate("noauth"))
o.default = "auth"

o = s:option(ListValue, "ipv6", translate("IPv6 Supported"))
o:value("-ipv6", translate("reject"))
o:value("+ipv6", translate("accept"))
o.default = "-ipv6"

o = s:option(Value, "lcp_echo_interval", translate("LCP Echo Interval"), translate("Send relevant instructions to the PPPoE server regularly to check whether the connection is normal!"))
o.placeholder = translate("10")
o.datatype = "range(10,60)"
o.default = "10"

o = s:option(Value, "lcp_echo_failure", translate("LCP Echo Failure"), translate("The number of times to send relevant commands to the PPPoE server"))
o.placeholder = translate("2")
o.datatype = "range(2,10)"
o.default = "2"

o = s:option(Value, "mtu", translate("MTU"), translate("You may not be able to access the Internet if you don't set it up properly.default: 1492"))
o.placeholder = translate("1492")
o.default = "1492"

o = s:option(Value, "mru", translate("MRU"), translate("You may not be able to access the Internet if you don't set it up properly.default: 1492"))
o.placeholder = translate("1492")
o.default = "1492"

o = s:option(Value, "msdns1", translate("IPv4 DNS Server 1"), translate("Set the PPPoE server to default DNS server. Please note: When choosing to use SmartDNS resolution service, be sure to enable firewall DNS port forwarding!"))
o.placeholder = translate("8.8.8.8")
o.datatype = "ipaddr"
o:value("1.1.1.1", translate("Cloudflare DNS 1.1.1.1"))
o:value("1.0.0.1", translate("Cloudflare DNS 1.0.0.1"))
o:value("8.8.8.8", translate("Google DNS 8.8.8.8"))
o:value("8.8.4.4", translate("Google DNS 8.8.4.4"))
o:value("9.9.9.9", translate("Quad9 DNS 9.9.9.9"))
o:value("149.112.112.112", translate("Quad9 DNS 149.112.112.112"))
o:value("208.67.222.222", translate("OpenDNS 208.67.222.222"))
o:value("208.67.220.220", translate("OpenDNS 208.67.220.220"))
o:value("223.5.5.5", translate("AliDNS 223.5.5.5"))
o:value("223.6.6.6", translate("AliDNS 223.6.6.6"))
o:value("119.29.29.29", translate("DNSPod DNS 119.29.29.29"))
o:value("119.28.28.28", translate("DNSPod DNS 119.28.28.28"))
o:value("180.76.76.76", translate("Baidu DNS 180.76.76.76"))
o:value("114.114.114.114", translate("114DNS 114.114.114.114"))
o:value("114.114.115.115", translate("114DNS 114.114.115.115"))
o:value("101.101.101.101", translate("Quad101 DNS 101.101.101.101"))
o:value("101.102.103.104", translate("Quad101 DNS 101.102.103.104"))
o.default = "8.8.8.8"

o = s:option(Value, "msdns2", translate("IPv4 DNS Server 2"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.placeholder = translate("1.1.1.1")
o.datatype = "ipaddr"
o:value("1.1.1.1", translate("Cloudflare DNS 1.1.1.1"))
o:value("1.0.0.1", translate("Cloudflare DNS 1.0.0.1"))
o:value("8.8.8.8", translate("Google DNS 8.8.8.8"))
o:value("8.8.4.4", translate("Google DNS 8.8.4.4"))
o:value("9.9.9.9", translate("Quad9 DNS 9.9.9.9"))
o:value("149.112.112.112", translate("Quad9 DNS 149.112.112.112"))
o:value("208.67.222.222", translate("OpenDNS 208.67.222.222"))
o:value("208.67.220.220", translate("OpenDNS 208.67.220.220"))
o:value("223.5.5.5", translate("AliDNS 223.5.5.5"))
o:value("223.6.6.6", translate("AliDNS 223.6.6.6"))
o:value("119.29.29.29", translate("DNSPod DNS 119.29.29.29"))
o:value("119.28.28.28", translate("DNSPod DNS 119.28.28.28"))
o:value("180.76.76.76", translate("Baidu DNS 180.76.76.76"))
o:value("114.114.114.114", translate("114DNS 114.114.114.114"))
o:value("114.114.115.115", translate("114DNS 114.114.115.115"))
o:value("101.101.101.101", translate("Quad101 DNS 101.101.101.101"))
o:value("101.102.103.104", translate("Quad101 DNS 101.102.103.104"))
o.default = "1.1.1.1"

o = s:option(Value, "logfile", translate("Log file"),translate("Log save path, default: /var/log/pppoe-server.log"))
o:value("/dev/null")
o:value("/var/log/pppoe-server.log")
o.default = "/dev/null"

o = s:option(ListValue, "debug", translate("PPPoE Debug"),translate("pppd will log the contents of all control packets sent or received in a readable form.  The packets are logged through syslog with facility daemon and level debug."))
o:value("#debug", translate("Disabled"))
o:value("debug", translate("Enable"))
o.default = "#debug"

s:option(Flag, "more", translate("More Options"), translate("Options for advanced users"))

o = s:option(Value, "mswins1", translate("IPv4 WINS Server 1"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.datatype = "ipaddr"
o:depends("more", "1")

o = s:option(Value, "mswins2", translate("IPv4 WINS Server 2"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.datatype = "ipaddr"
o:depends("more", "1")

return m
