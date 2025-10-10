#!/bin/bash
# Apache Build Environment Pre-check Script
# Author: https://ko-o.tistory.com/
# Date: 2025.09.24

echo -e "\033c"
echo "######################################################"
echo "#   Apache Build Environment Check          @BLOG_KIOR"
echo "######################################################"

# Essential build tools
BUILD_TOOLS=("gcc" "make" "perl" "tar")
# Essential development libraries
DEV_PKGS=("expat-devel" "zlib-devel")

###############################################################
###############################################################

echo -e "\n[INFO] Checking build tools"
for tool in "${BUILD_TOOLS[@]}"; do
    if command -v $tool >/dev/null 2>&1; then
        echo "  ✔ $tool: installed ($(command -v $tool))"
    else
        echo "  ✘ $tool: not installed"
    fi
done

echo -e "\n[INFO] Checking development library packages"
for pkg in "${DEV_PKGS[@]}"; do
    if rpm -q $pkg >/dev/null 2>&1; then
        echo "  ✔ $pkg: installed"
    else
        echo "  ✘ $pkg: not installed"
    fi
done

###############################################################
###############################################################

echo -e "\n[Done] Apache build environment check completed.\n"
