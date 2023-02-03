m = Map("pppoe-user", translate(""), translate("Account opening instructions column content"))

local count = luci.sys.exec("grep -c 'config user' /etc/config/pppoe-user")
s = m:section(TypedSection, "user", translate("User count [ " .. count .. "]"), translate(""))
s.addremove = true
s.anonymous = true
s.nodescriptions = true
s.sortable  = true
s.template = "cbi/tblsection"

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "username", translate("User Name"))
o.placeholder = translate("Username")
o.rmempty = true

o = s:option(Value, "password", translate("Password"))
o.placeholder = translate("Password")
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

o = s:option(Value, "macaddress", translate("MAC address"))
o.placeholder = translate("Manual")
o.datatype = "macaddr"
o.rmempty = true

o = s:option(ListValue, "upload", translate("Upload speed"))
o.datatype = "uinteger"
o.rmempty = true
o:value("125", "1 M")
o:value("250", "2 M")
o:value("375", "3 M")
o:value("500", "4 M")
o:value("625", "5 M")
o:value("1250", "10 Mbps")
o:value("2500", "20 M")
o:value("3750", "30 M")
o:value("5000", "40 M")
o:value("6250", "50 M")
o:value("7500", "60 M")
o:value("8750", "70 M")
o:value("10000", "80 M")
o:value("11250", "90 M")
o:value("12500", "100 Mbps")
o:value("25000", "200 M")
o:value("37500", "300 M")
o:value("50000", "400 M")
o:value("62500", "500 M")
o:value("75000", "600 M")
o:value("87500", "700 M")
o:value("100000", "800 M")
o:value("112500", "900 M")
o:value("125000", "1000 Mbps")

o = s:option(ListValue, "download", translate("Download speed"))
o.datatype = "uinteger"
o.rmempty = true
o:value("125", "1 M")
o:value("250", "2 M")
o:value("375", "3 M")
o:value("500", "4 M")
o:value("625", "5 M")
o:value("1250", "10 Mbps")
o:value("2500", "20 M")
o:value("3750", "30 M")
o:value("5000", "40 M")
o:value("6250", "50 M")
o:value("7500", "60 M")
o:value("8750", "70 M")
o:value("10000", "80 M")
o:value("11250", "90 M")
o:value("12500", "100 Mbps")
o:value("25000", "200 M")
o:value("37500", "300 M")
o:value("50000", "400 M")
o:value("62500", "500 M")
o:value("75000", "600 M")
o:value("87500", "700 M")
o:value("100000", "800 M")
o:value("112500", "900 M")
o:value("125000", "1000 Mbps")

o = s:option(Value, "connect", translate("Connections"))
o.placeholder = translate("Connection limit")
o.datatype = "range(64,65536)"
o.rmempty = true
o.default = 1024
o:value("64", "64")
o:value("128", "128")
o:value("256", "256")
o:value("512", "512")
o:value("1024", "30 M")
o:value("2048", "60 M")
o:value("4096", "100 M")
o:value("8192", "200 M")
o:value("16384", "300 M")
o:value("32768", "400 M")
o:value("65536", "500 M")

o = s:option(Value, "expires", translate("Expire date"))
o.placeholder = translate("Expires")
o.datatype = "range(20230101,20231231)"
o.rmempty = true

return m
