m = Map("pppoe-user", translate("PPPoE Users"))
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

o = s:option(Value, "cidr", translate("CIDR address"))
o.placeholder = translate("CIDR address")
o.rmempty = true

o = s:option(Value, "downloadrate", translate("Download Rate"))
o.placeholder = translate("Download Rate")
o.rmempty = true

o = s:option(Value, "uploadrate", translate("Upload Rate"))
o.placeholder = translate("Upload Rate")
o.rmempty = true

o = s:option(Value, "rule", translate("Rules policy"))
o.placeholder = translate("Rules policy")
o.rmempty = true

o = s:option(Value, "valid", translate("Valid Period"))
o.placeholder = translate("Valid Period")
o.rmempty = true

o = s:option(Value, "remarks", translate("Remarks"))
o.placeholder = translate("Remarks")
o.rmempty = true
return m
