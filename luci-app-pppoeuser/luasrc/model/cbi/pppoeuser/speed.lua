m = Map("pppoeuser", translate(""), translate("Tip: When there is no option to enter a parameter value in the form box! Default values will be used for ip address, service name, upload speed, download speed, Speed unit and number of connections!"))

s = m:section(TypedSection, "user", translate(""), translate("Data Transfer Rate: 125000 Bytes/s = 125 KBytes/s = 0.125 MBytes/s = 1 Mbps/s Connections: 64~65536"))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "qos", translate("QoS"))
o.rmempty = true
o.default = 1

o = s:option(DummyValue, "hostname", translate("User Name"))
o.readonly = true

o = s:option(DummyValue, "macaddr", translate("MAC address"))
o.rmempty = true

o = s:option(DummyValue, "package", translate("Broadband Package"))
o.rmempty = true

o = s:option(Value, "urate", translate("Upload speed"))

o = s:option(Value, "drate", translate("Download speed"))

o = s:option(ListValue, "unit", translate("Speed unit"))
o.default = "kbytes"
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

o = s:option(ListValue, "connect", translate("Connections"))
o.default = "8192"
o:value("3072", "30M Family")
o:value("4096", "40M Family")
o:value("6144", "60M Family")
o:value("8192", "80M Family")
o:value("16384", "100M Office")
o:value("32768", "200M Office")
o:value("65536", "400M Office")
o:value("256", "4M Test")
o:value("512", "8M Test")
o:value("1024", "10M Test")

return m
