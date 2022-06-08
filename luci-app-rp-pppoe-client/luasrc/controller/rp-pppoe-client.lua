module("luci.controller.rp-pppoe-client", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-client") then
		return
	end
	entry({"admin", "services", "rp-pppoe-client"}, alias("admin", "services", "rp-pppoe-client", "online"), _("PPPoE User Management"), 4)
	entry({"admin", "services", "rp-pppoe-client", "online"}, form("rp-pppoe-client/online"), _("Online User"), 10).leaf = true
	entry({"admin", "services", "rp-pppoe-client", "user"}, cbi("rp-pppoe-client/user"), _("User Manager"), 20).leaf = true
	entry({"admin", "services", "rp-pppoe-client", "speed"}, cbi("rp-pppoe-client/speed"), _("Traffic Control"), 30).leaf = true
	entry({"admin", "services", "rp-pppoe-client", "log"}, form("rp-pppoe-client/log"), _("PPPoE Log"), 40).leaf = true

end
