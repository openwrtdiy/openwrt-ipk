
include $(TOPDIR)/rules.mk

LUCI_TITLE:=Roaring Penguin PPPoE Client User Manager
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_DATE:=2022-11-15

define Package/luci-app-rp-pppoe-client/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe-client >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-client >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
