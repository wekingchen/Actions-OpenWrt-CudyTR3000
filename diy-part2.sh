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
#sed -i 's/192.168.1.1/192.168.88.1/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 移除 openwrt feeds 自带的核心包
rm -rf feeds/packages/net/{xray-core,xray-plugin,v2ray-core,v2ray-plugin,v2ray-geodata,sing-box,hysteria,naiveproxy,shadowsocks-rust,shadow-tls,tuic-client,microsocks,chinadns-ng,dns2socks,ipt2socks}
rm -rf feeds/luci/applications/{luci-app-passwall,luci-app-ssr-plus}
cp -r feeds/passwall_packages/{xray-core,xray-plugin,v2ray-plugin,v2ray-geodata,sing-box,hysteria,naiveproxy,shadowsocks-rust,shadow-tls,tuic-client,microsocks,chinadns-ng,dns2socks,ipt2socks} feeds/packages/net/
cp -r feeds/helloworld/v2ray-core feeds/packages/net/
cp -r feeds/passwall/luci-app-passwall feeds/luci/applications
cp -r feeds/helloworld/luci-app-ssr-plus feeds/luci/applications

# 修改golang源码以编译xray1.8.8+版本
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 25.x feeds/packages/lang/golang

# 修改frp版本为官网最新v0.66.0 https://github.com/fatedier/frp 格式：https://codeload.github.com/fatedier/frp/tar.gz/v${PKG_VERSION}?
rm -rf feeds/packages/net/frp
wget https://github.com/coolsnowwolf/packages/archive/0f7be9fc93d68986c179829d8199824d3183eb60.zip -O OldPackages.zip
unzip OldPackages.zip
cp -r packages-0f7be9fc93d68986c179829d8199824d3183eb60/net/frp feeds/packages/net/
rm -rf OldPackages.zip packages-0f7be9fc93d68986c179829d8199824d3183eb60
sed -i 's/PKG_VERSION:=0.53.2/PKG_VERSION:=0.66.0/' feeds/packages/net/frp/Makefile
sed -i 's/PKG_HASH:=ff2a4f04e7732bc77730304e48f97fdd062be2b142ae34c518ab9b9d7a3b32ec/PKG_HASH:=afe1aca9f6e7680a95652e8acf84aef4a74bcefe558b5b91270876066fff3019/' feeds/packages/net/frp/Makefile

# 升级zerotier到官方最新版本1.14.2
sed -i 's/PKG_VERSION:=1.14.1/PKG_VERSION:=1.14.2/' feeds/packages/net/zerotier/Makefile
sed -i 's/PKG_HASH:=4f9f40b27c5a78389ed3f3216c850921f6298749e5819e9f2edabb2672ce9ca0/PKG_HASH:=c2f64339fccf5148a7af089b896678d655fbfccac52ddce7714314a59d7bddbb/' feeds/packages/net/zerotier/Makefile

# 修正jq源码的APK元数据错误
sed -i '/^[[:space:]]*PROVIDES:=jq[[:space:]]*$/d' feeds/packages/utils/jq/Makefile

# --- Fix nmap ndiff build under Python 3.13 ---
# 1) 在 include python3-package.mk 之后追加 host 端依赖（若未存在）
grep -q 'python3-setuptools/host' feeds/packages/net/nmap/Makefile || \
sed -i '/^include ..\/..\/lang\/python\/python3-package\.mk/a PKG_BUILD_DEPENDS += python3\/host python3-setuptools\/host' feeds/packages/net/nmap/Makefile
# 2) 仅在选中 ndiff 时才执行 Py3Build/Compile
#    如果这一行尚未被包裹，就替换成 ifneq/endif 包裹块（使用 \n 生成新行）
grep -q '^[[:space:]]*\$(call Py3Build/Compile)[[:space:]]*$' feeds/packages/net/nmap/Makefile && \
sed -i 's#^[[:space:]]*\$(call Py3Build/Compile)[[:space:]]*$#ifneq ($(CONFIG_PACKAGE_ndiff),)\n\t$(call Py3Build/Compile)\nendif#' feeds/packages/net/nmap/Makefile
# 3) 仅在选中 ndiff 时才执行 Py3Build/Install（同理）
grep -q '^[[:space:]]*\$(call Py3Build/Install)[[:space:]]*$' feeds/packages/net/nmap/Makefile && \
sed -i 's#^[[:space:]]*\$(call Py3Build/Install)[[:space:]]*$#ifneq ($(CONFIG_PACKAGE_ndiff),)\n\t$(call Py3Build/Install)\nendif#' feeds/packages/net/nmap/Makefile
