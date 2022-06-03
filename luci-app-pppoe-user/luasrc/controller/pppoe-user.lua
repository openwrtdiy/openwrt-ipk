module("luci.controller.pppoe-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "services", "pppoe-user"}, alias("admin", "services", "pppoe-user", "authlog"), _("PPPoE User Management"), 5)
	entry({"admin", "services", "pppoe-user", "authlog"}, cbi("pppoe-user/authlog"), _("Auth Log"), 10).leaf = true
	entry({"admin", "services", "pppoe-user", "user"}, cbi("pppoe-user/user"), _("User Manager"), 20).leaf = true
	entry({"admin", "services", "pppoe-user", "speed"}, cbi("pppoe-user/speed"), _("Traffic Control"), 30).leaf = true
	entry({"admin", "services", "pppoe-user", "online"}, cbi("pppoe-user/online"), _("Online User"), 40).leaf = true
	entry({"admin", "services", "pppoe-user", "status"}, cbi("pppoe-user/status"), _("User Status"), 50).leaf = true
end
