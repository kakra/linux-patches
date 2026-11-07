#!/bin/bash
# Check that series apply independently of each other.
#
# Usage: tools/check-matrix.sh [--on <tag>] <branch>...
#
# Each <branch> (or any commit) of the kernel clone (linux-patches.clone)
# is a series from its base tag (the nearest v* tag below it) to its tip.
# The series are applied to a temporary index built from <tag>, by default
# the newest of their base tags:
#
# - each series alone,
# - each ordered pair (a then b, and b then a),
# - all series in the given order, and in reverse order.
#
# A series must apply in every combination, so that it can be used alone or
# together with any of the others. Nothing is checked out or changed.

source "$(dirname "$0")/lib.sh"

on=
if [[ ${1-} == --on ]]; then
	on=${2-}
	shift 2
fi
(($# >= 1)) || die "usage: $0 [--on <tag>] <branch>..."
clone=$(git -C "$TOP" config linux-patches.clone) || die "linux-patches.clone is not set"
GIT=(git -C "$clone")

work=$TOP/build/matrix
rm -rf "$work"
mkdir -p "$work"
names=()
bases=()
for rev in "$@"; do
	name=${rev##*/}
	[[ ! -e $work/$name ]] || name=${rev//\//_}
	tip=$("${GIT[@]}" rev-parse --verify "$rev^{commit}")
	base=$(base_of "$tip")
	"${GIT[@]}" format-patch -q --no-signature -o "$work/$name" "$base..$tip"
	names+=("$name")
	bases+=("$base")
	printf '%-40s %3d patches on %s\n' "$rev" "$(ls "$work/$name" | wc -l)" "$base"
done
on=${on:-$(printf '%s\n' "${bases[@]}" | sort -V | tail -n1)}
echo "Applying to $on"
echo

index=$work/index
failed=0

# Apply the given series in order, report the first patch that fails.
try() {
	rm -f "$index"
	GIT_INDEX_FILE=$index "${GIT[@]}" read-tree "$on^{tree}"
	local name patch
	for name in "$@"; do
		for patch in "$work/$name"/*.patch; do
			if ! GIT_INDEX_FILE=$index "${GIT[@]}" apply --cached "$patch" 2>/dev/null; then
				printf '%-60s FAILED at %s/%s\n' "$*" "$name" "$(basename "$patch")"
				failed=1
				return
			fi
		done
	done
	printf '%-60s ok\n' "$*"
}

for a in "${names[@]}"; do
	try "$a"
done
for a in "${names[@]}"; do
	for b in "${names[@]}"; do
		[[ $a == "$b" ]] || try "$a" "$b"
	done
done
if ((${#names[@]} > 2)); then
	try "${names[@]}"
	reversed=()
	for ((i = ${#names[@]} - 1; i >= 0; i--)); do
		reversed+=("${names[i]}")
	done
	try "${reversed[@]}"
fi
rm -f "$index"
exit $failed
