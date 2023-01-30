
include $(TOPDIR)/rules.mk

LUCI_TITLE:=PPPoE User Manager
LUCI_DEPENDS:=+luci-compat +nft-qos
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKG_DATE:=2023-01-30

define Package/luci-app-pppoe-user/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe-user >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-user >/dev/null 2>&1
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
