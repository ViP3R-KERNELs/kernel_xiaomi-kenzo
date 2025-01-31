#
# Custom build script for Radon kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
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
# Please maintain this if you use this script or any part of it.
#

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Welcome to Radon building program !\n\n ===================================="
echo -e "$gre \n 1.Build radon without qc\n\n 2.Build radon with qc\n"
echo -n " Enter your choice:"
read qc
echo -e "$white"
KERNEL_DIR=$PWD
cd arch/arm/boot/dts/
rm *.dtb > /dev/null 2>&1
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
export ARCH=arm64
export CROSS_COMPILE="/home/cod3x/Android/Kernels/ToolChains/gcc-4.9/bin/aarch64-linux-android-"
echo -e "$yellow Running make clean before compiling \n$white"
make clean > /dev/null
if [ $qc == 2 ]; then
echo -e "$yellow Applying quick charging patch \n $white"
git apply qc.patch
elif [ $qc == 1 ]; then
git apply -R qc.patch > /dev/null 2>&1
fi
make nethunter_defconfig
export LOCALVERSION=-ViP3R🐍-v1.0-NetHunter-kenzo-2k23
export KBUILD_BUILD_HOST="RYZEN"
export KBUILD_BUILD_USER="COD3X"
make -j8
time=$(date +"%d-%m-%y-%T")
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
if ([ $qc -eq 1 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt1.img
elif ([ $qc -eq 2 ]); then
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt2.img
fi
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image1
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ -a $zimage ];
then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip > /dev/null 2>&1
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
zip -r ViP3R🐍-v1.0-NetHunter-kenzo-2k23.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/build/Radon-Kenzo-Cm-Ng.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds, variant($qc) >> \n $white"
fi
cd $KERNEL_DIR
if [ $qc == 2 ]; then
git apply -R qc.patch
fi
