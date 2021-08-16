
include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for PPPoE Users Manager
LUCI_PKGARCH:=all
PKG_VERSION:=1
PKG_RELEASE:=20210814

define Package/luci-app-pppoe-user/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe-user >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-user >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
