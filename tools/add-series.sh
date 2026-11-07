#!/bin/bash
# Add a series, or move it to another kernel series.
#
# Usage: tools/add-series.sh [--pr <number>] [--rev <commit>]
#            [--worktree <path> | --no-checkout] <name> <branch>
#
# Writes the submodule entry series/<name> for <branch>
# (rebase-<version>/<branch> of github.com/kakra/linux) to .gitmodules and
# stages the pin. The submodule checkout is a worktree of the kernel clone
# (linux-patches.clone), so it shares that clone's objects:
#
# - With --worktree, an existing worktree of the clone is moved to
#   series/<name> (git worktree move) and keeps its branch.
# - Otherwise, if series/<name> is not checked out yet, a new detached
#   worktree of <branch> is created there.
# - If series/<name> is checked out already, it is left alone and only the
#   entry is updated; check out <branch> in it first.
#
# Without any checkout (the clone is set but no worktree wanted), use
# --no-checkout: then only the gitlink is staged. The pin is the tip of
# <branch> in the clone, or <commit> with --rev (e.g. the pushed state
# kakra/<branch> when the local branch has unpushed commits).
#
# Nothing is committed. Export with tools/export-series.sh afterwards.

source "$(dirname "$0")/lib.sh"

URL=https://github.com/kakra/linux.git
pr= rev= worktree= checkout=1
while (($#)); do
	case $1 in
	--pr)
		pr=${2-}
		shift
		;;
	--rev)
		rev=${2-}
		shift
		;;
	--worktree)
		worktree=${2-}
		shift
		;;
	--no-checkout) checkout= ;;
	-*) die "unknown option: $1" ;;
	*) break ;;
	esac
	shift
done
(($# == 2)) || die "usage: $0 [--pr <number>] [--rev <commit>] [--worktree <path> | --no-checkout] <name> <branch>"
name=$1 branch=$2
[[ $name =~ ^[a-z0-9-]+$ ]] || die "invalid series name: $name"
version_of_branch "$branch" >/dev/null
clone=$(git -C "$TOP" config linux-patches.clone) || die "linux-patches.clone is not set"
path=series/$name
head=$(git -C "$clone" rev-parse --verify "${rev:-refs/heads/$branch}^{commit}")

if [[ -n $worktree ]]; then
	[[ ! -e $TOP/$path ]] || die "$path exists already"
	mkdir -p "$TOP/series"
	git -C "$clone" worktree move "$worktree" "$TOP/$path"
elif [[ -n $checkout && ! -e $TOP/$path/.git ]]; then
	mkdir -p "$TOP/series"
	git -C "$clone" worktree add --detach "$TOP/$path" "$head"
else
	# An empty directory is an unpopulated submodule, a missing one shows
	# up as deleted in git status.
	mkdir -p "$TOP/$path"
fi

git -C "$TOP" config -f .gitmodules "submodule.$name.path" "$path"
git -C "$TOP" config -f .gitmodules "submodule.$name.url" "$URL"
git -C "$TOP" config -f .gitmodules "submodule.$name.branch" "$branch"
git -C "$TOP" config -f .gitmodules "submodule.$name.shallow" true
if [[ -n $pr ]]; then
	git -C "$TOP" config -f .gitmodules "submodule.$name.pr" "$pr"
else
	git -C "$TOP" config -f .gitmodules --unset "submodule.$name.pr" || true
fi
# Build output in the worktree is not part of the series.
git -C "$TOP" config "submodule.$name.ignore" untracked

if [[ -e $TOP/$path/.git ]]; then
	pin=$(git -C "$TOP/$path" rev-parse HEAD)
else
	pin=$head
fi
git -C "$TOP" update-index --add --cacheinfo "160000,$pin,$path"
git -C "$TOP" add .gitmodules
echo "Staged $path at ${pin:0:12} ($branch)"
