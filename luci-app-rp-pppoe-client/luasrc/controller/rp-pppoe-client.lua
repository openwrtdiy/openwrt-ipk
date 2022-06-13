module("luci.controller.rp-pppoe-client", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-client") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("PPPoE User Status"), 99)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("rp-pppoe-client/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "userlog"}, form("rp-pppoe-client/userlog"), _("User Log"), 2).leaf = true

	entry({"admin", "services", "rp-pppoe-client"}, alias("admin", "services", "rp-pppoe-client", "user"), _("PPPoE User Management"), 99)
	entry({"admin", "services", "rp-pppoe-client", "user"}, cbi("rp-pppoe-client/user"), _("User Manager"), 10).leaf = true
	entry({"admin", "services", "rp-pppoe-client", "speed"}, cbi("rp-pppoe-client/speed"), _("Traffic Control"), 20).leaf = true
end
