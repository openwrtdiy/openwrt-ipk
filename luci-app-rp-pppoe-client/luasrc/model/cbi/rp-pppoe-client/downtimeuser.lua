local o = require "luci.dispatcher"
local fs = require "nixio.fs"
local jsonc = require "luci.jsonc"

f = SimpleForm("")
f.reset = false
f.submit = false

local count = luci.sys.exec("grep -c enabled /etc/config/pppoe-client")
t = f:section(Table, sessions, translate("Downtime User [ " .. count .. "]"))
t:option(DummyValue, "username", translate("Username"))
t:option(DummyValue, "macaddress", translate("MAC address"))
t:option(DummyValue, "upload", translate("Bandwidth"))
t:option(DummyValue, "password", translate("Account opening date"))
t:option(DummyValue, "renewaldate", translate("Renewal date"))
t:option(DummyValue, "downtime", translate("Down Time"))

return f
