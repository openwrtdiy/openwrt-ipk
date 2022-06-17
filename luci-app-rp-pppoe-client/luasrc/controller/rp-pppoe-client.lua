module("luci.controller.rp-pppoe-client", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-client") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("PPPoE User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("rp-pppoe-client/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("rp-pppoe-client/downtimeuser"), _("Downtime User"), 2).leaf = true
	entry({"admin", "status", "userstatus", "pppoelog"}, form("rp-pppoe-client/pppoelog"), _("PPPoE Log"), 3).leaf = true

	entry({"admin", "services", "rp-pppoe-client"}, alias("admin", "services", "rp-pppoe-client", "user"), _("PPPoE User Management"), 99)
	entry({"admin", "services", "rp-pppoe-client", "user"}, cbi("rp-pppoe-client/user"), _("User Manager")).leaf = true

	entry({"admin", "network", "bandwidth"}, alias("admin", "network", "bandwidth", "speed"), _("PPPoE User Speed Limit"), 999)
	entry({"admin", "network", "bandwidth", "speed"}, cbi("rp-pppoe-client/speed"), _("Traffic Control")).leaf = true
end
