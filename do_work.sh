#!/bin/bash

usage() { 
        echo "Usage: $0 -b /path_to_the_boot_poartition -r /path_to_the_root_partition -x /path_to_xilinx_root"; 
        exit 1; 
}

while getopts "b:r:x:" o; do
    case "${o}" in
        b)
            boot_partition=${OPTARG}
            ;;
        r)
            root_partition=${OPTARG}
            ;;
        x)
            xilinx_root=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${boot_partition}" ] || [ -z "${xilinx_root}" ]; then
    usage
fi

boot_partition=$(realpath $boot_partition)
root_partition=$(realpath $root_partition)
xilinx_root=$(realpath $xilinx_root)
work_dir=$(pwd)

export PATH=$PATH:$xilinx_root/Vitis/2019.2/bin:$xilinx_root/Vitis/2019.2/gnu/microblaze/lin/bin:$xilinx_root/Vitis/2019.2/gnu/arm/lin/bin:$xilinx_root/Vitis/2019.2/gnu/microblaze/linux_toolchain/lin64_le/bin:$xilinx_root/Vitis/2019.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:$xilinx_root/Vitis/2019.2/gnu/aarch32/lin/gcc-arm-none-eabi/bin:$xilinx_root/Vitis/2019.2/gnu/aarch64/lin/aarch64-linux/bin:$xilinx_root/Vitis/2019.2/gnu/aarch64/lin/aarch64-none/bin:$xilinx_root/Vitis/2019.2/gnu/armr5/lin/gcc-arm-none-eabi/bin:$xilinx_root/Vitis/2019.2/tps/lnx64/cmake-3.3.2/bin:$xilinx_root/DocNav:$xilinx_root/Vivado/2019.2/bin:$xilinx_root/Vitis/2019.2/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:$PWD
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

patch u-boot-digilent/include/configs/zynq-common.h < patches/zynq-common.h.patch
make -C u-boot-digilent zynq_zybo_config
make -C u-boot-digilent -j `nproc`
mv u-boot-digilent/u-boot u-boot-digilent/u-boot.elf

xsct tcl/generate_dt.tcl
patch custom_dt/pl.dtsi < patches/pl.dtsi.patch
patch custom_dt/system-top.dts < patches/system-top.dts.patch
gcc -I custom_dt -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o custom_dt/system-top.dts.tmp custom_dt/system-top.dts
dtc -I dts -O dtb -o $boot_partition/devicetree.dtb custom_dt/system-top.dts.tmp

xsct tcl/generate_fsbl.tcl
bootgen -arch zynq -image configs/BOOT.bif -w -o $boot_partition/BOOT.bin -log trace

make -C linux-digilent xilinx_zynq_defconfig
make -C linux-digilent -j `nproc`
make -C linux-digilent UIMAGE_LOADADDR=0x8000 uImage -j `nproc`
cp linux-digilent/arch/arm/boot/uImage $boot_partition

cp configs/buildroot_config buildroot/.config
make -C buildroot -j `nproc`
cd $root_partition
sudo tar xvf $work_dir/buildroot/output/images/rootfs.tar
cd $work_dir
sudo umount $root_partition
sudo umount $boot_partition
