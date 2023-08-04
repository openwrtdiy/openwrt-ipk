#
# Copyright (C) 2021-2023 iKokang <kokangnet@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=PPPoE Server User Management
LUCI_DEPENDS:=+luci-compat +tc-full +kmod-sched-cake +kmod-ifb +iptables-mod-ipopt +kmod-veth
LUCI_PKGARCH:=all
PKG_VERSION:=2.1
PKG_RELEASE:=5
PKG_DATE:=2023-08-05

define Package/luci-app-pppoeuser/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoeuser >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoeuser >/dev/null 2>&1
mkdir -p $${IPKG_INSTROOT}/home/log/userinfo >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
