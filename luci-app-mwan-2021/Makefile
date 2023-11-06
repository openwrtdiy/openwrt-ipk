#
# Copyright (C) 2017 Dan Luedtke <mail@danrl.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for the MWAN-2021 multiwan hotplug script
LUCI_DEPENDS:=+luci-compat \
	+mwan-2021 \
	+libuci-lua \
	+luci-mod-admin-full \
	+luci-lib-nixio
LUCI_PKGARCH:=all
PKG_LICENSE:=GPLv2

PKG_MAINTAINER:=Aedan Renner <chipdankly@gmail.com> \
		Florian Eckert <fe@dev.tdt.de>

#include ../../luci.mk
include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
