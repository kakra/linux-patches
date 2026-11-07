# Shared helpers for the tools. Source this file, don't run it.
#
# A series <name> is the submodule series/<name>. Its branch in .gitmodules,
# rebase-<version>/<branch>, names the kernel series it belongs to. The
# commits of a series are read from the submodule checkout if there is one,
# otherwise from the kernel clone named by the local config
# linux-patches.clone (git config linux-patches.clone /path/to/linux).

set -euo pipefail

TOP=$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)

die() {
	echo "error: $*" >&2
	exit 1
}

# Print the kernel version of a branch name rebase-<version>/<branch>.
version_of_branch() {
	local v=${1#rebase-}
	[[ $v != "$1" && $v == */* ]] || die "not a rebase-<version>/<branch> name: $1"
	echo "${v%%/*}"
}

# Set NAME, BRANCH, VERSION, PR and GIT (a git command line for the
# repository holding the commits) for series $1.
load_series() {
	NAME=$1
	[[ $NAME =~ ^[a-z0-9-]+$ ]] || die "invalid series name: $NAME"
	BRANCH=$(git -C "$TOP" config -f .gitmodules "submodule.$NAME.branch") ||
		die "no submodule $NAME in .gitmodules"
	VERSION=$(version_of_branch "$BRANCH")
	PR=$(git -C "$TOP" config -f .gitmodules "submodule.$NAME.pr" || true)
	if [[ -e $TOP/series/$NAME/.git ]]; then
		GIT=(git -C "$TOP/series/$NAME")
	else
		local clone
		clone=$(git -C "$TOP" config linux-patches.clone) ||
			die "series/$NAME is not checked out and linux-patches.clone is not set"
		GIT=(git -C "$clone")
	fi
}

# Print the stable tag a commit is based on: the nearest v<version> tag.
base_of() {
	"${GIT[@]}" describe --tags --abbrev=0 --match 'v[0-9]*' "$1"
}

# Print the names of all series in .gitmodules.
all_series() {
	git -C "$TOP" config -f .gitmodules --name-only --get-regexp '^submodule\..*\.path$' |
		sed -e 's/^submodule\.//' -e 's/\.path$//'
}
