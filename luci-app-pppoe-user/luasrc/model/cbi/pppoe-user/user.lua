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
o:value("128", "1 M")
o:value("256", "2 M")
o:value("384", "3 M")
o:value("512", "4 M")
o:value("640", "5 M")
o:value("1280", "10 Mbps")
o:value("2560", "20 M")
o:value("3840", "30 M")
o:value("5120", "40 M")
o:value("6400", "50 M")
o:value("7680", "60 M")
o:value("8960", "70 M")
o:value("10240", "80 M")
o:value("11520", "90 M")
o:value("12800", "100 Mbps")
o:value("25600", "200 M")
o:value("38400", "300 M")
o:value("51200", "400 M")
o:value("64000", "500 M")
o:value("76800", "600 M")
o:value("89600", "700 M")
o:value("102400", "800 M")
o:value("115200", "900 M")
o:value("128000", "1000 Mbps")

o = s:option(ListValue, "download", translate("Download speed"))
o.datatype = "uinteger"
o.rmempty = true
o:value("128", "1 M")
o:value("256", "2 M")
o:value("384", "3 M")
o:value("512", "4 M")
o:value("640", "5 M")
o:value("1280", "10 Mbps")
o:value("2560", "20 M")
o:value("3840", "30 M")
o:value("5120", "40 M")
o:value("6400", "50 M")
o:value("7680", "60 M")
o:value("8960", "70 M")
o:value("10240", "80 M")
o:value("11520", "90 M")
o:value("12800", "100 Mbps")
o:value("25600", "200 M")
o:value("38400", "300 M")
o:value("51200", "400 M")
o:value("64000", "500 M")
o:value("76800", "600 M")
o:value("89600", "700 M")
o:value("102400", "800 M")
o:value("115200", "900 M")
o:value("128000", "1000 Mbps")

o = s:option(Value, "expires", translate("Expire date"))
o.placeholder = translate("Expires")
o.datatype = "range(20230101,20231231)"
o.rmempty = true

return m
