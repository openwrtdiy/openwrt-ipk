#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI Supports QoS over Nftables
LUCI_DEPENDS:=+luci-compat +qos-nft
LUCI_PKGARCH:=all
PKG_VERSION:=1.0.1
PKG_RELEASE:=3
PKG_DATE:=2024-10-04

#include ../../luci.mk
include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
