m = Map("pppoe-user", translate("User Status"))

s = m:section(TypedSection, "user", translate(""))
s.anonymous = true
s.template = "cbi/tblsection"

o = s:option(Value, "username", translate("User Name"))
o.placeholder = translate("User Name")
o.readonly = true

o = s:option(Value, "expires", translate("Expires"))
o.placeholder = translate("Expires")
o.readonly = true

return m
