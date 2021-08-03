-- Copyright 2018-2019 Lienol <lawlienol@gmail.com>
module("luci.controller.pppoe-user", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/pppoe-user") then return end

    entry({"admin", "services", "pppoe-user"},
          alias("admin", "services", "pppoe-user", "users"),
          _("PPPoE User"), 3)
    entry({"admin", "services", "pppoe-user", "users"},
          cbi("pppoe-user/users"), _("Users Manager"), 10).leaf = true
    entry({"admin", "services", "pppoe-user", "online"},
          cbi("pppoe-user/online"), _("Online Users"), 20).leaf = true
    entry({"admin", "services", "pppoe-user", "status"}, call("status")).leaf = true
    entry({"admin", "services", "pppoe-user", "expire"},
          cbi("pppoe-user/expire"), _("Expire Users"), 30).leaf = true
    entry({"admin", "services", "pppoe-user", "status"}, call("status")).leaf = true
end

function status()
    local e = {}
    e.status = luci.sys.call("pidof %s >/dev/null" % "pppoe-user") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
