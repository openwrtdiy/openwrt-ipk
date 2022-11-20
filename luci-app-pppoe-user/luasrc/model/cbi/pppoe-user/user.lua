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

o = s:option(Value, "expires", translate("Expire date"))
o.placeholder = translate("Expires")
o.datatype = "range(20220901,20231231)"
o.rmempty = true

o = s:option(ListValue, "upload", translate("Download speed"))
o.datatype = "uinteger"
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

o = s:option(ListValue, "download", translate("Upload speed"))
o.datatype = "uinteger"
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

return m
