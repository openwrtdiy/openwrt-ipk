local o = require "luci.dispatcher"
local fs = require "nixio.fs"
local jsonc = require "luci.jsonc"

local sessions = {}
local session_path = "/var/etc/pppoe-user/session"
if fs.access(session_path) then
    for filename in fs.dir(session_path) do
        local session_file = session_path .. "/" .. filename
        local file = io.open(session_file, "r")
        local t = jsonc.parse(file:read("*a"))
        if t then
            t.session_file = session_file
            sessions[#sessions + 1] = t
        end
        file:close()
    end
end

f = SimpleForm("")
f.reset = false
f.submit = false

local count = luci.sys.exec("top -bn1 | grep 'pppd plugin .*pppoe.so' | grep -v 'grep' | wc -l")
t = f:section(Table, sessions, translate("Online User [ " .. count .. "]"))
t:option(DummyValue, "username", translate("Username"))
t:option(DummyValue, "mac", translate("MAC address"))
t:option(DummyValue, "interface", translate("Interface"))
t:option(DummyValue, "ip", translate("IP address"))
t:option(DummyValue, "uptime", translate("Up Time"))

kill = t:option(Button, "kill", translate("Forced Offline"))
kill.inputstyle = "reset"
function kill.write(t, s)
    luci.util.execi("/usr/lib/sqm/run.sh stop $interface")
    luci.util.execi("rm -f " .. t.map:get(s, "session_file"))
    null, t.tag_error[t] = luci.sys.process.signal(t.map:get(s, "pid"), 9)
    luci.http.redirect(o.build_url("admin/status/userstatus/onlineuser"))
end

return f
