module("luci.controller.pppoeuser", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoeuser") then
		return
	end
	entry({"admin", "status", "userstatus"}, alias("admin", "status", "userstatus", "onlineuser"), _("User Status"), 999)
	entry({"admin", "status", "userstatus", "onlineuser"}, form("pppoeuser/onlineuser"), _("Online User"), 1).leaf = true
	entry({"admin", "status", "userstatus", "downtimeuser"}, form("pppoeuser/downtimeuser"), _("Downtime User"), 2).leaf = true
	entry({"admin", "status", "userstatus", "userup"}, form("pppoeuser/userup"), _("Online Log"), 3).leaf = true
	entry({"admin", "status", "userstatus", "userdown"}, form("pppoeuser/userdown"), _("Offline Log"), 4).leaf = true
	entry({"admin", "status", "userstatus", "userqos"}, form("pppoeuser/userqos"), _("QOS Log"), 5).leaf = true
	entry({"admin", "status", "userstatus", "realtimetraffic"}, form("pppoeuser/realtimetraffic"), _("Realtime Rate"), 6).leaf = true
	entry({"admin", "status", "userstatus", "interfacelog"}, form("pppoeuser/interfacelog"), _("Interface Log"), 8).leaf = true
	entry({"admin", "status", "userstatus", "interface"}, form("pppoeuser/interface"), _("Interface Information"), 9).leaf = true
	entry({"admin", "status", "userstatus", "network"}, form("pppoeuser/network"), _("Network Information"), 10).leaf = true

	entry({"admin", "services", "pppoeuser"}, alias("admin", "services", "pppoeuser", "user"), _("User Manager"), 777)
	entry({"admin", "services", "pppoeuser", "user"}, cbi("pppoeuser/user"), _("User Manager"), 1).leaf = true
	entry({"admin", "services", "pppoeuser", "userinfo"}, cbi("pppoeuser/userinfo"), _("User Info"), 2).leaf = true

	entry({"admin", "network", "bandwidth"}, alias("admin", "network", "bandwidth", "speed"), _("Account speed limit"), 666)
	entry({"admin", "network", "bandwidth", "speed"}, cbi("pppoeuser/speed"), _("Traffic Control")).leaf = true
end
