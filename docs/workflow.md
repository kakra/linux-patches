# Workflow

## Branches

All series live in the fork [kakra/linux][fork]:

- `base-<version>` starts on the `.0` release of a kernel series, e.g.
  `base-6.18` on `v6.18`. It carries no patches. When a series no longer
  applies to a newer stable release, the base is moved up to that stable
  tag.
- `rebase-<version>/<branch>` is one series for one kernel series, rebased
  on the latest base it applies to without conflicts. A series is not
  rebased on every base bump: as long as it still applies to the newer
  stable releases, it stays on its last conflict-free base. Different
  series of the same kernel series can therefore sit on different stable
  tags (e.g. `rebase-6.18/gaming-patches` on `v6.18.46`, the others on
  `v6.18`).
- Each series branch has a draft pull request against `base-<version>`
  that tracks it and holds the discussion.

Since 5.4, mostly long term kernel series are used: a rebase of every series
every two months was too much work.

## This repository

- `series/<name>` is a submodule pinned to the tip of the series branch. The
  branch of the current kernel series is recorded in `.gitmodules`
  (`submodule.<name>.branch`), together with the number of its pull request
  (`submodule.<name>.pr`).
- `patches/<version>/<name>/` is the export of that pin. Every kernel series
  keeps its own export directory, so the exports of older kernel series stay
  as history after a series moved on.
- A series that is given up loses its submodule; its exports stay.
- A series that is not rebased for a new kernel series keeps its pin as long
  as it applies (check with `tools/check-series.sh --on v<new>`).

## The base submodule

`base/` is a submodule pinned to `base-<version>` of the fork, the base
branch the series of the current kernel series are tracked against. It
carries no patches: it is the `.0` release or the stable release it was
last moved to because of conflicts. Together with the series pins it
names everything needed to rebuild a complete patch set: the stable
release, and the series on top. Each kernel series pins its base in the
same commit range as its exports; 5.4 and 5.10 have no base pin.

The checkout of `base/` is a worktree of the kernel clone like the series
checkouts. Pin a new base with:

```sh
git config -f .gitmodules submodule.base.branch base-<version>
git -C base checkout base-<version>
git add .gitmodules base
git commit -m "base: pin base-<version>"
```

## Submodule checkouts

All series are branches of one large kernel clone. A plain
`git submodule update --init` would clone the whole kernel history once per
series. Instead, the submodule checkouts are worktrees of the existing
kernel clone: the `.git` file of `series/<name>` points to
`<clone>/.git/worktrees/<name>`. They share all objects with the clone,
need no fetch, and `git submodule status`, `summary` and `update` work as
usual.

Setup:

```sh
git config linux-patches.clone /path/to/linux
# move an existing worktree of the clone into the repository
tools/add-series.sh --worktree /path/to/linux-btrfs btrfs rebase-6.18/btrfs-patches
# or create a new detached worktree
tools/add-series.sh btrfs rebase-6.18/btrfs-patches
```

Notes:

- `git submodule absorbgitdirs` refuses to move such a checkout ("more than
  one worktree"), which is intended.
- Don't use `git submodule deinit` on these checkouts. Remove a checkout
  with `git worktree remove` from the clone.
- Build output in the checkout is ignored by `git status` of this repository
  (`submodule.<name>.ignore=untracked` in the local config).
- Pins are protected from `git gc` in the clone as long as the series
  branches exist there and on the fork.
- Others can clone the submodules from the fork (shallow), or use
  `git clone --reference` with their own kernel clone.

## Exporting a series

```sh
tools/export-series.sh --summary btrfs
git diff --stat patches/
git add patches/ series/btrfs
git commit -F build/export-message.txt
```

The export runs `git format-patch` from the base tag (the nearest `v*` tag
below the tip) to the tip. A series with merge commits is refused.

## A new kernel series

1. Rebase the series branches onto `base-<new>` as `rebase-<new>/<branch>`
   and push them; open the tracking pull requests.
2. Per series: `tools/add-series.sh --pr <n> <name> rebase-<new>/<branch>`
   (with the checkout switched to the new branch first), then
   `tools/export-series.sh --summary <name>` and commit.
3. Drop series that are given up with `tools/drop-series.sh <name>`.
4. Add a section for the new kernel series to `HISTORY.md` and update the
   series table in `README.md`.

[fork]: https://github.com/kakra/linux
