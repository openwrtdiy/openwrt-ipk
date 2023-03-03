m = Map("pppoe-user", translate("Tip: When there is no option to enter a parameter value in the form box! Default values will be used for ip address, service name, upload speed, download speed, Speed unit and number of connections!"))

local count = luci.sys.exec("grep -c 'config user' /etc/config/pppoe-user")
s = m:section(TypedSection, "user", translate("User number [ " .. count .. "]"), translate("Speed unit: 1 MBytes/s = () KBytes/s (vs) 1 MBytes/s = () Bytes/s Connections: 64~65536"))
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

o = s:option(Value, "password", translate("Password"))
o.placeholder = translate("Password")
o.default = os.date("%Y%m%d")
o.password = true
o.rmempty = false

o = s:option(DummyValue, "servicename", translate("Service Name"))
o.placeholder = translate("Automatically")
o.default = "*"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "servicename")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(Value, "ipaddress", translate("IP address"))
o.placeholder = translate("Automatically")
o.datatype = "ipaddr"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "ipaddress")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(Value, "package", translate("Broadband Package"))
o.rmempty = true
o:value("none", translate("None"))
o:value("family", translate("Family"))
o:value("office", translate("Office"))
o:value("free", translate("Free"))
o:value("test", translate("Test"))
o:value("debugging", translate("Debugging"))

o = s:option(Value, "upload", translate("Upload speed"))
o.datatype = "uinteger"
o.rmempty = true

o = s:option(Value, "download", translate("Download speed"))
o.datatype = "uinteger"
o.rmempty = true

o = s:option(ListValue, "unit", translate("Speed unit"))
o.default = "kbytes"
o.rmempty = true
o:value("bytes", "Bytes/s")
o:value("kbytes", "KBytes/s")
o:value("mbytes", "MBytes/s")

o = s:option(Value, "connect", translate("Connections"))
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
