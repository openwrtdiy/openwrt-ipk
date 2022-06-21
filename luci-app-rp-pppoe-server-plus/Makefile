#
# Copyright (C) 2022 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Roaring Penguin PPPoE Server Plus
LUCI_DEPENDS:=+luci-compat +rp-pppoe-server +libpcap
PKG_LICENSE:=GPL-2.0-or-later
PKG_VERSION:=2022-06-21
PKG_RELEASE:=1

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
