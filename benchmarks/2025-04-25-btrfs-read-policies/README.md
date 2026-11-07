# btrfs read policies on bcache-backed HDD RAID1

- Date: 2025-04-25
- Author: Kai Krakow
- Source: gist [btrfs read policy benchmarks][gist], first results posted in
  PR [#36][pr-36]
- Script: the original `benchmark-read-policies.sh` of the gist (the base of
  `tools/bench/btrfs-read-policies.sh`)

## System

Desktop system (Intel Core i7-12700K, 32 GB RAM). btrfs RAID1 for data on
four 7200 rpm HDDs, each behind bcache on an NVMe mdraid1; two devices
preferred for metadata through allocator hints.

## Kernel and series

6.12 with the btrfs series of PR [#36][pr-36] as of 2025-04 (read policies
pid, round-robin, latency, latency-rr; the queue policy did not exist yet).

## Steps

fio with direct I/O on a 50 GiB file, 120 s per test, caches dropped before
each test: random reads 4k QD1 and QD32, sequential reads 1M QD16. Every
policy runs once without and once with a background
`btrfs filesystem defrag -r` (metadata heavy writes).

## Results

Generated with `tools/bench/fio-summary.py` from `raw.tar.xz`:

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 412 | 1,649 | 2.42 | 16.58 | 84.41 |
| off | randread_4k_qd1 | latency-rr | read | 561 | 2,246 | 1.78 | 12.12 | 30.80 |
| off | randread_4k_qd1 | pid | read | 94 | 377 | 10.61 | 77.07 | 320.87 |
| off | randread_4k_qd1 | round-robin | read | 161 | 647 | 6.18 | 56.89 | 446.69 |
| off | randread_4k_qd32 | latency | read | 1,196 | 4,785 | 26.75 | 185.60 | 308.28 |
| off | randread_4k_qd32 | latency-rr | read | 1,928 | 7,714 | 16.59 | 139.46 | 392.17 |
| off | randread_4k_qd32 | pid | read | 763 | 3,054 | 41.91 | 261.10 | 717.23 |
| off | randread_4k_qd32 | round-robin | read | 540 | 2,161 | 59.21 | 408.94 | 1,635.78 |
| off | seqread_1M_qd16 | latency | read | 254 | 260,096 | 62.92 | 252.71 | 1,317.01 |
| off | seqread_1M_qd16 | latency-rr | read | 220 | 225,280 | 72.65 | 337.64 | 1,149.24 |
| off | seqread_1M_qd16 | pid | read | 97 | 99,533 | 164.53 | 1,484.78 | 2,432.70 |
| off | seqread_1M_qd16 | round-robin | read | 139 | 142,336 | 114.73 | 1,233.13 | 2,533.36 |
| on | randread_4k_qd1 | latency | read | 159 | 639 | 6.26 | 13.96 | 47.97 |
| on | randread_4k_qd1 | latency-rr | read | 353 | 1,412 | 2.83 | 12.65 | 26.87 |
| on | randread_4k_qd1 | pid | read | 0 | 0 | 10.73 | 0.19 | 0.19 |
| on | randread_4k_qd1 | round-robin | read | 21 | 85 | 46.57 | 434.11 | 1,350.57 |
| on | randread_4k_qd32 | latency | read | 544 | 2,176 | 58.81 | 160.43 | 219.15 |
| on | randread_4k_qd32 | latency-rr | read | 630 | 2,520 | 50.78 | 170.92 | 299.89 |
| on | randread_4k_qd32 | pid | read | 85 | 343 | 371.03 | 2,601.00 | 4,933.00 |
| on | randread_4k_qd32 | round-robin | read | 56 | 227 | 420.71 | 2,072.00 | 2,769.00 |
| on | seqread_1M_qd16 | latency | read | 235 | 241,664 | 67.93 | 162.53 | 1,019.22 |
| on | seqread_1M_qd16 | latency-rr | read | 235 | 240,640 | 68.02 | 152.04 | 1,082.13 |
| on | seqread_1M_qd16 | pid | read | 120 | 123,904 | 123.24 | 693.00 | 1,267.00 |
| on | seqread_1M_qd16 | round-robin | read | 125 | 129,024 | 116.56 | 901.78 | 1,350.57 |

`raw.tar.xz` holds the fio output, the per-device `read_stats` before and
after each test, and the benchmark and defrag logs. File system UUIDs are
replaced by `<fsid>`.

## Notes

The gist also has a Markdown summary of this run written by an assistant;
its numbers differ in places from the raw data, the table above is
generated from the raw files. `latency-rr` led the random read tests,
`latency` the sequential reads; `pid` was far behind in the random
read tests.

[gist]: https://gist.github.com/kakra/ce99896e5915f9b26d13c5637f56ff37
[pr-36]: https://github.com/kakra/linux/pull/36
