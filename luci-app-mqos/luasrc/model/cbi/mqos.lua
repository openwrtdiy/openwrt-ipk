m = Map("mqos")
m.title = translate("MQOS")
m.description = translate("按 MAC 地址限速设备")

s = m:section(TypedSection, "global")
s.addremove = false
s.anonymous = true

e = s:option(Flag, "enabled", translate("启用"))

ifa = s:option(Value, "interface", translate("接口"))
ifa.description = translate("需要先保存应用")
ifa.datatype = "string"
ifa.default = "br-lan"

dl = s:option(Value, "download", translate("下载速度 (Mbit/s)"))
dl.description = translate("接口下载速度")
dl.datatype = "and(uinteger,min(1))"

ul = s:option(Value, "upload", translate("上传速度 (Mbit/s)"))
ul.description = translate("接口上传速度")
ul.datatype = "and(uinteger,min(1))"

s = m:section(TypedSection, "device", translate("基于 MAC 地址限速"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.sortable = true

mac = s:option(Value, "mac", translate("地址"))
mac.datatype = "macaddr"

luci.ip.neighbors({family = 4, dev = luci.sys.exec("uci get mqos.@global[0].interface")},
  function(n)
	if n.mac and n.dest then
		mac:value(n.mac, "%s (%s)" % {n.dest:string(), n.mac})
	end
end)

dl = s:option(Value, "download", translate("下载速度 (Mbit/s)"))
dl.datatype = "and(uinteger,min(1))"

ul = s:option(Value, "upload", translate("上传速度 (Mbit/s)"))
ul.datatype = "and(uinteger,min(1))"

comment = s:option(Value, "comment", translate("备注"))

return m
