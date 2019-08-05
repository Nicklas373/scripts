#!/bin/bash
#
# Copyright 2019, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
#
# Clarity Kernel Builder Script || Telegram Environment Script
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

# Import telegram bot environment
bot_env() {
TELEGRAM_KERNEL_VER=$(cat ~/kernel_xiaomi_msm8953-3.18/out/.config | grep Linux/arm64 | cut -d " " -f3)
TELEGRAM_UTS_VER=$(cat ~/kernel_xiaomi_msm8953-3.18/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TELEGRAM_COMPILER_NAME=$(cat ~/kernel_xiaomi_msm8953-3.18/out/include/generated/compile.h | grep LINUX_COMPILE_BY | cut -d '"' -f2)
TELEGRAM_COMPILER_HOST=$(cat ~/kernel_xiaomi_msm8953-3.18/out/include/generated/compile.h | grep LINUX_COMPILE_HOST | cut -d '"' -f2)
TELEGRAM_TOOLCHAIN_VER=$(cat ~/kernel_xiaomi_msm8953-3.18/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
}

# Telegram Bot Service || Compiling Notification
bot_template() {
~/telegram.sh/telegram -t ${TELEGRAM_BOT_ID} -c ${TELEGRAM_GROUP_ID} -H \
         "$(
            for POST in "${@}"; do
                echo "${POST}"
            done
        )"
}

# Telegram bot message || first notification
bot_first_compile() {
bot_template  "<b>||*HANA-CI Build Bot*||</b>" \
              "" \
              "<b>Clarity Kernel build Start!</b>" \
              "" \
              "<b>Device :</b><code> Xiaomi Redmi Note 4x</code>" \
              "" \
              "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1) </code>"
}

# Telegram bot message || complete compile notification
bot_complete_compile() {
bot_env
bot_template  "<b>New Clarity Kernel build is available!</b>" \
    "" \
    "<b>Device :</b><code> Xiaomi Redmi Note 4x </code>" \
    "" \
    "<b>Filename :</b><code> ${TELEGRAM_FILENAME}</code>" \
    "" \
    "<b>Kernel Version:</b><code> Linux ${TELEGRAM_KERNEL_VER}</code>" \
    "" \
    "<b>Kernel Host:</b><code> ${TELEGRAM_COMPILER_NAME}@${TELEGRAM_COMPILER_HOST}</code>" \
    "" \
    "<b>Kernel Toolchain :</b><code> ${TELEGRAM_TOOLCHAIN_VER}</code>" \
    "" \
    "<b>UTS Version :</b><code> ${TELEGRAM_UTS_VER}</code>" \
    "" \
    "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>"
}

# Telegram bot message || success notification
bot_build_success() {
bot_template "<b>||*HANA-CI Build Bot*||</b>" \
              "" \
              "<b>Clarity Kernel build Success!</b>"
}

# Telegram bot message || failed notification
bot_build_failed() {
bot_template "<b>||*HANA-CI Build Bot*||</b>" \
              "" \
              "<b>Clarity Kernel build Failed!</b>"
}
