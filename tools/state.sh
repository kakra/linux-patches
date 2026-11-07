#!/bin/bash
# Print the state of the running system that the series affect.
#
# Usage: tools/state.sh [<patch dir>]
#
# Prints the kernel, the installed patch files with the tip commit each was
# exported from, and the settings the series change (I/O schedulers, btrfs
# read policies, TCP congestion control, memory and scheduler knobs). Use it
# for entries in observations/ and benchmarks/, so that a change can be
# related to the state it was seen in. Run it on the system itself, as a
# normal user; values that need root are reported as "n/a".
#
# The patch dir defaults to the Portage user patches of gentoo-sources.
# With linux-patches.clone set, the branch a tip belongs to is shown too.
# UUIDs and the machine id in the command line are replaced by placeholders;
# btrfs file systems are shown by their label.

set -uo pipefail

PATCH_DIR=${1:-/etc/portage/patches/sys-kernel/gentoo-sources}
CLONE=$(git -C "$(dirname "$0")" config linux-patches.clone 2>/dev/null || true)
UUID_RE='[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}'

val() {
	local v
	v=$(cat "$1" 2>/dev/null) || v=n/a
	printf '%-44s %s\n' "$2" "$v"
}

echo "# System state $(date '+%Y-%m-%d %H:%M %Z')"
echo
echo "## Kernel"
echo
printf '%-44s %s\n' "release" "$(uname -r)"
printf '%-44s %s\n' "version" "$(uname -v)"
printf '%-44s %s\n' "cmdline" "$(sed -e "s/$UUID_RE/<fsid>/g" \
	-e 's/\(machine_id=\)[0-9a-f]*/\1<machine-id>/g' \
	-e 's/\(md\.uuid=\)[0-9a-f:]*/\1<md-uuid>/g' /proc/cmdline)"
printf '%-44s %s\n' "uptime" "$(uptime -p)"

echo
echo "## Installed patch files ($PATCH_DIR)"
echo
if [[ -d $PATCH_DIR ]]; then
	for f in "$PATCH_DIR"/*.patch; do
		[[ -e $f ]] || continue
		n=$(grep -c '^From [0-9a-f]\{40\} ' "$f")
		tip=$(grep -o '^From [0-9a-f]\{40\} ' "$f" | tail -n1 | cut -c6-17)
		branch=
		if [[ -n $tip && -n $CLONE ]]; then
			branch=$(git -C "$CLONE" branch --format='%(refname:short)' --points-at "$tip" 2>/dev/null | head -n1)
		fi
		printf '%-44s %3d patches, tip %s%s\n' "$(basename "$f")" "$n" "${tip:-?}" "${branch:+ ($branch)}"
	done
else
	echo "n/a"
fi

echo
echo "## Block devices"
echo
for q in /sys/block/*/queue/scheduler; do
	dev=${q#/sys/block/}
	dev=${dev%%/*}
	case $dev in loop* | ram* | zram* | dm-*) continue ;; esac
	printf '%-44s %s\n' "$dev scheduler" "$(cat "$q")"
done
for b in /sys/block/bcache*/bcache; do
	[[ -d $b ]] || continue
	dev=${b#/sys/block/}
	dev=${dev%%/*}
	printf '%-44s %s\n' "$dev cache_mode" "$(cat "$b/cache_mode" 2>/dev/null)"
done

echo
echo "## btrfs"
echo
for fs in /sys/fs/btrfs/*/; do
	[[ -f $fs/read_policy ]] || continue
	label=$(cat "$fs/label" 2>/dev/null)
	printf '%-44s %s\n' "${label:-<fsid>} read_policy" "$(cat "$fs/read_policy")"
	for d in "$fs"devinfo/*/; do
		[[ -f $d/type ]] || continue
		printf '%-44s %s\n' "${label:-<fsid>} devid $(basename "$d") type" "$(cat "$d/type")"
	done
done

echo
echo "## Settings"
echo
val /proc/sys/net/ipv4/tcp_congestion_control "net.ipv4.tcp_congestion_control"
val /proc/sys/vm/workingset_protection "vm.workingset_protection"
val /proc/sys/vm/anon_min_ratio "vm.anon_min_ratio"
val /proc/sys/vm/clean_low_ratio "vm.clean_low_ratio"
val /proc/sys/vm/clean_min_ratio "vm.clean_min_ratio"
val /proc/sys/vm/swappiness "vm.swappiness"
val /proc/sys/vm/page-cluster "vm.page-cluster"
val /proc/sys/vm/compact_unevictable_allowed "vm.compact_unevictable_allowed"
val /proc/sys/vm/max_map_count "vm.max_map_count"
val /proc/sys/kernel/split_lock_mitigate "kernel.split_lock_mitigate"
val /sys/kernel/mm/transparent_hugepage/enabled "transparent_hugepage/enabled"
val /sys/kernel/mm/transparent_hugepage/defrag "transparent_hugepage/defrag"
val /sys/kernel/mm/lru_gen/enabled "lru_gen/enabled"
val /sys/kernel/mm/ksm/run "ksm/run"
val /sys/kernel/mm/ksm/pages_sharing "ksm/pages_sharing"
val /sys/kernel/debug/sched/cgroup_mode "sched/cgroup_mode"
val /sys/kernel/sched_ext/root/ops "sched_ext/root/ops"
