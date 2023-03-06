m = Map("pppoeuser")

s = m:section(TypedSection, "user", translate(""), translate(""))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "qos", translate("QoS"))
o.rmempty = true
o.default = 1

o = s:option(DummyValue, "username", translate("User Name"))
o.readonly = true

o = s:option(DummyValue, "package", translate("Broadband Package"))
o.rmempty = true

o = s:option(ListValue, "upload", translate("Upload speed"))
o.default = "0"
o.datatype = "uinteger"
o.rmempty = true
o:value("11000", "10 Mbps")
o:value("22000", "20 Mbps")
o:value("33000", "30 Mbps")
o:value("44000", "40 Mbps")
o:value("55000", "50 Mbps")
o:value("66000", "60 Mbps")
o:value("77000", "70 Mbps")
o:value("88000", "80 Mbps")
o:value("99000", "90 Mbps")
o:value("110000", "100 Mbps")
o:value("220000", "200 Mbps")
o:value("330000", "300 Mbps")
o:value("440000", "400 Mbps")
o:value("550000", "500 Mbps")
o:value("660000", "600 Mbps")
o:value("770000", "700 Mbps")
o:value("880000", "800 Mbps")
o:value("990000", "900 Mbps")
o:value("1100000", "1000 Mbps")

o = s:option(ListValue, "download", translate("Download speed"))
o.default = "0"
o.datatype = "uinteger"
o.rmempty = true
o:value("11000", "10 Mbps")
o:value("22000", "20 Mbps")
o:value("33000", "30 Mbps")
o:value("44000", "40 Mbps")
o:value("55000", "50 Mbps")
o:value("66000", "60 Mbps")
o:value("77000", "70 Mbps")
o:value("88000", "80 Mbps")
o:value("99000", "90 Mbps")
o:value("110000", "100 Mbps")
o:value("220000", "200 Mbps")
o:value("330000", "300 Mbps")
o:value("440000", "400 Mbps")
o:value("550000", "500 Mbps")
o:value("660000", "600 Mbps")
o:value("770000", "700 Mbps")
o:value("880000", "800 Mbps")
o:value("990000", "900 Mbps")
o:value("1100000", "1000 Mbps")

o = s:option(ListValue, "connect", translate("Connections"))
o.default = "4096"
o.datatype = "range(64,65536)"
o.rmempty = true
o:value("1024", "10M 1024")
o:value("2048", "20M 2048")
o:value("4096", "40M 4096")
o:value("8192", "80M 8192")
o:value("16384", "100M 16384")
o:value("32768", "200M 32768")
o:value("65536", "400M 65536")

o = s:option(ListValue, "qdisc", translate("Queuing Rules"))
o.default = "fq_codel"
o:value("fq_codel", translate("fq_codel"))
o:value("cake", translate("cake"))

o = s:option(ListValue, "script", translate("Queue Script"))
o.default = "simple.qos"
o:value("layer_cake.qos", translate("layer_cake.qos"))
o:value("piece_of_cake.qos", translate("piece_of_cake.qos"))
o:value("simple.qos", translate("simple.qos"))
o:value("simple_pppoe.qos", translate("simple_pppoe.qos"))
o:value("simplest.qos", translate("simplest.qos"))
o:value("simplest_tbf.qos", translate("simplest_tbf.qos"))

o = s:option(ListValue, "linklayer", translate("Link Layer"))
o.default = "ethernet"
o:value("none", translate("none"))
o:value("ethernet", translate("Ethernet"))
o:value("atm", translate("ATM"))

o = s:option(ListValue, "overhead", translate("Overhead Bytes"))
o.default = "18"
o:value("0", translate("none"))
o:value("18", translate("18 Ethernet Fibre/Cable"))
o:value("22", translate("22 Ethernet VDSL2"))
o:value("38", translate("38 Ethernet Ethernet"))
o:value("44", translate("44 ATM ADSL/DSL"))

o = s:option(Flag, "debug_logging", translate("Debug Logging"))
o.rmempty = false

o = s:option(ListValue, "verbosity", translate("Log verbosity"))
o.default = "5"
o:value("0", translate("silent"))
o:value("1", translate("error"))
o:value("2", translate("warning"))
o:value("5", translate("info"))
o:value("8", translate("debug"))
o:value("10", translate("trace"))

o = s:option(Flag, "qdisc_advanced", translate("Advanced Configuration"))
o.rmempty = false

return m
