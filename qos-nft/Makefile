#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=qos-nft
PKG_VERSION:=1.0.1
PKG_RELEASE:=2
PKG_LICENSE:=GPL-2.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/qos-nft
  SECTION:=utils
  CATEGORY:=Base system
  DEPENDS:=+kmod-nft-netdev +kmod-nft-bridge +nftables
  TITLE:=QoS scripts over nftables
  PKGARCH:=all
endef

define Package/qos-nft/description
 This package provides implementation for qos over nftables.
 Currently, static/dynamic qos and traffic shaping are supported.
endef

define Package/qos-nft/conffiles
/etc/config/qos-nft
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/qos-nft/install
	$(INSTALL_DIR) $(1)/lib/qos-nft
	$(INSTALL_DATA) ./files/lib/* $(1)/lib/qos-nft/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/qos-nft.config $(1)/etc/config/qos-nft
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/qos-nft.init $(1)/etc/init.d/qos-nft
	$(INSTALL_DIR) $(1)/etc/hotplug.d/dhcp
	$(INSTALL_BIN) ./files/qos-monitor.hotplug $(1)/etc/hotplug.d/dhcp/00-qos-monitor
	$(INSTALL_BIN) ./files/qos-dynamic.hotplug $(1)/etc/hotplug.d/dhcp/01-qos-dynamic
endef

$(eval $(call BuildPackage,qos-nft))
