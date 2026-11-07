#!/bin/bash
# Check that exported series apply cleanly, without a checkout.
#
# Usage: tools/check-series.sh [--on <tag>] <version> [<name>...]
#
# Applies patches/<version>/<name>/ in series order to a temporary index
# built from the series' base tag (from its source file), or from <tag>
# with --on, e.g. to see whether a series still applies to a later stable
# release or to the next kernel series. Without names, all series exported
# for <version> are checked. Needs linux-patches.clone (see tools/lib.sh).

source "$(dirname "$0")/lib.sh"

on=
if [[ ${1-} == --on ]]; then
	on=${2-}
	shift 2
fi
(($# >= 1)) || die "usage: $0 [--on <tag>] <version> [<name>...]"
version=$1
shift
dir=$TOP/patches/$version
[[ -d $dir ]] || die "no exports for $version"
clone=$(git -C "$TOP" config linux-patches.clone) || die "linux-patches.clone is not set"

names=("$@")
if ((${#names[@]} == 0)); then
	for d in "$dir"/*/; do
		[[ -f $d/series ]] && names+=("$(basename "$d")")
	done
fi

mkdir -p "$TOP/build"
index=$TOP/build/check.index
failed=0
for name in "${names[@]}"; do
	sdir=$dir/$name
	[[ -f $sdir/series ]] || die "no export of $name for $version"
	base=${on:-$(sed -n 's/^base=//p' "$sdir/source")}
	rm -f "$index"
	GIT_INDEX_FILE=$index git -C "$clone" read-tree "$base^{tree}"
	result=ok
	while read -r patch; do
		if ! GIT_INDEX_FILE=$index git -C "$clone" apply --cached "$sdir/$patch" 2>"$TOP/build/check.err"; then
			result="FAILED at $patch"
			sed 's/^/    /' "$TOP/build/check.err"
			failed=1
			break
		fi
	done <"$sdir/series"
	printf '%-10s %-12s %3d patches on %-10s %s\n' "$version" "$name" "$(wc -l <"$sdir/series")" "$base" "$result"
done
rm -f "$index" "$TOP/build/check.err"
exit $failed
