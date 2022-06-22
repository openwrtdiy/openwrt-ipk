local m, s, o
m = Map("pppoe-server", translate("PPPD Options File"))

s = m:section(TypedSection, "pppd")
s.addremove = true
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
o.default = "auth"

o = s:option(ListValue, "ipv6", translate("IPv6 Supported"))
o:value("-ipv6", translate("reject"))
o:value("+ipv6", translate("accept"))
o.default = "-ipv6"

o = s:option(Value, "lcp_echo_interval", translate("lcp-echo-interval"))
o.placeholder = translate("10")
o.default = "10"

o = s:option(Value, "lcp_echo_failure", translate("lcp-echo-failure"))
o.placeholder = translate("2")
o.default = "2"

o = s:option(Value, "mru", translate("mru"), translate("You may not be able to access the Internet if you don't set it up properly.default: 1492"))
o.placeholder = translate("1492")
o.default = "1492"

o = s:option(Value, "mtu", translate("mtu"), translate("You may not be able to access the Internet if you don't set it up properly.default: 1492"))
o.placeholder = translate("1492")
o.default = "1492"

o = s:option(Value, "msdns1", translate("IPv4 DNS Server 1"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.placeholder = translate("8.8.8.8")
o.datatype = "ipaddr"
o.default = "8.8.8.8"

o = s:option(Value, "msdns2", translate("IPv4 DNS Server 2"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.placeholder = translate("1.1.1.1")
o.datatype = "ipaddr"
o.default = "1.1.1.1"

o = s:option(Value, "log", translate("Log"),translate("Log save path, default: /var/log/pppoe-server.log"))

s:option(Flag, "more", translate("More Options"), translate("Options for advanced users"))

o = s:option(Value, "mswins1", translate("IPv4 WINS Server 1"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.datatype = "ipaddr"
o:depends("more", "1")

o = s:option(Value, "mswins2", translate("IPv4 WINS Server 2"), translate("Set the PPPoE server to default DNS server, which is not required."))
o.datatype = "ipaddr"
o:depends("more", "1")

return m
