module("luci.controller.pppoe-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "services", "pppoe-user"}, alias("admin", "services", "pppoe-user", "online"), _("PPPoE User Management"), 4)
	entry({"admin", "services", "pppoe-user", "online"}, form("pppoe-user/online"), _("Online User"), 10).leaf = true
	entry({"admin", "services", "pppoe-user", "user"}, cbi("pppoe-user/user"), _("User Manager"), 20).leaf = true
	entry({"admin", "services", "pppoe-user", "speed"}, cbi("pppoe-user/speed"), _("Traffic Control"), 30).leaf = true
	entry({"admin", "services", "pppoe-user", "pppoelog"}, form("pppoe-user/pppoelog"), _("PPPoE Log"), 40).leaf = true

end
