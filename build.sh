#!/bin/bash
#
# Copyright 2019, Dicky Herlambang "Nicklas373" <herlambangdicky5@gmail.com>
#
# Clarity Kernel Builder Script || Main Script
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

# Import Telegram Environment
source "script/telegram.sh"
source "script/telegram_env.sh"

# Main Program
main(){
echo "Which device that you want to compile ?"
echo ""
echo "1. Xiaomi Redmi Note 4x (Mido)"
echo "2. Xiaomi Redmi Note 7  (Lavender)"
echo ""
echo "NOTE: Write codename only :3"
read -s choice
if [ "$choice" == "Mido" ] || [ "$choice" == "mido" ] || [ "$choice" == "1" ]
	then
		# Import device codename
		CODENAME="mido"

		# Import device anykernel branch
		BRANCH="mido"

		# Import git start commit
		COMMIT="7bd238ecd44aad4dda29cc2a327be59316cd1aec"

		# Import separate environment
		KERNEL_SOURCE="${HOME}/kernel_xiaomi_msm8953-3.18"
		KERNEL_CODE="Mido"
		KERNEL_REV="r4"

		# Import additional telegram environment
		TELEGRAM_DEVICE="Xiaomi Redmi Note 4x"

		echo ""
		echo "You're choose Xiaomi Redmi Note 4x (Mido)"
		echo ""
		echo "Which compiler that you want to use?"
		echo "1. GCC 9.1.1 + CLANG (VDSO)"
		echo "2. GCC 9.1.0 Bare Metal (VDSO)"
		echo ""
		echo "NOTE: Write number or use bare metal or clang only :3"
		read -s answer
		if [ "$answer" == "1" ] || [ "$answer" == "clang" ]
			then
				# Import clang environment
				source "script/clang_env.sh"

				echo ""
				echo "Are you want to start clean build?"
				echo "1. Yes"
				echo "2. No"
				echo ""
				echo "NOTE: Write yes/no or number :3"
				read -s clean
				if [ "$clean" == "yes" ] || [ "$clean" == "1" ]
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
						cd ${KERNEL_SOURCE}
						echo ""
						echo "Cleaning done :3"
						echo "Compiling begin..."
						echo ""
				elif [ "$clean" == "no" ] || [ "$clean" == "2" ]
					then
						echo ""
						echo "Cleaning abort :3"
						echo "Compiling begin..."
						echo ""
				else
						echo ""
						echo "Option invalid"
						echo ""
						echo "Return to main menu"
						main
				fi
				# Begin kernel compiling
				make_kernel_clang
				kernel_checking
		elif [ "$answer" == "2" ] || [ "answer" == "bare metal" ]
			then
				# Import bare metal environment
				source "script/gcc_env.sh"

				echo ""
				echo "Are you want to start clean build?"
                		echo "1. Yes"
               			echo "2. No"
				echo ""
                		echo "NOTE: Write yes/no or number only :3"
                		read -s clean
                		if [ "$clean" == "yes" ] || [ "$clean" == "1" ]
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
                        			cd ${KERNEL_SOURCE}
						echo ""
						echo "Cleaning done :3"
						echo "Compiling begin..."
						echo ""
                		elif [ "$clean" == "no" ] || [ "$clean" == "2" ]
					then
						echo ""
						echo "Cleaning abort :3"
						echo "Compiling begin..."
						echo ""
                		else
						echo ""
                        			echo "Option invalid"
						echo "Return to main menu"
						main
				fi
			# Begin kernel compiling
                	make_kernel_gcc
                	kernel_checking
		else
			echo "Option Invalid"
			echo "Return to main menu"
			main
		fi
elif [ "$choice" == "Lavender" ] || [ "$choice" == "lavender" ] || [ "$choice" == "2" ]
	then
		# Import device codename
		CODENAME="lavender-perf"

		# Import device anykernel branch
		BRANCH="lavender"

		# Import git start commit
		COMMIT="2349bedd4fa1d207f3d4b25aaeebf3d36f453d4a"

		# Import separate environment
		KERNEL_SOURCE="${HOME}/kernel_xiaomi_lavender"
		KERNEL_CODE="Lavender"
		KERNEL_REV="r3"

		# Import additional telegram environment
		TELEGRAM_DEVICE="Xiaomi Redmi Note 7"

		echo "You're choose Xiaomi Redmi Note 7 (Lavender)"
		echo ""
		echo "Which compiler that you want to use?"
		echo "1. GCC 9.1.1 + CLANG (VDSO)"
		echo "2. GCC 9.1.0 Bare Metal (VDSO)"
		echo ""
		echo "NOTE: Write number or tell bare metal or clang only :3"
		read -s answer
		if [ "$answer" == "1" ] || [ "$answer" == "clang" ]
			then
				# Import clang environment
				source "script/lavender_clang_env.sh"

				echo ""
				echo "Are you want to start clean build?"
				echo "1. Yes"
				echo "2. No"
				echo ""
				echo "NOTE: Write yes/no or number only :3"
				read -s clean
				if [ "$clean" == "yes" ] || [ "$clean" == "1" ]
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
						cd ${KERNEL_SOURCE}
						echo ""
						echo "Cleaning done :3"
						echo "Compiling begin..."
						echo ""
				elif [ "$clean" == "no" ] || [ "$clean" == "2" ]
					then
						echo ""
						echo "Cleaning abort :3"
						echo "Compiling begin..."
						echo ""
				else
						echo "Option invalid"
						echo "return to main menu"
						main
				fi

				# Begin kernel compiling
				make_kernel_clang
				kernel_checking

		elif [ "$answer" == "2" ] || [ "$answer" == "bare metal" ]
			then
				# Import bare metal environment
				source "script/gcc_env.sh"

				echo ""
				echo "Are you want to start clean build?"
                		echo "1. Yes"
                		echo "2. No"
				echo ""
                		echo "NOTE: Write yes/no or number only :3"
                		read -s clean
                		if [ "$clean" == "yes" ] || [ "$clean" == "1" ]
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
                        			cd ${KERNEL_SOURCE}
						echo ""
						echo "Cleaning done :3"
						echo "Compiling begin"
						echo ""
                		elif [ "$clean" == "no" ] || [ "$clean" == "2" ]
				then
						echo ""
						echo "Cleaning abort :3"
						echo "Compiling begin..."
						echo ""
                		else
						echo ""
                        			echo "Option invalid"
						echo "Return to main menu"
						main
				fi
			# Begin kernel compiling
                	make_kernel_gcc
                	kernel_checking
		else
			echo "Option Invalid"
			echo "Return to main menu"
			main
		fi
fi
}

# Kernel Compile with Clang
make_kernel_clang() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out ${CODENAME}_defconfig
		make O=out ARCH=${ARCH} CC=clang \
			   CLANG_TRIPLE=${CLANG_TRIPLE} \
			   CLANG_TRIPLE_ARM32=${CLANG_TRIPLE_ARM32} \
			   CROSS_COMPILE=${CROSS_COMPILE} \
			   CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} \
			   -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${KERNEL_SOURCE}/kernel_time.log
}

# Kernel Compile with Bare Metal
make_kernel_gcc() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out ${CODENAME}_defconfig
		make O=out ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} \
		CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${KERNEL_SOURCE}/kernel_time.log
}

# AnyKernel Build
build_kernel(){
		mv ${OUT_DIR} ${KERNEL_ANY}
		cd ${KERNEL_ANY}
		git checkout ${BRANCH}
		make -j4
}

# Clarity Export
export_kernel(){
		rm ${KERNEL_ANY}/Image.gz-dtb
		mv ~/Clarity-Kernel-${KERNEL_CODE}-signed.zip ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip
}

# Kernel Checking
kernel_checking(){
echo "Checking kernel..."

# Extra Telegram Path
TELEGRAM_FILENAME="${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip"

if [ -f "$OUT_DIR" ]
then
	echo "Kernel found"
	echo "Continue to build kernel"
	build_kernel
	bot_build_success
	export_kernel
	kernel_upload
else
	echo "Kernel not found"
	echo "Cancel kernel to build"
	bot_build_failed
	cd ${KERNEL_SOURCE}
	end=$(date +%s)
	seconds=$(echo "$end - $start" | bc)
	awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
	awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${KERNEL_SOURCE}/kernel_time.log
fi
}

kernel_upload(){
        if [ -f "$OUT_ZIP" ]
        then
		cd ${KERNEL_SOURCE}
		bot_complete_compile
        	~/telegram.sh/telegram -t ${TELEGRAM_BOT_ID} -c ${TELEGRAM_GROUP_ID} -f ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip
        	cd ${KERNEL_SOURCE}
		git --no-pager log --pretty=format:"%h - %s (%an)" --abbrev-commit ${COMMIT}..HEAD > ${KERNEL_TEMP}/changelog.txt
        	~/telegram.sh/telegram -t ${TELEGRAM_BOT_ID} -c ${TELEGRAM_GROUP_ID} -f  ${KERNEL_TEMP}/changelog.txt
       		mv ${KERNEL_TEMP}/*.zip ${KERNEL_OUT}
        	mv ${KERNEL_TEMP}/changelog.txt ${KERNEL_OUT}
        fi
}

# Main Program
main
