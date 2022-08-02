#
# Copyright (C) 2022 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Roaring Penguin PPPoE Server Plus
LUCI_DEPENDS:=+luci-compat +rp-pppoe-server +libpcap
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_DATE:=2022-08-02
PKG_LICENSE:=GPL-2.0-or-later

define Package/luci-app-rp-pppoe-server-plus/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-server >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
