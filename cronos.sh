#!/bin/bash
# Cronos script for mehmet
# Coded by Ananjaser1211
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Kernel Variables
CR_VERSION=V1.0
CR_DATE=$(date +%Y%m%d)
# Linaro : https://releases.linaro.org/components/toolchain/binaries/latest-4/arm-linux-gnueabi/
CR_TC=/home/aj1211/Android/Toolchains/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabi/bin/arm-linux-gnueabi-
CR_DIR=$(pwd)
CR_OUT=$CR_DIR/Helios/out
CR_JOBS=5
CR_AIK=$CR_DIR/Helios/AIK-Linux
CR_RAMDISK=$CR_DIR/Helios/Ramdisk
CR_KERNEL=$CR_DIR/arch/arm/boot/zImage
CR_CONFG=mehmet_defconfig
CR_VARIANT=fatihVE_
CR_ANDROID=4.4.2
CR_ARCH=arm

#Init
export $CR_ARCH
export CROSS_COMPILE=$CR_TC
# Write config before cleaning so alps driver doesnt fail
make $CR_CONFG
#export ANDROID_MAJOR_VERSION=$CR_ANDROID
echo "----------------------------------------------"
echo "Preparing"
echo " "
read -p "Clean source (y/n) > " yn
if [ "$yn" = "Y" -o "$yn" = "y" ]; then
     echo "Clean Build"    
     make clean && make mrproper       
else
     echo "Dirty Build"       
fi
# rm -r -f $CR_OUT/*
echo " "
echo "----------------------------------------------"
echo "Building zImage for $CR_VARIANT"
echo " "
export LOCALVERSION=-Helios_Kernel-$CR_VERSION-$CR_VARIANT-$CR_DATE
make  $CR_CONFG
make -j$CR_JOBS
echo " "
echo "----------------------------------------------"
echo "Building Boot.img for $CR_VARIANT"
echo " "
cp -rf $CR_RAMDISK/* $CR_AIK
mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
#mv $CR_DTB $CR_AIK/split_img/boot.img-dtb
$CR_AIK/repackimg.sh
mv $CR_AIK/image-new.img $CR_OUT/Helios-$CR_VARIANT-$CR_VERSION-$CR_DATE.img
$CR_AIK/cleanup.sh
echo "----------------------------------------------"
echo "$CR_VARIANT Ready at $CR_OUT"
echo " "
