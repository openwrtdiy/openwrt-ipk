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

o = s:option(DummyValue, "macaddress", translate("MAC address"))
o.placeholder = translate("Manual")
o.datatype = "macaddr"
o.rmempty = true

o = s:option(DummyValue, "package", translate("Broadband Package"))
o.rmempty = true

o = s:option(DummyValue, "upload", translate("Upload speed"))
o.rmempty = true

o = s:option(DummyValue, "download", translate("Download speed"))
o.rmempty = true

o = s:option(DummyValue, "connect", translate("Connections"))
o.rmempty = true

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
o:value("ethernet", translate("ethernet"))
o:value("atm", translate("atm"))

o = s:option(Value, "overhead", translate("Overhead Bytes"))
o.default = "44"

o = s:option(Flag, "debug_logging", translate("Debug Logging"))
o.rmempty = false

o = s:option(Value, "verbosity", translate("Log verbosity"))
o.default = "5"

return m
