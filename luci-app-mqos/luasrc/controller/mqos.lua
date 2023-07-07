module("luci.controller.mqos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/mqos") then
		return
	end
	
	entry({"admin", "network", "mqos"}, cbi("mqos"), _("MQOS"), 10).dependent = true
end
