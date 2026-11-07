# linux-patches

Patch series for the Linux kernel, used on a Gentoo desktop system in daily
use (gaming, development, btrfs on mixed SSD/HDD pools with bcache). Each
series is a branch of the fork [kakra/linux][fork] with a pull request that
tracks it; this repository pins those branches as submodules and keeps an
exported copy of every series, so the history of a series stays readable
after its branch was rebased.

**Status:** use at your own risk. The series change file systems, block
caching, memory management and scheduling. Only use them if you can recover
your system by booting another kernel. There is no support and no warranty
(see [LICENSE](LICENSE)).

## Series

Active series, maintained for the current kernel series (7.3):

| Series | Content | Since |
|---|---|---|
| `bcache` | bcache IO hinting: low priority IO bypasses the cache | 5.4 |
| `btrfs` | btrfs allocator hints and RAID1 read balancing policies | 5.15 |
| `gaming` | Gaming and desktop interactivity patches: ZEN interactive defaults, ADIOS, working set protection (le9uo); formerly `steam-patches` | 5.4 |
| `platform` | Patches useful on servers and recommended for desktops: process KSM for uksmd, Clear Linux network and locking tweaks, BBRv3 | 7.3 |

Historical series, kept as exports in `patches/`:

| Series | Content | Kernel series | What became of it |
|---|---|---|---|
| `ck` | Con Kolivas' patch set | 5.4, 5.10 | given up; threaded IRQs moved to `gaming` until 6.18 |
| `cltweaks` | Selected Clear Linux performance patches | 5.4 to 6.18 | dissolved into `platform` and `gaming` |
| `memory` | Working set protection under memory pressure (le9uo) | 6.18 | moved into `gaming` |
| `pf-ksm` | post-factum's KSM patches for uksmd | 5.4 to 6.18 | moved into `platform` |
| `xpadneo` | xpadneo Xbox controller driver as in-kernel driver | 5.10 to 6.12 | given up as an in-kernel series |

[HISTORY.md](HISTORY.md) describes each kernel series: which branches, on
which stable release, with which pull request.

## Layout

| Path | Content |
|---|---|
| `base/` | Submodule: branch `base-<version>` of [kakra/linux][fork], the stable release the series of a kernel series are tracked against |
| `series/<name>/` | Submodule: branch `rebase-<version>/<branch>` of [kakra/linux][fork] |
| `patches/<version>/<name>/` | The series exported from that branch, applicable with `git am` to its base tag |
| `benchmarks/<date>-<topic>/` | Benchmark runs and published results, with raw data |
| `observations/<version>.md` | Dated notes on how the system behaves with a kernel series |
| `configs/<name>.config` | Kconfig fragments with the options each series needs, used by the test builds |
| `tools/` | Export, check and submodule helpers; `tools/bench/` holds the benchmark scripts |
| `docs/` | Workflow |
| `HISTORY.md` | The series per kernel series, and what changed |

`patches/<version>/<name>/source` names the branch, the stable tag the
series is based on, the exported commit and the pull request.

## Using a series

On a clone of the kernel:

```sh
git checkout -b my-7.3 v7.3
git am /path/to/linux-patches/patches/7.3/btrfs/*.patch
```

A series also applies to later stable releases of the same kernel series as
long as they don't conflict (see [docs/workflow.md](docs/workflow.md)).

The submodules point at large kernel branches. Cloning them is not needed to
use the patches; if you do, the submodules are marked shallow:

```sh
git submodule update --init --depth 1 series/btrfs
```

## About this repository

The tools, documentation and history reconstruction were written with the
help of an AI assistant (Claude) and reviewed by the maintainer. The patches
themselves come from the branches of the fork and keep their original
authors.

## License

The patches modify the Linux kernel and are licensed like it under the GNU
General Public License version 2 (see [LICENSE](LICENSE)); individual
patches keep the license of the files they change. The tools and
documentation in this repository are licensed under the same terms.

[fork]: https://github.com/kakra/linux
