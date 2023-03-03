local o = require "luci.dispatcher"
local fs = require "nixio.fs"
local jsonc = require "luci.jsonc"

f = SimpleForm("")
f.reset = false
f.submit = false

local count = luci.sys.exec("ifconfig | grep ppp | wc -l")
t = f:section(Table, sessions, translate("Online User [ " .. count .. "]"))
t:option(DummyValue, "username", translate("User Name"))
t:option(DummyValue, "macaddress", translate("MAC address"))
t:option(DummyValue, "uptime", translate("Up Time"))
t:option(DummyValue, "connect", translate("Connections"))
t:option(DummyValue, "realtimeupload", translate("Realtime Upload"))
t:option(DummyValue, "realtimedownload", translate("Realtime Download"))
t:option(DummyValue, "totaluploads", translate("Total Uploads"))
t:option(DummyValue, "totaldownloads", translate("Total Downloads"))

return f
