#
# Copyright (C) 2022 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Roaring Penguin PPPoE Server Plus
LUCI_DEPENDS:=+luci-compat +rp-pppoe-server +libpcap
PKG_LICENSE:=GPL-2.0-or-later
PKG_VERSION:=2022-06-24
PKG_RELEASE:=1

define Package/luci-app-rp-pppoe-server-plus/preinst
#!/bin/sh
cp -rf /usr/lib/pppd/2.4.7/rp-pppoe.so /usr/lib/pppd/2.4.7/pppoe.so
cp -rf /usr/lib/pppd/2.4.8/rp-pppoe.so /usr/lib/pppd/2.4.8/pppoe.so
cp -rf /usr/lib/pppd/2.4.9/rp-pppoe.so /usr/lib/pppd/2.4.9/pppoe.so
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
