
include $(TOPDIR)/rules.mk

LUCI_TITLE:=PPPoE User Manager
LUCI_DEPENDS:=+luci-compat +kmod-nft-netdev +kmod-nft-bridge +nftables
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=7
PKG_DATE:=2023-03-02

define Package/luci-app-pppoe-user/preinst
#!/bin/sh
rm -rf $${IPKG_INSTROOT}/etc/config/pppoe-user >/dev/null 2>&1
rm -rf $${IPKG_INSTROOT}/etc/init.d/pppoe-user >/dev/null 2>&1
mkdir -p $${IPKG_INSTROOT}/home/log/userinfo >/dev/null 2>&1
iptables -w -t mangle -N pppoe_user
iptables -w -t mangle -C FORWARD -j pppoe_user || iptables -w -t mangle -I FORWARD -j pppoe_user
exit 0
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
