m = Map("pppoeuser", translate(""), translate(""))

s = m:section(TypedSection, "user", translate(""), translate(""))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(DummyValue, "username", translate("User Name"))
o.readonly = true

o = s:option(DummyValue, "macaddress", translate("MAC address"))
o.rmempty = true

o = s:option(DummyValue, "package", translate("Broadband Package"))
o.rmempty = true

o = s:option(DummyValue, "expires", translate("Expiration date"))
o.rmempty = true

o = s:option(Value, "phone", translate("Contact Number"))
o.rmempty = true

o = s:option(Value, "area", translate("Installation Area"))
o.rmempty = true

o = s:option(Value, "remark", translate("Remark"))
o.rmempty = true

return m
