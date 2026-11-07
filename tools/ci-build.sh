#!/bin/bash
# Test-build exported series on a minimal kernel configuration.
#
# Usage: tools/ci-build.sh [options] <version> [<series>...]
#
#   <version>   kernel series of the exports, e.g. 7.3
#   <series>    names under patches/<version>/ or paths to directories with
#               a quilt "series" file; applied in the given order (default:
#               all exports of <version>)
#
# Options:
#   -r <url>    kernel repository to clone the base tag from (default:
#               the stable tree on git.kernel.org; a local clone works as
#               file:///path/to/linux)
#   -w <dir>    work directory (default: build/ci)
#   -j <n>      parallel make jobs (default: nproc)
#
# Clones the base tag shallowly (the newest base tag of the given series,
# from their source files), applies the patches with git am, configures
# tinyconfig plus configs/base.config (64-bit) and configs/<name>.config of
# each series, checks that every option of the fragments ended up set, and
# builds the kernel. Used by the GitHub workflow; runs the same way locally.

set -euo pipefail

TOP=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
REPO=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
WORK=$TOP/build/ci
JOBS=$(nproc)

die() {
	echo "error: $*" >&2
	exit 1
}

while getopts r:w:j: opt; do
	case $opt in
	r) REPO=$OPTARG ;;
	w) WORK=$OPTARG ;;
	j) JOBS=$OPTARG ;;
	*) exit 1 ;;
	esac
done
shift $((OPTIND - 1))
(($# >= 1)) || die "usage: $0 [-r <url>] [-w <dir>] [-j <n>] <version> [<series>...]"
version=$1
shift

dirs=()
if (($# == 0)); then
	for d in "$TOP/patches/$version"/*/; do
		[[ -f $d/series ]] && dirs+=("${d%/}")
	done
else
	for s in "$@"; do
		if [[ -d $s ]]; then
			dirs+=("$(cd "$s" && pwd)")
		else
			dirs+=("$TOP/patches/$version/$s")
		fi
	done
fi
((${#dirs[@]} > 0)) || die "no series for $version"

bases=()
names=()
for d in "${dirs[@]}"; do
	[[ -f $d/series ]] || die "no series file in $d"
	name=$(basename "$d")
	names+=("$name")
	if [[ -f $d/source ]]; then
		bases+=("$(sed -n 's/^base=//p' "$d/source")")
	else
		bases+=("v$version")
	fi
done
base=$(printf '%s\n' "${bases[@]}" | sort -V | tail -n1)
label=$(
	IFS=+
	echo "${names[*]}"
)
echo "Building $label on $base"

src=$WORK/src-$base
if [[ ! -d $src/.git ]]; then
	mkdir -p "$WORK"
	git clone -q --depth 1 --branch "$base" "$REPO" "$src"
fi
git -C "$src" checkout -q --detach "$base" 2>/dev/null || git -C "$src" checkout -q --detach FETCH_HEAD
git -C "$src" reset -q --hard
git -C "$src" clean -qfdx

export GIT_COMMITTER_NAME=ci GIT_COMMITTER_EMAIL=ci@localhost
for d in "${dirs[@]}"; do
	while read -r patch; do
		[[ -z $patch || $patch == \#* ]] && continue
		git -C "$src" am -q "$d/$patch" || {
			git -C "$src" am --abort
			die "$(basename "$d")/$patch does not apply on $base"
		}
	done <"$d/series"
done

out=$WORK/out-$label
rm -rf "$out"
mkdir -p "$out"
make -s -C "$src" O="$out" tinyconfig
fragments=("$TOP/configs/base.config")
for name in "${names[@]}"; do
	frag=$TOP/configs/$name.config
	[[ -f $frag ]] && fragments+=("$frag")
done
(cd "$src" && KCONFIG_CONFIG=$out/.config scripts/kconfig/merge_config.sh -m -O "$out" \
	"$out/.config" "${fragments[@]}" >/dev/null)
make -s -C "$src" O="$out" olddefconfig
missing=0
for frag in "${fragments[@]}"; do
	while IFS= read -r line; do
		[[ $line == CONFIG_* ]] || continue
		grep -qx "$line" "$out/.config" || {
			echo "error: $line from $(basename "$frag") is not set" >&2
			missing=1
		}
	done <"$frag"
done
((missing == 0)) || die "configuration incomplete"

make -s -C "$src" O="$out" -j"$JOBS" vmlinux
echo "OK: $label on $base"
