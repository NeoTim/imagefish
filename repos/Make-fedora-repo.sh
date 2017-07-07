#!/bin/sh

# config
mirror="http://spunk.home.kraxel.org/mirror/fedora/rsync"
armv7="http://spunk.home.kraxel.org/mockify/repos/rpi2/"
armv8="http://spunk.home.kraxel.org/mockify/repos/qcom/"

basepri="http://ftp.halifax.rwth-aachen.de/fedora/linux"
basesec="http://ftp-stud.hs-esslingen.de/pub/fedora-secondary"
proxy="http://spunk.home.kraxel.org:3128"

################################################################################

function makerepo() {
	local basearch="$1"
	local releasever="$2"
	local devel="$3"
	local release=$(( 1 - $devel ))
	local kraxel=""

	case "$basearch" in
	aarch64)	base="$basesec"; kraxel="$armv8"		;;
	armhfp)		base="$basepri"; kraxel="$armv7"		;;
	i386)		base="$basesec"					;;
	x86_64)		base="$basepri"					;;
	*)		echo "unknown basearch: $basearch"; exit 1	;;
	esac

	cat <<EOF
[mkimage-fedora-${releasever}-server-mirror]
name=Fedora ${releasever} server mirror
baseurl=${mirror}/f${releasever}-release/Server/${basearch}/os/
cost=90
enabled=$release

[mkimage-fedora-${releasever}-everything]
name=Fedora ${releasever} everything
baseurl=${base}/releases/${releasever}/Everything/${basearch}/os/
proxy=http://spunk.home.kraxel.org:3128
enabled=$release

[mkimage-fedora-${releasever}-updates]
name=Fedora ${releasever} updates
baseurl=${base}/updates/${releasever}/$basearch/
proxy=http://spunk.home.kraxel.org:3128
enabled=$release

[mkimage-fedora-${releasever}-everything-devel]
name=Fedora ${releasever} everything development
baseurl=${base}/development/${releasever}/Everything/${basearch}/os/
proxy=http://spunk.home.kraxel.org:3128
enabled=$devel

[mkimage-fedora-${releasever}-updates-devel]
name=Fedora ${releasever} development updates
baseurl=${base}/updates/${releasever}/$basearch/
proxy=http://spunk.home.kraxel.org:3128
enabled=$devel

EOF

	if test "$kraxel" != ""; then
		cat <<EOF
[mkimage-kraxel-${basearch}]
name=kraxels ${basearch} packages
baseurl=${kraxel}
enabled=1

EOF
	fi
}

################################################################################

rels="25 26"
reldev="26"
archs="aarch64 armhfp i386 x86_64"

for rel in $rels; do
	if test "$rel" = "$reldev"; then devel=1; else devel=0; fi
	for arch in $archs; do
		repofile="fedora-${rel}-${arch}.repo"
		echo "# writing $repofile"
		makerepo "$arch" "$rel" "$devel" > "$repofile"
	done
done
