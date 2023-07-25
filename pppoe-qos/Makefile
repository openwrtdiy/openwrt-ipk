#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=pppoe-qos
PKG_VERSION:=1.0.0
PKG_RELEASE:=0
PKG_LICENSE:=GPL-2.0

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/pppoe-qos
  SECTION:=utils
  CATEGORY:=Base system
  DEPENDS:=+kmod-nft-netdev +kmod-nft-bridge +nftables
  TITLE:=QoS scripts over nftables
  PKGARCH:=all
endef

define Package/pppoe-qos/description
 This package provides implementation for qos over nftables.
 Currently, static/dynamic qos and traffic shaping are supported.
endef

define Package/pppoe-qos/conffiles
/etc/config/pppoe-qos
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/pppoe-qos/install
	$(INSTALL_DIR) $(1)/lib/pppoe-qos
	$(INSTALL_DATA) ./files/lib/* $(1)/lib/pppoe-qos/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/pppoe-qos.config $(1)/etc/config/pppoe-qos
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/pppoe-qos.init $(1)/etc/init.d/pppoe-qos
	$(INSTALL_DIR) $(1)/etc/hotplug.d/dhcp
	$(INSTALL_BIN) ./files/qos-monitor.hotplug $(1)/etc/hotplug.d/dhcp/00-qos-monitor
	$(INSTALL_BIN) ./files/qos-dynamic.hotplug $(1)/etc/hotplug.d/dhcp/01-qos-dynamic
endef

$(eval $(call BuildPackage,pppoe-qos))
