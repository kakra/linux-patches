#!/bin/bash
# Drop a series that is no longer maintained.
#
# Usage: tools/drop-series.sh <name>
#
# Removes the submodule entry and pin of series/<name> and stages the
# change. The exported patches in patches/<version>/<name>/ stay as
# history. A worktree checkout is not deleted: remove it with
# git worktree remove (from the kernel clone) once it is no longer needed.
# Nothing is committed.

source "$(dirname "$0")/lib.sh"

(($# == 1)) || die "usage: $0 <name>"
name=$1
git -C "$TOP" config -f .gitmodules "submodule.$name.path" >/dev/null || die "no submodule $name"
git -C "$TOP" rm -q --cached "series/$name"
git -C "$TOP" config -f .gitmodules --remove-section "submodule.$name"
git -C "$TOP" config --remove-section "submodule.$name" 2>/dev/null || true
if [[ -s $TOP/.gitmodules ]]; then
	git -C "$TOP" add .gitmodules
else
	git -C "$TOP" rm -q --cached .gitmodules
	rm -f "$TOP/.gitmodules"
fi
echo "Dropped series/$name"
if [[ -e $TOP/series/$name/.git ]]; then
	echo "The checkout series/$name is still there."
else
	rmdir "$TOP/series/$name" 2>/dev/null || true
fi
