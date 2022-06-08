
include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for PPPoE User Manager
LUCI_DEPENDS:=+luci-compat +rp-pppoe-server +sqm-scripts
LUCI_PKGARCH:=all
PKG_VERSION:=1
PKG_RELEASE:=2022-06-05

define Package/luci-app-rp-pppoe-client/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe-client >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-client >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
