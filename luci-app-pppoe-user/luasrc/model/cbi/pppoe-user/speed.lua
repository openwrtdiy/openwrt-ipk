m = Map("pppoe-user", translate(""), translate("Tip: When there is no option to enter a parameter value in the form box! Default values will be used for ip address, service name, upload speed, download speed, Speed unit and number of connections!"))

s = m:section(TypedSection, "user", translate(""), translate("Speed unit: 1 MBytes/s = 125 KBytes/s (vs) 1 MBytes/s = 125000 Bytes/s Connections: 64~65536"))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "qos", translate("QoS"))
o.rmempty = true
o.default = 1

o = s:option(DummyValue, "username", translate("User Name"))
o.readonly = true

o = s:option(DummyValue, "macaddress", translate("MAC address"))
o.rmempty = true

o = s:option(DummyValue, "package", translate("Broadband Package"))
o.rmempty = true

o = s:option(Value, "upload", translate("Upload speed"))
o.rmempty = true

o = s:option(Value, "download", translate("Download speed"))
o.rmempty = true

o = s:option(ListValue, "unit", translate("Speed unit"))
o.default = "kbytes"
o.rmempty = true
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

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

return m
