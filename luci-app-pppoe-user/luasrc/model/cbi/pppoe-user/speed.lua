m = Map("pppoe-user")

s = m:section(TypedSection, "user", translate("Traffic Control"), translate("Speed kbit/s"))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "sqm", translate("QoS"))
o.rmempty = true

o = s:option(DummyValue, "username", translate("User Name"))
o.placeholder = translate("username")
o.readonly = true

o = s:option(ListValue, "upload", translate("Download speed"))
o.placeholder = translate("Speed kbit/s")
o.rmempty = true
o.default = '31500'
o:value("1050", "1 M")
o:value("2100", "2 M")
o:value("3150", "3 M")
o:value("4200", "4 M")
o:value("5250", "5 M")
o:value("10500", "10 M")
o:value("21000", "20 M")
o:value("31500", "30 M")
o:value("42000", "40 M")
o:value("52500", "50 M")
o:value("63000", "60 M")
o:value("73500", "70 M")
o:value("84000", "80 M")
o:value("94500", "90 M")
o:value("105000", "100 M")
o:value("210000", "200 M")
o:value("315000", "300 M")
o:value("420000", "400 M")
o:value("525000", "500 M")
o:value("1050000", "1000 M")
o.datatype = "uinteger"

o = s:option(ListValue, "download", translate("Upload speed"))
o.placeholder = translate("Speed kbit/s")
o.rmempty = true
o.default = '31500'
o:value("1050", "1 M")
o:value("2100", "2 M")
o:value("3150", "3 M")
o:value("4200", "4 M")
o:value("5250", "5 M")
o:value("10500", "10 M")
o:value("21000", "20 M")
o:value("31500", "30 M")
o:value("42000", "40 M")
o:value("52500", "50 M")
o:value("63000", "60 M")
o:value("73500", "70 M")
o:value("84000", "80 M")
o:value("94500", "90 M")
o:value("105000", "100 M")
o:value("210000", "200 M")
o:value("315000", "300 M")
o:value("420000", "400 M")
o:value("525000", "500 M")
o:value("1050000", "1000 M")
o.datatype = "uinteger"

o = s:option(ListValue, "qdisc", translate("Queuing Rules"))
o:value("fq_codel", translate("fq_codel"))
o:value("cake", translate("cake"))
o.default = "cake"

o = s:option(ListValue, "script", translate("Queue Script"))
o:value("layer_cake.qos", translate("layer_cake.qos"))
o:value("piece_of_cake.qos", translate("piece_of_cake.qos"))
o:value("simple.qos", translate("simple.qos"))
o:value("simplest.qos", translate("simplest.qos"))
o:value("simplest_tbf.qos", translate("simplest_tbf.qos"))
o.default = "piece_of_cake.qos"

o = s:option(ListValue, "linklayer", translate("Link Layer"))
o:value("none", translate("none"))
o:value("ethernet", translate("ethernet"))
o:value("atm", translate("atm"))
o.default = "ethernet"

return m
