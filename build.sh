#!bin/bash
#
# Copyright 2019, Najahiiii <najahiii@outlook.co.id>
# Copyright 2019, alanndz <alanmahmud0@gmail.com>
# Copyright 2019, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
# Copyright 2016-2019, HANA-CI
# Build Project
#
# Clarity Kernel Builder Script || Main Script
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#

# Export telegram separate environment
source "${HOME}/hana/telegram_env.sh"

# Import telegram bot environment
function bot_env() {
TELEGRAM_KERNEL_VER=$(cat ${KERNEL}/out/.config | grep Linux/arm64 | cut -d " " -f3)
TELEGRAM_UTS_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep UTS_VERSION | cut -d '"' -f2)
TELEGRAM_COMPILER_NAME=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_BY | cut -d '"' -f2)
TELEGRAM_COMPILER_HOST=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILE_HOST | cut -d '"' -f2)
TELEGRAM_TOOLCHAIN_VER=$(cat ${KERNEL}/out/include/generated/compile.h | grep LINUX_COMPILER | cut -d '"' -f2)
}

# Telegram Bot Service || Compiling Notification
function bot_template() {
curl -s -X POST https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendMessage -d chat_id=${TELEGRAM_GROUP_ID} -d "parse_mode=HTML" -d text="$(
            for POST in "${@}"; do
                echo "${POST}"
            done
          )"
}

# Telegram bot message || first notification
function bot_first_compile() {
bot_template "<b>|| HANA-CI Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Start!</b>" \
	      "" \
	      "<b>Build Status :</b><code> ${KERNEL_RELEASE} </code>" \
              "" \
              "<b>Device :</b><code> ${TELEGRAM_DEVICE} </code>" \
              "" \
	      "<b>Android Version :</b><code> ${KERNEL_ANDROID_VER} </code>" \
	      "" \
	      "<b>Kernel Scheduler :</b><code> ${KERNEL_SCHED} </code>" \
	      "" \
              "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1) </code>"
}

# Telegram bot message || complete compile notification
function bot_complete_compile() {
bot_env
bot_template "<b>|| HANA-CI Build Bot ||</b>" \
    "" \
    "<b>New ${KERNEL_NAME} Kernel Build Is Available!</b>" \
    "" \
    "<b>Build Status :</b><code> ${KERNEL_RELEASE} </code>" \
    "" \
    "<b>Device :</b><code> ${TELEGRAM_DEVICE} </code>" \
    "" \
    "<b>Android Version :</b><code> ${KERNEL_ANDROID_VER} </code>" \
    "" \
    "<b>Kernel Scheduler :</b><code> ${KERNEL_SCHED} </code>" \
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
    "<b>Latest commit :</b><code> $(git --no-pager log --pretty=format:'"%h - %s (%an)"' -1)</code>" \
    "" \
    "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>" \
    "" \
    "<b>                  HANA-CI Build Project | 2016-2019                     </b>"
}

# Telegram bot message || success notification
function bot_build_success() {
bot_template "<b>|| HANA-CI Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Success!</b>"
}

# Telegram bot message || failed notification
function bot_build_failed() {
bot_template "<b>|| HANA-CI Build Bot ||</b>" \
              "" \
	      "<b>${KERNEL_NAME} Kernel build Failed!</b>" \
              "" \
              "<b>Compile Time :</b><code> $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) second(s)</code>"
}

# Telegram sticker message
function sendStick() {
	curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_ID/sendSticker -d sticker="${1}" -d chat_id=$TELEGRAM_GROUP_ID &>/dev/null
}

# Main Program
main(){
echo "Which device that you want to compile ?"
echo ""
echo "1. Xiaomi Redmi Note 4x (Mido)"
echo "2. Xiaomi Redmi Note 7 (Lavender)"
echo ""
echo "NOTE: Write codename only!"
read codename
echo ""

echo "Compiler that you want to use compile ?"
echo ""
echo "1. Clang 10.0.0"
echo "2. Clang 10.0.3"
echo ""
echo "NOTE: Write number only!"
read compiler
echo ""

if [ "$codename" == "Mido" ] || [ "$codename" == "mido" ] || [ "$codename" == "1" ]
	then
		# Define ARCH
		export ARCH=arm64

	if [ "$compiler" == "1" ]
		then
			# Define Clang path
			export LD_LIBRARY_PATH="${HOME}/clang-10/bin/../lib:$PATH"
	elif [ "$compiler" == "2" ]
		then
			# Define Clang path
			export CLANG_PATH=${HOME}/hana/clang/bin
			export PATH=${CLANG_PATH}:${PATH}
			export CLANG_TRIPLE=aarch64-linux-gnu-
			export CROSS_COMPILE=${HOME}/hana/gcc/bin/aarch64-linux-gnu-
			export CROSS_COMPILE_ARM32=${HOME}/hana/gcc_arm32/bin/arm-linux-gnueabi-
	fi

		# Define Kernel Environment
		export KBUILD_BUILD_USER=Kasumi
		IMAGE="${HOME}/hana/mido/out/arch/arm64/boot/Image.gz-dtb"
		KERNEL="${HOME}/hana/mido"
		KERNEL_TEMP="${HOME}/hana/TEMP"
		CODENAME="mido"
		KERNEL_CODE="Mido"
		KERNEL_SUFFIX="Kernel"
		KERNEL_DATE="$(date +%Y%m%d-%H%M)"
		TELEGRAM_BOT_ID=${TELEGRAM_BOT_ID}
		export TELEGRAM_SUCCESS="CAADBQADhQcAAhIzkhBQ0UsCTcSAWxYE"
		export TELEGRAM_FAIL="CAADBQADfgcAAhIzkhBSDI8P9doS7BYE"
		TELEGRAM_DEVICE="Xiaomi Redmi Note 4x"

		# Define Kernel Name
		echo "Which kernel that you want to compile ?"
		echo ""
		echo "1. CAF Kernel (HMP)"
		echo "2. Clarity Kernel (EAS)"
		echo "3. Clarity Kernel (EAS UC)"
		echo ""
		echo "NOTE: Write number only!"
		read kernel_name
		echo ""

		# Define Android Version
		echo "Which android version for this kernel ?"
		echo ""
		echo "1. 9"
		echo "2. 10"
		echo "3. 9 - 10"
		echo ""
		echo "NOTE: Write number only!"
		read kernel_ver
		echo ""

		if [ "$kernel_ver" == "1" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="9"
				KERNEL_TAG="P"
		elif [ "$kernel_ver" == "2" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="10"
				KERNEL_TAG="Q"
		elif [ "$kernel_ver" == "3" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="9-10"
				KERNEL_TAG="P-Q"
		fi

		# Define Kernel Status
		echo "Which build status for this kernel?"
		echo ""
		echo "1. Stable"
		echo "2. BETA"
		echo ""
		echo "NOTE: Write number only!"
		read kernel_stat
		echo ""

		if [ "$kernel_stat" == "1" ]
			then
				# Extend Environment
				KERNEL_RELEASE="Stable"
				TELEGRAM_GROUP_ID=${TELEGRAM_GROUP_OFFICIAL_ID}

				# Define Kernel Name
				sed -i -e 's/-戸山-Kernel-r16-LA.UM.8.6.r1-02900-89xx.0/-友希那-Kernel-r16-LA.UM.8.6.r1-02900-89xx.0/g'  ${KERNEL}/arch/arm64/configs/mido_defconfig
		elif [ "$kernel_stat" == "2" ]
			then
				# Extend Environment
				KERNEL_RELEASE="BETA"
				TELEGRAM_GROUP_ID=${TELEGRAM_GROUP_BETA_ID}

				# Define Kernel Name
				sed -i -e 's/-友希那-Kernel-r16-LA.UM.8.6.r1-02900-89xx.0/-戸山-Kernel-r16-LA.UM.8.6.r1-02900-89xx.0/g'  ${KERNEL}/arch/arm64/configs/mido_defconfig
		fi

		# Begin Script
		if [ "$kernel_name" == "1" ]
			then
				# Define Kernel Environment
				KERNEL_SCHED="HMP"
				KERNEL_REV="r9"
				KERNEL_NAME="CAF"

				# Define Specific Telegram Filename
				TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"

				# Switch to CAF Branch
                                cd ${HOME}/hana/mido
                                git checkout pie
                                cd ${HOME}/hana/AnyKernel3

		# Use proper anykernel branch for android 10
		if [ "$kernel_ver" == "1" ]
			then
				git checkout caf/mido
		else
				git checkout mido-10
		fi
				cd ${HOME}/hana

				# Import git start commit
				COMMIT="1db74c045cad77d37578b457e11f7637e749fb84"

				# Define Build Type
				echo "Is this clean or dirty build ?"
				echo ""
				echo "1. Clean"
				echo "2. Dirty"
				echo ""
				echo "NOTE: Write number only!"
				read build_type
				echo ""
				if [ "$build_type" == "1" ]
					then
						cd ${KERNEL}/out
						make clean && make mrproper
						cd ${HOME}/hana
				elif [ "$build_type" == "2" ]
					then
						echo "Upss dirty dude :v"
				fi

				# Compile time
				compile
		elif [ "$kernel_name" == "2" ]
			then
				# Define Kernel Environment
				KERNEL_SCHED="EAS"
				KERNEL_REV="r16"
				KERNEL_NAME="Clarity"

				# Define Specific Telegram Filename
				TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"

				# Switch to Clarity Branch
                                cd ${HOME}/hana/mido
				cd ${KERNEL}
				git checkout dev/kasumi
				if [ "$kernel_ver" == 2 ]
					then
						cd ${HOME}/hana/AnyKernel3
						git checkout mido-10
				elif [ "$kernel_ver" == 1 ]
					then
						cd ${HOME}/hana/AnyKernel3
						git checkout mido
				fi
                                cd ${HOME}/hana

				# Import git start commit
				COMMIT="a9d0ad1a044f2adee63dfb1d1d56366ad4d246b2"

				# Define Build Type
				echo "Is this clean or dirty build ?"
				echo ""
				echo "1. Clean"
				echo "2. Dirty"
				echo ""
				echo "NOTE: Write number only!"
				read build_type
				echo ""
				if [ "$build_type" == "1" ]
					then
						cd ${KERNEL}/out
						make clean && make mrproper
						cd ${HOME}/hana
				elif [ "$build_type" == "2" ]
					then
						echo "Upss dirty dude :v"
				fi

				# Compile time
				compile
		elif [ "$kernel_name" == "3" ]
			then
				# Define Kernel Environment
				KERNEL_SCHED="EAS-UC"
				KERNEL_REV="r15"
				KERNEL_NAME="Clarity"

				# Define Specific Telegram Filename
				TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"

				# Switch to Clarity-UC Branch
                                cd ${HOME}/hana/mido
                                git checkout dev/kasumi-uc
				if [ "$kernel_ver" == 1 ]
					then
						cd ${HOME}/hana/AnyKernel3
						git checkout mido
				elif [ "$kernel_ver" == 2 ]
					then
						cd ${HOME}/hana/AnyKernel3
						git checkout mido-10
				fi
                                cd ${HOME}/hana

				# Import git start commit
				COMMIT="faf1e5b5d6c0905b360950e6990c6be581f65c2d"

				# Define Build Type
				echo "Is this clean or dirty build ?"
				echo ""
				echo "1. Clean"
				echo "2. Dirty"
				echo ""
				echo "NOTE: Write number only!"
				read build_type
				echo ""
				if [ "$build_type" == "1" ]
					then
						cd ${KERNEL}/out
						make clean && make mrproper
						cd ${HOME}/hana
				elif [ "$build_type" == "2" ]
					then
						echo "Upss dirty dude :v"
				fi

				# Compile time
				compile
		fi
elif [ "$codename" == "Lavender" ] || [ "$codename" == "lavender" ] || [ "$codename" == "2" ]
	then
		# Define ARCH
		export ARCH=arm64

	if [ "$compiler" == "1" ]
		then
			# Define Clang path
			export LD_LIBRARY_PATH="${HOME}/clang-10/bin/../lib:$PATH"
	elif [ "$compiler" == "2" ]
		then
			# Define Clang path
			export CLANG_PATH=${HOME}/hana/clang/bin
			export PATH=${CLANG_PATH}:${PATH}
			export CLANG_TRIPLE=aarch64-linux-gnu-
			export CROSS_COMPILE=${HOME}/hana/gcc/bin/aarch64-linux-gnu-
			export CROSS_COMPILE_ARM32=${HOME}/hana/gcc_arm32/bin/arm-linux-gnueabi-
	fi

		# Define Kernel Environment}
		export KBUILD_BUILD_USER=Kasumi
		IMAGE="${HOME}/hana/lavender/out/arch/arm64/boot/Image.gz"
		DTB="${HOME}/hana/lavender/out/arch/arm64/boot/dts/qcom"
		KERNEL="${HOME}/hana/lavender"
		KERNEL_TEMP="${HOME}/hana/TEMP"
		CODENAME="lavender"
		KERNEL_CODE="Lavender"
		KERNEL_SUFFIX="Kernel"
		KERNEL_DATE="$(date +%Y%m%d-%H%M)"
		TELEGRAM_BOT_ID=${TELEGRAM_BOT_ID}
		export TELEGRAM_SUCCESS="CAADBQADhQcAAhIzkhBQ0UsCTcSAWxYE"
		export TELEGRAM_FAIL="CAADBQADfgcAAhIzkhBSDI8P9doS7BYE"
		TELEGRAM_DEVICE="Xiaomi Redmi Note 7"

		# Define Android Version
		echo "Which android version for this kernel ?"
		echo ""
		echo "1. 9"
		echo "2. 10"
		echo "3. 9 - 10"
		echo ""
		echo "NOTE: Write number only!"
		read -s kernel_ver
		if [ "$kernel_ver" == "1" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="9"
				KERNEL_TAG="P"
		elif [ "$kernel_ver" == "2" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="10"
				KERNEL_TAG="Q"
		elif [ "$kernel_ver" == "3" ]
			then
				# Extend Environment
				KERNEL_ANDROID_VER="9-10"
				KERNEL_TAG="P-Q"
		fi

		# Define Kernel Status
		echo "Which build status for this kernel?"
		echo ""
		echo "1. Stable"
		echo "2. BETA"
		echo ""
		echo "NOTE: Write number only!"
		read kernel_stat
		echo ""

		if [ "$kernel_stat" == "1" ]
			then
				# Extend Environment
				KERNEL_RELEASE="Stable"
				TELEGRAM_GROUP_ID=${TELEGRAM_GROUP_OFFICIAL_ID}

				# Define Kernel Name
				sed -i -e 's/-戸山-Kernel-r12-LA.UM.8.2.r1-05100-sdm660.0/-友希那-Kernel-r12-LA.UM.8.2.r1-05100-sdm660.0/g' ${KERNEL}/arch/arm64/configs/lavender_defconfig
		elif [ "$kernel_stat" == "2" ]
			then
				# Extend Environment
				KERNEL_RELEASE="BETA"
				TELEGRAM_GROUP_ID=${TELEGRAM_GROUP_BETA_ID}

				# Define Kernel Name
				sed -i -e 's/-友希那-Kernel-r12-LA.UM.8.2.r1-05100-sdm660.0/-戸山-Kernel-r12-LA.UM.8.2.r1-05100-sdm660.0/g' ${KERNEL}/arch/arm64/configs/lavender_defconfig
		fi

		# Define Kernel Environment
		KERNEL_SCHED="EAS"
		KERNEL_REV="r12"
		KERNEL_NAME="Clarity"

		# Define Specific Telegram Filename
		TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip"

		# Switch to Clarity Branch
		cd ${HOME}/hana/lavender
                git checkout dev/kasumi-eas
		cd ${HOME}/hana/AnyKernel3
                git checkout lavender
                cd ${HOME}/hana

		# Import git start commit
		COMMIT="5ebac1edd704c0d35abdf2b2be1d871cdc0ebcac"

		# Define Build Type
		echo "Is this clean or dirty build ?"
		echo ""
		echo "1. Clean"
		echo "2. Dirty"
		echo ""
		echo "NOTE: Write number only!"
		read build_type
		echo ""
		if [ "$build_type" == "1" ]
			then
				cd ${KERNEL}/out
				make clean && make mrproper
				cd ${HOME}/hana
		elif [ "$build_type" == "2" ]
			then
				echo "Upss dirty dude :v"
		fi

		# Compile time
		compile
fi
}

# Compile
function compile() {
	cd ${KERNEL}
	rm ${IMAGE}
	rm compile.log
	rm ${KERNEL_TEMP}/*.zip
	rm ${KERNEL_TEMP}/*.log
	bot_first_compile
	cd ${HOME}/hana
	START=$(date +"%s")
	make -C ${KERNEL} ${CODENAME}_defconfig O=out
	PATH="${HOME}/clang-10/bin/:${PATH}" \
	make -C ${KERNEL} -j$(nproc --all) -> ${KERNEL}/compile.log O=out \
							CC=clang \
							CLANG_TRIPLE=aarch64-linux-gnu- \
							CROSS_COMPILE=aarch64-linux-gnu- \
							CROSS_COMPILE_ARM32=arm-linux-gnueabi-
	if ! [ -a $IMAGE ];
		then
			echo "kernel not found"
			END=$(date +"%s")
			DIFF=$(($END - $START))
			cd ${KERNEL}
			bot_build_failed
			cd ..
			sendStick "${TELEGRAM_FAIL}"
			exit 1
	fi
	END=$(date +"%s")
	DIFF=$(($END - $START))
	cp ${KERNEL}/compile.log ${KERNEL_TEMP}
	cd ${KERNEL}
	bot_build_success
	cd ..
	# Cleanup dtb and kernel old image before push
	rm AnyKernel3/Image.gz-dtb
	rm AnyKernel3/dtbs/*.dtb
	rm AnyKernel3/kernel/Image.gz
	sendStick "${TELEGRAM_SUCCESS}"
	if [ "$codename" == "Mido" ] || [ "$codename" == "mido" ] || [ "$codename" == "1" ];
		then
			cp ${IMAGE} AnyKernel3/Image.gz-dtb
	elif [ "$codename" == "Lavender" ] || [ "$codename" == "lavender" ] || [ "$codename" == "2" ];
		then
			cp ${IMAGE} AnyKernel3/kernel
			cp ${DTB}/*.dtb AnyKernel3/dtbs
	fi
	anykernel
	kernel_upload
}

# AnyKernel
function anykernel() {
	cd ${HOME}/hana/AnyKernel3
	make -j4
	mv Clarity-Kernel-${KERNEL_CODE}-signed.zip ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip
}

# Upload Kernel
function kernel_upload(){
	cd ${KERNEL}
	bot_complete_compile
	git --no-pager log --pretty=format:"%h - %s (%an)" --abbrev-commit ${COMMIT}..HEAD > ${KERNEL_TEMP}/git.log
	cd ${KERNEL_TEMP}
	curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_SCHED}-${KERNEL_TAG}-${KERNEL_DATE}.zip" https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
	curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/git.log" https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
	curl -F chat_id=${TELEGRAM_GROUP_ID} -F document="@${KERNEL_TEMP}/compile.log"  https://api.telegram.org/bot${TELEGRAM_BOT_ID}/sendDocument
}

# Main Program
main
