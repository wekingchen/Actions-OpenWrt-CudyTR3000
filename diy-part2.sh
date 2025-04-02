#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 修改golang源码以编译xray1.8.8+版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang
sed -i '/-linkmode external \\/d' feeds/packages/lang/golang/golang-package.mk

# 修改frp版本为官网最新v0.61.2 https://github.com/fatedier/frp 格式：https://codeload.github.com/fatedier/frp/tar.gz/v${PKG_VERSION}?
sed -i 's/PKG_VERSION:=0.51.3/PKG_VERSION:=0.61.2/' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=83032399773901348c660d41c967530e794ab58172ccd070db89d5e50d915fef/PKG_HASH:=19600d944e05f7ed95bac53c18cbae6ce7eff859c62b434b0c315ca72acb1d3c/' feeds/packages/net/frp/Makefile
