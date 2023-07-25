#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=PPPoE QoS over Nftables
LUCI_DEPENDS:=+luci-compat +pppoe-qos
LUCI_PKGARCH:=all
PKG_VERSION:=1.0.0
PKG_RELEASE:=0
PKG_DATE:=2023-07-25

#include ../../luci.mk
include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
