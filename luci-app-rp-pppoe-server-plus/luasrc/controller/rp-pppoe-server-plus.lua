module("luci.controller.rp-pppoe-server-plus", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/pppoe-server") then
		return
	end
	entry({"admin", "services", "rp-pppoe-server-plus"}, alias("admin", "services", "rp-pppoe-server-plus", "server"), _("PPPoE Server"), 9).dependent = true
	entry({"admin", "services", "rp-pppoe-server-plus", "server"}, cbi("rp-pppoe-server-plus/server"), _("General Settings"),10).leaf = true
	entry({"admin", "services", "rp-pppoe-server-plus", "pppd"}, cbi("rp-pppoe-server-plus/pppd"),_("Advanced Settings"),20).leaf = true
	entry({"admin", "services", "rp-pppoe-server-plus", "firewall"}, cbi("rp-pppoe-server-plus/firewall"),_("Firewall Settings"),30).leaf = true
	entry({"admin", "services", "rp-pppoe-server-plus", "log"}, form("rp-pppoe-server-plus/log"), _("Logging"), 40).leaf = true
	entry({"admin", "services", "rp-pppoe-server-plus", "online"}, form("rp-pppoe-server-plus/online"),_("Online"),50).leaf = true
end
