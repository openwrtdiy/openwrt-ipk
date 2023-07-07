include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mqos
PKG_VERSION:=1.0
PKG_RELEASE:=2

PKG_MAINTAINER:=WROIATE <j.wroiate@gmail.com>

LUCI_TITLE:=LuCI configuration pages for MQos
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-base +tc +kmod-sched-core +kmod-ifb

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
