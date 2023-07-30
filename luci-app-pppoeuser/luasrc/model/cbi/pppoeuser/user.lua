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

o = s:option(Value, "hostname", translate("User Name"))
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

o = s:option(Value, "ipaddr", translate("IP address"))
o.placeholder = translate("Automatically")
o.datatype = "ipaddr"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "ipaddr")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(ListValue, "package", translate("Broadband Package"))
o:value("none", translate("None"))
o:value("free", translate("Free"))
o:value("family", translate("Family"))
o:value("office", translate("Office"))
o:value("test", translate("Test"))

o = s:option(ListValue, "urate", translate("Upload speed"))
o.default = "3750"
o:value("1250", "10 Mbps")
o:value("2500", "20 Mbps")
o:value("3750", "30 Mbps")
o:value("5000", "40 Mbps")
o:value("6250", "50 Mbps")
o:value("7500", "60 Mbps")
o:value("8750", "70 Mbps")
o:value("10000", "80 Mbps")
o:value("11250", "90 Mbps")
o:value("12500", "100 Mbps")
o:value("25000", "200 Mbps")
o:value("37500", "300 Mbps")
o:value("50000", "400 Mbps")
o:value("62500", "500 Mbps")
o:value("75000", "600 Mbps")
o:value("87500", "700 Mbps")
o:value("100000", "800 Mbps")
o:value("112500", "900 Mbps")
o:value("125000", "1000 Mbps")
o:value("156250", "1250 Mbps")
o:value("312500", "2500 Mbps")
o:value("1250000", "10000 Mbps")	
o:value("125", "1 Mbps")
o:value("250", "2 Mbps")
o:value("375", "3 Mbps")
o:value("500", "4 Mbps")
o:value("625", "5 Mbps")
o:value("750", "6 Mbps")
o:value("875", "7 Mbps")
o:value("1000", "8 Mbps")
o:value("1125", "9 Mbps")

o = s:option(ListValue, "drate", translate("Download speed"))
o.default = '3750'
o:value("1250", "10 Mbps")
o:value("2500", "20 Mbps")
o:value("3750", "30 Mbps")
o:value("5000", "40 Mbps")
o:value("6250", "50 Mbps")
o:value("7500", "60 Mbps")
o:value("8750", "70 Mbps")
o:value("10000", "80 Mbps")
o:value("11250", "90 Mbps")
o:value("12500", "100 Mbps")
o:value("25000", "200 Mbps")
o:value("37500", "300 Mbps")
o:value("50000", "400 Mbps")
o:value("62500", "500 Mbps")
o:value("75000", "600 Mbps")
o:value("87500", "700 Mbps")
o:value("100000", "800 Mbps")
o:value("112500", "900 Mbps")
o:value("125000", "1000 Mbps")
o:value("156250", "1250 Mbps")
o:value("312500", "2500 Mbps")
o:value("1250000", "10000 Mbps")	
o:value("125", "1 Mbps")
o:value("250", "2 Mbps")
o:value("375", "3 Mbps")
o:value("500", "4 Mbps")
o:value("625", "5 Mbps")
o:value("750", "6 Mbps")
o:value("875", "7 Mbps")
o:value("1000", "8 Mbps")
o:value("1125", "9 Mbps")

o = s:option(DummyValue, "unit", translate("Speed unit"))
o.default = "kbytes"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "unit")
    return value == "kbytes" and "" or value
end
function o.remove(e, t) Value.write(e, t, "kbytes") end

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

o = s:option(Value, "expires", translate("Expiration date"))
o.placeholder = translate("Expires")
o.datatype = "range(20230101,20231231)"
o.rmempty = true

return m
