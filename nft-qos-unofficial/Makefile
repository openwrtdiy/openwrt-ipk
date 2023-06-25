#
# Copyright (C) 2018 rosysong@rosinson.com
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=nft-qos-unofficial
PKG_VERSION:=1.0.6
PKG_RELEASE:=4
PKG_LICENSE:=GPL-2.0

PKG_MAINTAINER:=Rosy Song <rosysong@rosinson.com>

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/nft-qos-unofficial
  SECTION:=utils
  CATEGORY:=Base system
  DEPENDS:=+kmod-nft-netdev +kmod-nft-bridge +nftables
  TITLE:=QoS scripts over nftables
  PKGARCH:=all
endef

define Package/nft-qos-unofficial/description
 This package provides implementation for qos over nftables.
 Currently, static/dynamic qos and traffic shaping are supported.
endef

define Package/nft-qos-unofficial/conffiles
/etc/config/nft-qos-unofficial
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/nft-qos-unofficial/install
	$(INSTALL_DIR) $(1)/lib/nft-qos-unofficial
	$(INSTALL_DATA) ./files/lib/* $(1)/lib/nft-qos-unofficial/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/nft-qos-unofficial.config $(1)/etc/config/nft-qos-unofficial
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nft-qos-unofficial.init $(1)/etc/init.d/nft-qos-unofficial
	$(INSTALL_DIR) $(1)/etc/hotplug.d/dhcp
	$(INSTALL_BIN) ./files/nft-qos-unofficial-monitor.hotplug $(1)/etc/hotplug.d/dhcp/00-nft-qos-unofficial-monitor
	$(INSTALL_BIN) ./files/nft-qos-unofficial-dynamic.hotplug $(1)/etc/hotplug.d/dhcp/01-nft-qos-unofficial-dynamic
endef

$(eval $(call BuildPackage,nft-qos-unofficial))
