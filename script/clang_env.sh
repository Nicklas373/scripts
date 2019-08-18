#!/bin/bash
#
# Copyright 2019, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
#
# Clarity Kernel Script || CLANG Environment Script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

# Kernel Compiler Path
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=${HOME}/clang/bin
export LD_LIBRARY_PATH=${home}/clang/lib64:$LD_LIBRARY_PATH
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CLANG_TRIPLE_ARM32=arm-maestro-linux-gnueabi-
export CROSS_COMPILE=${HOME}/gcc/bin/aarch64-maestro-linux-gnu-
export CROSS_COMPILE_ARM32=${HOME}/gcc_arm32/bin/arm-maestro-linux-gnueabi-
export KBUILD_BUILD_USER=Yukina
export KBUILD_BUILD_HOST=R_CORE

# Kernel Builder Alias
KERNEL_NAME="Clarity"
KERNEL_SUFFIX="Kernel"
KERNEL_TYPE="EAS"
KERNEL_STATS="signed"
KERNEL_DATE="$(date +%Y%m%d-%H%M)"

# Kernel Directory Path
KERNEL_ANY="${HOME}/AnyKernel3"
KERNEL_TEMP="${HOME}/Clarity-TEMP"
KERNEL_OUT="/mnt/c/Users/acer/Downloads/Clarity-Kernel"
OUT_DIR="out/arch/arm64/boot/Image.gz-dtb"
OUT_ZIP="${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip"
