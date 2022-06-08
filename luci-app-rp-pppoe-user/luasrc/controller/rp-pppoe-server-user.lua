module("luci.controller.rp-pppoe-server-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "services", "rp-pppoe-server-user"}, alias("admin", "services", "rp-pppoe-server-user", "online"), _("PPPoE User Management"), 4)
	entry({"admin", "services", "rp-pppoe-server-user", "online"}, form("rp-pppoe-server-user/online"), _("Online User"), 10).leaf = true
	entry({"admin", "services", "rp-pppoe-server-user", "user"}, cbi("rp-pppoe-server-user/user"), _("User Manager"), 20).leaf = true
	entry({"admin", "services", "rp-pppoe-server-user", "speed"}, cbi("rp-pppoe-server-user/speed"), _("Traffic Control"), 30).leaf = true
	entry({"admin", "services", "rp-pppoe-server-user", "log"}, form("rp-pppoe-server-user/log"), _("PPPoE Log"), 40).leaf = true

end
