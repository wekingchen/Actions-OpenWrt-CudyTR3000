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
rm -rf feeds/packages/net/frp
wget https://github.com/coolsnowwolf/packages/archive/0f7be9fc93d68986c179829d8199824d3183eb60.zip -O OldPackages.zip
unzip OldPackages.zip
cp -r packages-0f7be9fc93d68986c179829d8199824d3183eb60/net/frp feeds/packages/net/
rm -rf OldPackages.zip packages-0f7be9fc93d68986c179829d8199824d3183eb60s
sed -i 's/PKG_VERSION:=0.53.2/PKG_VERSION:=0.61.2/' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=ff2a4f04e7732bc77730304e48f97fdd062be2b142ae34c518ab9b9d7a3b32ec/PKG_HASH:=19600d944e05f7ed95bac53c18cbae6ce7eff859c62b434b0c315ca72acb1d3c/' feeds/packages/net/frp/Makefile

# 升级zerotier到官方最新版本1.14.2
sed -i 's/PKG_VERSION:=1.14.1/PKG_VERSION:=1.14.2/' feeds/packages/net/zerotier/Makefile
sed -i 's/PKG_HASH:=4f9f40b27c5a78389ed3f3216c850921f6298749e5819e9f2edabb2672ce9ca0/PKG_HASH:=c2f64339fccf5148a7af089b896678d655fbfccac52ddce7714314a59d7bddbb/' feeds/packages/net/zerotier/Makefile

# 克隆 coolsnowwolf 的 luci 和 packages 仓库
# git clone https://github.com/coolsnowwolf/luci.git coolsnowwolf-luci
# git clone https://github.com/coolsnowwolf/packages.git coolsnowwolf-packages

# 替换luci-app-zerotier
# rm -rf feeds/luci/applications/luci-app-zerotier
# cp -r coolsnowwolf-luci/applications/luci-app-zerotier feeds/luci/applications

# 替换zerotier
# rm -rf feeds/packages/net/zerotier
# cp -r coolsnowwolf-packages/net/zerotier feeds/packages/net

# 删除克隆的 coolsnowwolf-luci 和 coolsnowwolf-packages 仓库
# rm -rf coolsnowwolf-luci
# rm -rf coolsnowwolf-packages
