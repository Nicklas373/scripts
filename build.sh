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

# Main Program
main(){
echo "Which device that you want to compile ?"
echo "1. Xiaomi Redmi Note 4x (Mido)"
echo "2. Xiaomi Redmi Note 7  (Lavender)"
echo "NOTE: Write codename only!!!"
read choice
if [ "$choice" == "Mido" ];
	then
		echo "You're choose Xiaomi Redmi Note 4x (Mido)"
		echo "Which compiler that you want to use?"
		echo "1. GCC 9.1.1 + CLANG (VDSO)"
		echo "2. GCC 9.1.0 Bare Metal (VDSO)"
		echo "NOTE: Write number only!!!"
		read answer
		if [ "$answer" == "1" ];
			then
				# Import clang environment
				source "script/mido_clang_env.sh"

				echo "Are you want to start clean build?"
				echo "1. Yes"
				echo "2. No"
				echo "NOTE: Write yes/no only!!!"
				read clean
				if [ "$clean" == "yes" ];
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
						cd ${KERNEL_SOURCE}
						echo "Cleaning done :3"
				fi
				if [ "$clean" == "no" ];
					then
						echo "Cleaning abort :3"
				else
						echo "Option invalid!!!"
				fi

				# Begin kernel compiling
				make_kernel_mido_clang
				kernel_checking_mido
		fi
		if [ "$answer" == "2" ];
			then
				# Import bare metal environment
				source "script/mido_gcc_env.sh"

				echo "Are you want to start clean build?"
                		echo "1. Yes"
               			echo "2. No"
                		echo "NOTE: Write yes/no only!!!"
                		read clean
                		if [ "$clean" == "yes" ];
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
                        			cd ${KERNEL_SOURCE}
						echo "Cleaning done :3"
				fi
                		if [ "$clean" == "no" ];
					then
						echo "Cleaning abort :3"
                		else
                        			echo "Option invalid!!!"
				fi
			# Begin kernel compiling
                	make_kernel_mido_gcc
                	kernel_checking_mido
		else
			echo "Option Invalid"
			echo "Return to main menu"
			main
		fi
fi
if [ "$choice" == "Lavender" ];
	then
		echo "You're choose Xiaomi Redmi Note 7 (Lavender)"
		echo "Which compiler that you want to use?"
		echo "1. GCC 9.1.1 + CLANG (VDSO)"
		echo "2. GCC 9.1.0 Bare Metal (VDSO)"
		echo "NOTE: Write number only!!!"
		read answer
		if [ "$answer" == "1" ];
			then
				# Import clang environment
				source "script/lavender_clang_env.sh"

				echo "Are you want to start clean build?"
				echo "1. Yes"
				echo "2. No"
				echo "NOTE: Write yes/no only!!!"
				read clean
				if [ "$clean" == "yes" ];
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
						cd ${KERNEL_SOURCE}
						echo "Cleaning done :3"
				fi
				if [ "$clean" == "no" ];
					then
						echo "Cleaning abort :3"
				else
						echo "Option invalid!!!"
				fi

				# Begin kernel compiling
				make_kernel_lavender_clang
				kernel_checking_lavender
		fi
		if [ "$answer" == "2" ];
			then
				# Import bare metal environment
				source "script/lavender_gcc_env.sh"

				echo "Are you want to start clean build?"
                		echo "1. Yes"
                		echo "2. No"
                		echo "NOTE: Write yes/no only!!!"
                		read clean
                		if [ "$clean" == "yes" ];
					then
						cd ${KERNEL_SOURCE}/out
						make clean && make mrproper
                        			cd ${KERNEL_SOURCE}
						echo "Cleaning done :3"
				fi
                		if [ "$clean" == "no" ];
				then
						echo "Cleaning abort :3"
                		else
                        			echo "Option invalid!!!"
				fi
			# Begin kernel compiling
                	make_kernel_lavender_gcc
                	kernel_checking_lavender
		else
			echo "Option Invalid"
			echo "Return to main menu"
			main
		fi
fi
}

# Kernel Compile Mido with Clang
make_kernel_mido_clang() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out mido_defconfig
		make O=out ARCH=${ARCH} CC=clang \
			   CLANG_TRIPLE=${CLANG_TRIPLE} \
			   CLANG_TRIPLE_ARM32=${CLANG_TRIPLE_ARM32} \
			   CROSS_COMPILE=${CROSS_COMPILE} \
			   CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} \
			   -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${CHEWY}/kernel_time.log
}

# Kernel Compile Mido with Bare Metal
make_kernel_mido_gcc() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out mido_defconfig
		make O=out ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} \
		CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${CHEWY}/kernel_time.log
}


# Kernel Compile Lavender with Clang
make_kernel_lavender_clang() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out lavender-perf_defconfig
		make O=out ARCH=${ARCH} CC=clang \
			   CLANG_TRIPLE=${CLANG_TRIPLE} \
			   CLANG_TRIPLE_ARM32=${CLANG_TRIPLE_ARM32} \
			   CROSS_COMPILE=${CROSS_COMPILE} \
			   CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} \
			   -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${CHEWY}/kernel_time.log
}

# Kernel Compile Lavender with Bare Metal
make_kernel_lavender_gcc() {
		cd ${KERNEL_SOURCE}
		start=$(date +%s)
		bot_first_compile
		make O=out lavender-perf_defconfig
		make O=out ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} \
		CROSS_COMPILE_ARM32=${CROSS_COMPILE_ARM32} -j$(nproc --all) -> ${KERNEL_SOURCE}/compile.log
		end=$(date +%s)
		seconds=$(echo "$end - $start" | bc)
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
		awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${CHEWY}/kernel_time.log
}

# Kernel Build Mido
build_kernel_mido(){
		mv ${OUT_DIR} ${KERNEL_ANY}
		cd ${KERNEL_ANY}
		git checkout mido
		make -j4
}

# Kernel Build Lavender
build_kernel_lavender(){
		mv ${OUT_DIR} ${KERNEL_ANY}
		cd ${KERNEL_ANY}
		git checkout lavender
		make -j4
}

# Clean Build Mido
clean_kernel_mido(){
		rm ${KERNEL_ANY}/Image.gz-dtb
		mv ~/Clarity-Kernel-Mido-v1.0-signed.zip ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip
}

# Clean Build Lavender
clean_kernel_lavender(){
		rm ${KERNEL_ANY}/Image.gz-dtb
		mv ~/Clarity-Kernel-Lavender-r2-signed.zip ${KERNEL_TEMP}/${KERNEL_NAME}-${KERNEL_SUFFIX}-${KERNEL_CODE}-${KERNEL_REV}-${KERNEL_TYPE}-${KERNEL_STATS}-${KERNEL_DATE}.zip
}

# Kernel Checking Mido
kernel_checking_mido(){
echo "Checking kernel..."
if [ -f "$OUT_DIR" ]
then
	echo "Kernel found"
	echo "Continue to build kernel"
	build_kernel_mido
	bot_build_success
	clean_kernel_mido
	kernel_upload
else
	echo "Kernel not found"
	echo "Cancel kernel to build"
	bot_build_failed
	cd ${KERNEL_SOURCE}
	clean_kernel_mido
	end=$(date +%s)
	seconds=$(echo "$end - $start" | bc)
	awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "##################################\n# Kernel Compiling Time: %d:%02d:%02d#\n##################################\n", t/3600000, t/60000%60, t/1000%60}'
	awk -v t=$seconds 'BEGIN{t=int(t*1000); printf "Kernel Compiling Time: %d:%02d:%02d\n", t/3600000, t/60000%60, t/1000%60}' -> ${KERNEL_SOURCE}/kernel_time.log
fi
}

# Kernel Checking Lavender
kernel_checking_lavender(){
echo "Checking kernel..."
if [ -f "$OUT_DIR" ]
then
	echo "Kernel found"
	echo "Continue to build kernel"
	build_kernel_lavender
	bot_build_success
	clean_kernel_lavender
	kernel_upload
else
	echo "Kernel not found"
	echo "Cancel kernel to build"
	bot_build_failed
	cd ${KERNEL_SOURCE}
	clean_kernel_lavender
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
		git --no-pager log --pretty=format:"%h - %s (%an)" --abbrev-commit 0ef79a4019bc6fd7cf94b659fdae73e501fe039b..HEAD > ${KERNEL_TEMP}/changelog.txt
        ~/telegram.sh/telegram -t ${TELEGRAM_BOT_ID} -c ${TELEGRAM_GROUP_ID} -f  ${KERNEL_TEMP}/changelog.txt
        mv ${KERNEL_TEMP}/*.zip ${KERNEL_OUT}
        mv ${KERNEL_TEMP}/changelog.txt ${KERNEL_OUT}
        fi
}

# Main Program
main
