m = Map("pppoeuser", translate(""), translate(""))

local count = luci.sys.exec("grep -c 'config user' /etc/config/pppoeuser")
s = m:section(TypedSection, "user", translate("User number [ " .. count .. "]"), translate(""))
s.addremove = true
s.anonymous = true
s.nodescriptions = true
s.sortable  = false
s.template = "cbi/tblsection"

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "username", translate("User Name"))
o.placeholder = translate("Username")
o.rmempty = true

o = s:option(DummyValue, "servicename", translate("Service Name"))
o.placeholder = translate("Automatically")
o.default = "*"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "servicename")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(Value, "password", translate("Password"))
o.placeholder = translate("Password")
o.default = os.date("%Y%m%d")
o.password = true
o.rmempty = false

o = s:option(Value, "ipaddress", translate("IP address"))
o.placeholder = translate("Automatically")
o.datatype = "ipaddr"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "ipaddress")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(ListValue, "package", translate("Broadband Package"))
o.rmempty = true
o:value("none", translate("None"))
o:value("family", translate("Family"))
o:value("office", translate("Office"))
o:value("free", translate("Free"))
o:value("test", translate("Test"))

o = s:option(ListValue, "upload", translate("Upload speed"))
o.default = "0"
o.datatype = "uinteger"
o.rmempty = true
o:value("1100", "10 Mbps")
o:value("2200", "20 Mbps")
o:value("3300", "30 Mbps")
o:value("4400", "40 Mbps")
o:value("5500", "50 Mbps")
o:value("6600", "60 Mbps")
o:value("7700", "70 Mbps")
o:value("8800", "80 Mbps")
o:value("9900", "90 Mbps")
o:value("11000", "100 Mbps")
o:value("22000", "200 Mbps")
o:value("33000", "300 Mbps")
o:value("44000", "400 Mbps")
o:value("55000", "500 Mbps")
o:value("66000", "600 Mbps")
o:value("77000", "700 Mbps")
o:value("88000", "800 Mbps")
o:value("99000", "900 Mbps")
o:value("110000", "1000 Mbps")

o = s:option(ListValue, "download", translate("Download speed"))
o.default = "0"
o.datatype = "uinteger"
o.rmempty = true
o:value("1100", "10 Mbps")
o:value("2200", "20 Mbps")
o:value("3300", "30 Mbps")
o:value("4400", "40 Mbps")
o:value("5500", "50 Mbps")
o:value("6600", "60 Mbps")
o:value("7700", "70 Mbps")
o:value("8800", "80 Mbps")
o:value("9900", "90 Mbps")
o:value("11000", "100 Mbps")
o:value("22000", "200 Mbps")
o:value("33000", "300 Mbps")
o:value("44000", "400 Mbps")
o:value("55000", "500 Mbps")
o:value("66000", "600 Mbps")
o:value("77000", "700 Mbps")
o:value("88000", "800 Mbps")
o:value("99000", "900 Mbps")
o:value("110000", "1000 Mbps")

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

o = s:option(Value, "expires", translate("Expiration date"))
o.placeholder = translate("Expires")
o.datatype = "range(20230101,20231231)"
o.rmempty = true

return m
