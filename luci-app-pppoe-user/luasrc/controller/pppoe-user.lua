module("luci.controller.pppoe-user", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-user") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("Broadband User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("pppoe-user/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "realtimetraffic"}, form("pppoe-user/realtimetraffic"), _("Realtime Traffic"), 2).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("pppoe-user/downtimeuser"), _("Downtime User"), 3).leaf = true
	entry({"admin", "status", "userstatus", "onlinelog"}, form("pppoe-user/onlinelog"), _("Online Log"), 4).leaf = true
	entry({"admin", "status", "userstatus", "offlinelog"}, form("pppoe-user/offlinelog"), _("Offline Log"), 5).leaf = true
	entry({"admin", "status", "userstatus", "rate"}, template("nft-qos/rate"), _("Rate"), 6).leaf = true

	entry({"admin", "services", "pppoe-user"}, alias("admin", "services", "pppoe-user", "user"), _("Broadband Account Management"), 99)
	entry({"admin", "services", "pppoe-user", "user"}, cbi("pppoe-user/user"), _("User Manager")).leaf = true
end
