m = Map("pppoe-user", translate(""))
m.description = translate("The PPPoE server is a broadband access authentication server that prevents ARP spoofing.")
s = m:section(TypedSection, "user", translate("Users Manager"))
s.addremove = true
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Flag, "enabled", translate("Enabled"))
o.rmempty = false

o = s:option(Value, "username", translate("Account"))
o.placeholder = translate("User name")
o.rmempty = true

o = s:option(Value, "password", translate("Password"))
o.rmempty = true

o = s:option(Value, "ipaddress", translate("IP address"))
o.placeholder = translate("Automatically")
o.datatype = "ipaddr"
o.rmempty = true
function o.cfgvalue(e, t)
    value = e.map:get(t, "ipaddress")
    return value == "*" and "" or value
end
function o.remove(e, t) Value.write(e, t, "*") end

o = s:option(Value, "validperiod", translate("Valid Period"))
o.placeholder = translate("Valid Period")
o.rmempty = true

o = s:option(Value, "remarks", translate("Remarks"))
o.placeholder = translate("Remarks")
o.rmempty = true
return m
