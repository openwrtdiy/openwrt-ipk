m = Map("pppoe-client", translate(""), translate("Account opening instructions column content"))

local count = luci.sys.exec("grep -c 'config user' /etc/config/pppoe-client")
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

o = s:option(Value, "expires", translate("Expire date"))
o.placeholder = translate("Expires")
o.datatype = "range(20220401,20221231)"
o.rmempty = true

o = s:option(ListValue, "upload", translate("Download speed"))
o.datatype = "uinteger"
o.rmempty = true
o:value("1050", "1 Mbps")
o:value("2100", "2 M")
o:value("3150", "3 M")
o:value("4200", "4 M")
o:value("5250", "5 M")
o:value("6300", "6 M")
o:value("7350", "7 M")
o:value("8400", "8 M")
o:value("9450", "9 M")
o:value("10500", "10 Mbps")
o:value("21000", "20 M")
o:value("31500", "30 M")
o:value("42000", "40 M")
o:value("52500", "50 M")
o:value("63000", "60 M")
o:value("73500", "70 M")
o:value("84000", "80 M")
o:value("94500", "90 M")
o:value("105000", "100 Mbps")
o:value("210000", "200 M")
o:value("315000", "300 M")
o:value("420000", "400 M")
o:value("525000", "500 M")
o:value("630000", "600 M")
o:value("735000", "700 M")
o:value("840000", "800 M")
o:value("945000", "900 M")
o:value("1050000", "1000 Mbps")

o = s:option(ListValue, "download", translate("Upload speed"))
o.datatype = "uinteger"
o.rmempty = true
o:value("1050", "1 Mbps")
o:value("2100", "2 M")
o:value("3150", "3 M")
o:value("4200", "4 M")
o:value("5250", "5 M")
o:value("6300", "6 M")
o:value("7350", "7 M")
o:value("8400", "8 M")
o:value("9450", "9 M")
o:value("10500", "10 Mbps")
o:value("21000", "20 M")
o:value("31500", "30 M")
o:value("42000", "40 M")
o:value("52500", "50 M")
o:value("63000", "60 M")
o:value("73500", "70 M")
o:value("84000", "80 M")
o:value("94500", "90 M")
o:value("105000", "100 Mbps")
o:value("210000", "200 M")
o:value("315000", "300 M")
o:value("420000", "400 M")
o:value("525000", "500 M")
o:value("630000", "600 M")
o:value("735000", "700 M")
o:value("840000", "800 M")
o:value("945000", "900 M")
o:value("1050000", "1000 Mbps")

return m
