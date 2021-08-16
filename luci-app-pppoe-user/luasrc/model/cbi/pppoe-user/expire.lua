f = SimpleForm("processes", translate("PPPoE Users"))
f.reset = false
f.submit = false
f.description = translate("The PPPoE server is a broadband access authentication server that prevents ARP spoofing.")
t = f:section(Table, e, translate("Expire Users"))
t:option(DummyValue, "username", translate("Account"))
t:option(DummyValue, "mac", translate("MAC"))
t:option(DummyValue, "offlinetime", translate("Offline Time"))
t:option(DummyValue, "valid", translate("Valid Period"))
t:option(DummyValue, "remarks", translate("Remarks"))
return f
