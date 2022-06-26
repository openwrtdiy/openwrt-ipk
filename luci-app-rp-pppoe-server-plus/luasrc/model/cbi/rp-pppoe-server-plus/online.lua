local uci = luci.model.uci.cursor()
local utl = require "luci.util"

f = Map("pppoe-server")

local e = {}
local o = require "luci.dispatcher"
local a = luci.util.execi("top -bn1 | grep 'pppd plugin .*pppoe.so' | grep -v 'grep'")
for t in a do
    local a, h, s, o = t:match("^ *(%d+) +.+rp_pppoe_sess [0-9]+:+([A-Fa-f0-9]+:[A-Fa-f0-9]+:[A-Fa-f0-9]+:[A-Fa-f0-9]+:[A-Fa-f0-9]+:[A-Fa-f0-9]+[A-Fa-f0-9]) +.+options +(%S.-%S)%:(%S.-%S) ")
    local t = tonumber(a)
    if t then
        e["%02i.%s" % {t, "online"}] = {
            ['PID'] = a,
            ['PPID'] = n,
            ['MAC'] = h,
            ['GATEWAY'] = s,
            ['CIP'] = o,
            ['BLACKLIST'] = 0
        }
    end
end

f = SimpleForm("")
f.reset = false
f.submit = false

local count = luci.sys.exec("top -bn1 | grep 'pppd plugin pppoe.so' | grep -v 'grep' | wc -l")
t = f:section(Table, e, translate("Online [ " .. count .. "]"))
t:option(DummyValue, "MAC", translate("MAC address"))
t:option(DummyValue, "CIP", translate("IP address"))
t:option(DummyValue, "GATEWAY", translate("Server IP"))

kill = t:option(Button, "kill", translate("Forced Offline"))
kill.inputstyle = "reset"
function kill.write(e, t)
    null, e.tag_error[t] = luci.sys.process.signal(e.map:get(t, "PID"), 9)
    luci.http.redirect(o.build_url("admin/services/rp-pppoe-server-plus/online"))
end
return f
