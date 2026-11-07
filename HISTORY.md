# History

The series per kernel series, newest first. "Last change" is the commit
date of the exported tip; the pull request dates show when the series
was tracked.

## 5.10

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/5.10/bcache/) | `rebase-5.10/bcache-updates` | `v5.10.20` | 7 | 2021-04-12 | [#6][pr-6], 2021-01-01 to 2021-11-13 |
| [`ck`](patches/5.10/ck/) | `rebase-5.10/ck-patches` | `v5.10` | 16 | 2021-01-19 | [#8][pr-8], 2021-01-01 to 2021-08-18 |
| [`cltweaks`](patches/5.10/cltweaks/) | `rebase-5.10/clearlinux-tweaks` | `v5.10.52` | 21 | 2021-07-21 | [#9][pr-9], 2021-01-01 to 2021-11-13 |
| [`gaming`](patches/5.10/gaming/) | `rebase-5.10/steam-patches` | `v5.10.47` | 48 | 2021-07-07 | [#10][pr-10], 2021-01-01 to 2021-11-13 |
| [`pf-ksm`](patches/5.10/pf-ksm/) | `rebase-5.10/pf-ksm` | `v5.10` | 4 | 2020-12-14 | [#7][pr-7], 2021-01-01 to 2021-11-13 |
| [`xpadneo`](patches/5.10/xpadneo/) | `rebase-5.10/xpadneo` | `v5.10.38` | 7 | 2021-05-25 | [#11][pr-11], 2021-01-01 to 2021-11-07 |

The `base-5.10` branch on the fork does not match the local one, so `base/` is not pinned for 5.10.

- `gaming`: adds the winesync driver used by some Proton versions, the
  futex2 patches (vectorized wait, `FUTEX_WAIT_MULTIPLE`) and the soft dirty
  flag reset for a VA range used by Proton's write watch.
- `ck`: MuQSS v0.205. This is the last kernel series with the -ck patches;
  threaded IRQs by default continue in `gaming`.
- `bcache`: adds four upstream bcache fixes (writeback rate with
  fragmentation, 64-bit arithmetic).
- `cltweaks`: the Clear Linux patches of 5.10; the series is based on
  5.10.52.
- `xpadneo`: new. The xpadneo driver for Xbox wireless controllers over
  Bluetooth as an in-kernel driver: the devices are excluded from
  hid-generic and hid-microsoft without udev rules or module blacklisting,
  plus an L2CAP fix for controllers that don't know all options.

[pr-6]: https://github.com/kakra/linux/pull/6
[pr-8]: https://github.com/kakra/linux/pull/8
[pr-9]: https://github.com/kakra/linux/pull/9
[pr-10]: https://github.com/kakra/linux/pull/10
[pr-7]: https://github.com/kakra/linux/pull/7
[pr-11]: https://github.com/kakra/linux/pull/11

## 5.4

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/5.4/bcache/) | `rebase-5.4/bcache-updates` | `v5.4.57` | 3 | 2020-10-03 | [#4][pr-4], 2020-09-06 to 2020-12-31 |
| [`ck`](patches/5.4/ck/) | `rebase-5.4/ck-patches` | `v5.4.62` | 15 | 2020-09-05 | [#2][pr-2], 2020-09-06 to 2020-12-31 |
| [`cltweaks`](patches/5.4/cltweaks/) | `rebase-5.4/clearlinux-tweaks` | `v5.4.22` | 25 | 2020-02-25 | [#3][pr-3], 2020-09-06 to 2020-12-31 |
| [`gaming`](patches/5.4/gaming/) | `rebase-5.4/steam-patches` | `v5.4` | 3 | 2019-12-28 | [#1][pr-1], 2020-09-06 to 2020-12-31 |
| [`pf-ksm`](patches/5.4/pf-ksm/) | `rebase-5.4/pf-ksm` | `v5.4.15` | 4 | 2020-10-29 | [#5][pr-5], 2020-10-29 to 2020-12-31 |

No base branch: the pull requests of 5.4 were opened against `master`.

5.4 is the first kernel series with a tracking pull request per series. The
older series (4.14 to 5.3: bcache, btrfs fixes, xpadneo, uksm, bfq fixes,
-ck, Steam and Clear Linux patches, mm compaction) had no pull requests and
are not part of this repository.

- `gaming` (branch `steam-patches`): the `FUTEX_WAIT_MULTIPLE` futex patches
  by Gabriel Krisman Bertazi, used by Proton's fsync.
- `ck`: Con Kolivas' -ck patch set with the MuQSS scheduler, threaded IRQs
  by default and high resolution timeouts.
- `cltweaks` (branch `clearlinux-tweaks`): selected Clear Linux kernel
  patches for boot time, power management and performance.
- `bcache`: ioprio based cache hints, based on an idea by Eric Wheeler: IO
  with a low priority (e.g. backups and maintenance jobs) bypasses the cache
  to reduce SSD wear.
- `pf-ksm`: post-factum's remote KSM patches, used by uksmd to merge
  identical memory pages.

[pr-4]: https://github.com/kakra/linux/pull/4
[pr-2]: https://github.com/kakra/linux/pull/2
[pr-3]: https://github.com/kakra/linux/pull/3
[pr-1]: https://github.com/kakra/linux/pull/1
[pr-5]: https://github.com/kakra/linux/pull/5
