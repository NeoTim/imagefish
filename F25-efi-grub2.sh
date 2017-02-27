#!/bin/sh

name="fedora-25-efi-grub2"
repo="repos/fedora-25.repo"
rpms="grub2-efi shim -dracut-config-rescue"

arch="$(uname -m)"
tar="${name}-${arch}.tar.gz"
img="${name}-${arch}.qcow2"

echo ""
echo "###"
echo "### $name"
echo "###"

set -ex
rm -f "$tar" "$img"
scripts/install-redhat.sh --config "$repo" --tar "$tar" --packages "$rpms" --dnf
scripts/tar-to-image.sh --tar "$tar" --image "$img" --efi-grub2
