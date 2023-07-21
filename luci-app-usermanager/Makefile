# See /LICENSE for more information.
# This is free software, licensed under the GNU General Public License v2.

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI usermanager app for js based luci
LUCI_DEPENDS:=+luci-base
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-usermanager
PKG_VERSION:=1.0
PKG_RELEASE:=20230722

#include ../../luci.mk
include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
