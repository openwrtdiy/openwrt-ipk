m = Map("pppoe-user")

s = m:section(TypedSection, "user", translate(""), translate("After completing the change of user bandwidth parameters, the online user account must be kicked off the line, and the new speed limit parameter will take effect!"))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "qos", translate("QoS"))
o.rmempty = true
o.default = 1

o = s:option(DummyValue, "username", translate("User Name"))
o.placeholder = translate("username")
o.readonly = true

o = s:option(ListValue, "upload", translate("Download speed"))
o.placeholder = translate("Speed kbit/s")
o.rmempty = true
o:value("1100", "1 Mbps")
o:value("2200", "2 M")
o:value("3300", "3 M")
o:value("4400", "4 M")
o:value("5500", "5 M")
o:value("6600", "6 M")
o:value("7700", "7 M")
o:value("8800", "8 M")
o:value("9900", "9 M")
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
o.datatype = "uinteger"

o = s:option(ListValue, "download", translate("Upload speed"))
o.placeholder = translate("Speed kbit/s")
o.rmempty = true
o:value("1100", "1 Mbps")
o:value("2200", "2 M")
o:value("3300", "3 M")
o:value("4400", "4 M")
o:value("5500", "5 M")
o:value("6600", "6 M")
o:value("7700", "7 M")
o:value("8800", "8 M")
o:value("9900", "9 M")
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
o.datatype = "uinteger"

o = s:option(ListValue, "qdisc", translate("Queuing Rules"))
o:value("fq_codel", translate("fq_codel"))
o:value("cake", translate("cake"))
o.default = "fq_codel"

o = s:option(ListValue, "script", translate("Queue Script"))
o:value("layer_cake.qos", translate("layer_cake.qos"))
o:value("piece_of_cake.qos", translate("piece_of_cake.qos"))
o:value("simple.qos", translate("simple.qos"))
o:value("simple_pppoe.qos", translate("simple_pppoe.qos"))
o:value("simplest.qos", translate("simplest.qos"))
o:value("simplest_tbf.qos", translate("simplest_tbf.qos"))
o.default = "simple.qos"

o = s:option(ListValue, "linklayer", translate("Link Layer"))
o:value("none", translate("none"))
o:value("ethernet", translate("ethernet"))
o:value("atm", translate("atm"))
o.default = "ethernet"

return m
