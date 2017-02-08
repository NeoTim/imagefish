#!/bin/sh

name="fedora-25-rpi3"
repo="repos/fedora-25.repo"
rpms="bcm283x-firmware uboot-images-armv8 extlinux-bootloader dracut-config-generic"
krnl="kernel kernel-modules"

arch="$(uname -m)"
tar="${name}-${arch}.tar.gz"
img="${name}-${arch}.raw"
set -ex
rm -f "$tar" "$img"
scripts/install-redhat.sh --config "$repo" --tar "$tar" --packages "$rpms" --kernel "$krnl" --dnf 
scripts/tar-to-image.sh --tar "$tar" --image "$img" --rpi64