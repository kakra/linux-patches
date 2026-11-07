# History

The series per kernel series, newest first. "Last change" is the commit
date of the exported tip; the pull request dates show when the series
was tracked.

## 6.18

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/6.18/bcache/) | `rebase-6.18/bcache-updates` | `v6.18` | 4 | 2026-11-06 | [#41][pr-41], 2025-12-14 to open |
| [`btrfs`](patches/6.18/btrfs/) | `rebase-6.18/btrfs-patches` | `v6.18` | 19 | 2026-08-30 | [#40][pr-40], 2025-12-14 to open |
| [`cltweaks`](patches/6.18/cltweaks/) | `rebase-6.18/cltweaks` | `v6.18` | 22 | 2025-12-14 | [#43][pr-43], 2025-12-14 to open |
| [`gaming`](patches/6.18/gaming/) | `rebase-6.18/gaming-patches` | `v6.18.46` | 21 | 2026-10-05 | [#44][pr-44], 2025-12-15 to open |
| [`memory`](patches/6.18/memory/) | `rebase-6.18/memory` | `v6.18` | 2 | 2026-05-04 | [#45][pr-45], 2026-05-07 to open |
| [`pf-ksm`](patches/6.18/pf-ksm/) | `rebase-6.18/pf-ksm` | `v6.18` | 2 | 2025-12-14 | [#42][pr-42], 2025-12-14 to open |

Base: `base-6.18` at `v6.18.46`, pinned as `base/`.

- `xpadneo` is given up as an in-kernel series after 6.12; a different
  solution replaces it.
- `cltweaks` (branch renamed from `clearlinux-tweaks`): Intel stopped
  maintaining the Clear Linux patches; the series is kept as long as it
  applies.
- `gaming`: ntsync is upstream and dropped, as are most ZEN patches not
  related to interactivity. Adds BORE from CachyOS, the ADIOS IO scheduler
  as default, and prefers full idle SMT cores. Based on 6.18.46.
- `btrfs`: reworked into tiered allocator hints behind their own Kconfig
  option and queue based read policies (queue-adaptive, ties broken by
  mirror age), with read latency health statistics per device; the read
  policies are no longer experimental.
- `bcache`: makes the bcache workqueue `WQ_UNBOUND`.
- `memory`: new. Working set protection from le9uo, adapted to mgLRU and
  enabled by default (`vm.workingset_protection`): page cache of active
  applications is kept under memory pressure, and the OOM killer acts
  earlier instead of the system thrashing.

[pr-41]: https://github.com/kakra/linux/pull/41
[pr-40]: https://github.com/kakra/linux/pull/40
[pr-43]: https://github.com/kakra/linux/pull/43
[pr-44]: https://github.com/kakra/linux/pull/44
[pr-45]: https://github.com/kakra/linux/pull/45
[pr-42]: https://github.com/kakra/linux/pull/42

## 6.12

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/6.12/bcache/) | `rebase-6.12/bcache-updates` | `v6.12` | 3 | 2024-11-18 | [#35][pr-35], 2024-11-23 to 2025-12-14 |
| [`btrfs`](patches/6.12/btrfs/) | `rebase-6.12/btrfs-patches` | `v6.12` | 36 | 2025-06-23 | [#36][pr-36], 2024-11-23 to 2025-12-14 |
| [`cltweaks`](patches/6.12/cltweaks/) | `rebase-6.12/clearlinux-tweaks` | `v6.12.18` | 38 | 2025-03-09 | [#34][pr-34], 2024-11-23 to 2025-12-14 |
| [`gaming`](patches/6.12/gaming/) | `rebase-6.12/gaming-patches` | `v6.12.31` | 53 | 2025-10-05 | [#33][pr-33], 2024-11-23 to 2025-12-15 |
| [`pf-ksm`](patches/6.12/pf-ksm/) | `rebase-6.12/pf-ksm` | `v6.12` | 2 | 2024-11-18 | [#37][pr-37], 2024-11-23 to 2025-12-14 |
| [`xpadneo`](patches/6.12/xpadneo/) | `rebase-6.12/xpadneo` | `v6.12` | 6 | 2024-11-18 | [#38][pr-38], 2024-11-23 to open |

Base: `base-6.12` at `v6.12.31`, pinned as `base/`.

- `gaming` (branch renamed from `steam-patches` to `gaming-patches`):
  winesync is replaced by ntsync (ntsync7), and the BORE scheduler is
  added. Based on 6.12.31.
- `btrfs`: adds RAID1 read balancing policies (round-robin, lowest latency,
  a hybrid of both, in-flight queue depth and a preferred device) with
  per-device read statistics, and an allocator hint that disables
  allocations on a device completely. A guide by Forza-tng documents the
  allocator hints and read policies ([wiki][forza-guide]).
- `cltweaks`: Clear Linux patches of 6.12, based on 6.12.18. With the
  PDS/BMQ patches of the Gentoo kernel (`USE=experimental`) they conflict;
  excluding Gentoo patches 5020 and 5021 avoids that.
- `pf-ksm`: uses `pidfd_get_task()`.
- `xpadneo`: the last kernel series of the in-kernel driver.

[forza-guide]: https://wiki.tnonline.net/w/Btrfs/Allocator_Hints

[pr-35]: https://github.com/kakra/linux/pull/35
[pr-36]: https://github.com/kakra/linux/pull/36
[pr-34]: https://github.com/kakra/linux/pull/34
[pr-33]: https://github.com/kakra/linux/pull/33
[pr-37]: https://github.com/kakra/linux/pull/37
[pr-38]: https://github.com/kakra/linux/pull/38

## 6.6

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/6.6/bcache/) | `rebase-6.6/bcache-updates` | `v6.6` | 3 | 2023-11-19 | [#32][pr-32], 2023-11-26 to 2024-11-23 |
| [`btrfs`](patches/6.6/btrfs/) | `rebase-6.6/btrfs-patches` | `v6.6.50` | 5 | 2024-09-09 | [#31][pr-31], 2023-11-26 to 2024-11-23 |
| [`cltweaks`](patches/6.6/cltweaks/) | `rebase-6.6/clearlinux-tweaks` | `v6.6` | 40 | 2023-11-19 | [#28][pr-28], 2023-11-26 to 2024-11-23 |
| [`gaming`](patches/6.6/gaming/) | `rebase-6.6/steam-patches` | `v6.6.44` | 57 | 2024-08-04 | [#30][pr-30], 2023-11-26 to 2024-11-23 |
| [`pf-ksm`](patches/6.6/pf-ksm/) | `rebase-6.6/pf-ksm` | `v6.6` | 1 | 2023-10-30 | [#27][pr-27], 2023-11-26 to 2024-11-23 |
| [`xpadneo`](patches/6.6/xpadneo/) | `rebase-6.6/xpadneo` | `v6.6` | 6 | 2023-11-20 | [#29][pr-29], 2023-11-26 to 2024-11-23 |

Base: `base-6.6` at `v6.6.50`, pinned as `base/`.

- `bcache`: back, with the same three patches as in 5.15.
- `gaming`: switches from CFS tuning to EEVDF and takes the ZEN
  `INTERACTIVE` patches with their config option (mgLRU cache protection,
  compaction and watermark boost defaults, BFQ for single queue and Kyber
  for multi queue devices). Drops the 2 MB read-ahead, which seemed to
  cause freezes and memory fragmentation after periods of high memory and
  IO load. Based on 6.6.44.
- `pf-ksm`: one patch that exposes per-process KSM control through system
  calls.
- `cltweaks`: grows to 40 patches with the newer Clear Linux set (idle
  balance, EPP retune, timer slack, boot time measurements).
- `btrfs`: adds an allocator hint that prefers no new allocations on a
  device (type 4), to drain a device before removing it. Based on 6.6.50.

[pr-32]: https://github.com/kakra/linux/pull/32
[pr-31]: https://github.com/kakra/linux/pull/31
[pr-28]: https://github.com/kakra/linux/pull/28
[pr-30]: https://github.com/kakra/linux/pull/30
[pr-27]: https://github.com/kakra/linux/pull/27
[pr-29]: https://github.com/kakra/linux/pull/29

## 6.1

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`btrfs`](patches/6.1/btrfs/) | `rebase-6.1/btrfs-patches` | `v6.1` | 4 | 2022-12-18 | [#26][pr-26], 2023-03-11 to 2023-11-26 |
| [`cltweaks`](patches/6.1/cltweaks/) | `rebase-6.1/clearlinux-tweaks` | `v6.1` | 30 | 2023-01-19 | [#24][pr-24], 2023-03-11 to 2023-11-26 |
| [`gaming`](patches/6.1/gaming/) | `rebase-6.1/steam-patches` | `v6.1.57` | 48 | 2023-10-11 | [#23][pr-23], 2023-03-11 to 2023-11-26 |
| [`pf-ksm`](patches/6.1/pf-ksm/) | `rebase-6.1/pf-ksm` | `v6.1` | 5 | 2022-12-11 | [#25][pr-25], 2023-03-11 to 2023-11-26 |
| [`xpadneo`](patches/6.1/xpadneo/) | `rebase-6.1/xpadneo` | `v6.1` | 6 | 2022-12-27 | [#22][pr-22], 2023-03-11 to 2023-11-26 |

Base: `base-6.1` at `v6.1.57`, pinned as `base/`.

- `bcache`: there is no 6.1 series. The 5.15 series doesn't apply to
  `v6.1` (the sysfs hint patch conflicts), so it is dropped here and comes
  back with 6.6.
- `gaming`: adds lower latency CFS tuning, ZEN memory management patches
  (rmqueue_bulk, pageblock size), 2 MB file read-ahead, a raised
  `vm.max_map_count`, the ACS override patch, and an entry point for
  `FUTEX_WAIT_MULTIPLE` on top of `futex_waitv()` for older Proton
  versions. Based on 6.1.57.
- `pf-ksm`: post-factum's KSM interface changes from remote merge to the
  `pmadv_ksm()` system call.
- `xpadneo`: xpadneo v0.9.5.

[pr-26]: https://github.com/kakra/linux/pull/26
[pr-24]: https://github.com/kakra/linux/pull/24
[pr-23]: https://github.com/kakra/linux/pull/23
[pr-25]: https://github.com/kakra/linux/pull/25
[pr-22]: https://github.com/kakra/linux/pull/22

## 5.15

| Series | Branch | Base | Patches | Last change | Pull request |
|---|---|---|---|---|---|
| [`bcache`](patches/5.15/bcache/) | `rebase-5.15/bcache-updates` | `v5.15` | 3 | 2021-11-12 | [#19][pr-19], 2021-11-13 to 2023-03-11 |
| [`btrfs`](patches/5.15/btrfs/) | `rebase-5.15/btrfs-patches` | `v5.15` | 4 | 2021-12-04 | [#20][pr-20], 2021-12-05 to 2023-03-11 |
| [`cltweaks`](patches/5.15/cltweaks/) | `rebase-5.15/clearlinux-tweaks` | `v5.15.44` | 27 | 2022-05-31 | [#17][pr-17], 2021-11-13 to 2023-03-11 |
| [`gaming`](patches/5.15/gaming/) | `rebase-5.15/steam-patches` | `v5.15.86` | 45 | 2023-01-10 | [#16][pr-16], 2021-11-13 to 2023-03-11 |
| [`pf-ksm`](patches/5.15/pf-ksm/) | `rebase-5.15/pf-ksm` | `v5.15` | 4 | 2021-11-13 | [#18][pr-18], 2021-11-13 to 2023-03-11 |
| [`xpadneo`](patches/5.15/xpadneo/) | `rebase-5.15/xpadneo` | `v5.15` | 7 | 2022-06-30 | [#15][pr-15], 2021-11-07 to 2023-03-11 |

Base: `base-5.15` at `v5.15.86`, pinned as `base/`.

- `ck` is given up: the -ck patches were not ported beyond 5.10.
- `gaming`: futex2 and `FUTEX_WAIT_MULTIPLE` are replaced by
  `futex_waitv()` as merged upstream in 5.16. Adds winesync events and
  alertable waits, threaded IRQs by default (from -ck), bfq as the default
  IO scheduler, soft dirty read with reset, and protection of mappings under
  memory pressure. Based on 5.15.86.
- `bcache`: the upstream fixes of 5.10 are part of 5.15, the ioprio hints
  remain.
- `btrfs`: new. Allocator hints: the chunk allocator prefers devices by
  their `dev_item.type`, set through
  `/sys/fs/btrfs/<uuid>/devinfo/<devid>/type`, e.g. metadata on SSDs and
  data on HDDs. The file system stays compatible with unpatched kernels.

[pr-19]: https://github.com/kakra/linux/pull/19
[pr-20]: https://github.com/kakra/linux/pull/20
[pr-17]: https://github.com/kakra/linux/pull/17
[pr-16]: https://github.com/kakra/linux/pull/16
[pr-18]: https://github.com/kakra/linux/pull/18
[pr-15]: https://github.com/kakra/linux/pull/15

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
