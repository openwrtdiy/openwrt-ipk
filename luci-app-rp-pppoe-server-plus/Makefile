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
PKG_DATE:=2022-06-26
PKG_LICENSE:=GPL-2.0-or-later

define Package/luci-app-rp-pppoe-server-plus/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-server >/dev/null 2>&1
cp -p $${IPKG_INSTROOT}/usr/lib/pppd/2.4.7/rp-pppoe.so /usr/lib/pppd/2.4.7/pppoe.so
cp -p $${IPKG_INSTROOT}/usr/lib/pppd/2.4.8/rp-pppoe.so /usr/lib/pppd/2.4.8/pppoe.so
cp -p $${IPKG_INSTROOT}/usr/lib/pppd/2.4.9/rp-pppoe.so /usr/lib/pppd/2.4.9/pppoe.so
exit 0
endef

define Package/luci-app-rp-pppoe-server-plus/postinst
#!/bin/sh
chmod 600 /etc/config/pppoe-server
chmod 755 /etc/init.d/pppoe-server
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
