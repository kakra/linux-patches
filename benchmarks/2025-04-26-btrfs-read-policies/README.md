# btrfs read policies with the queue policy

- Date: 2025-04-26
- Author: Kai Krakow
- Source: gist [btrfs read policy benchmarks][gist], results posted in
  PR [#36][pr-36]
- Script: the original `benchmark-read-policies.sh` of the gist

## System

The same as [2025-04-25](../2025-04-25-btrfs-read-policies/): btrfs RAID1
on four 7200 rpm HDDs behind bcache on an NVMe mdraid1.

## Kernel and series

6.12 with the btrfs series of PR [#36][pr-36], now with the new queue policy
(reads go to the mirror with the fewest requests in flight).

## Steps

As in the run of 2025-04-25, with `queue` added to the policies.

## Results

Generated with `tools/bench/fio-summary.py` from `raw.tar.xz`:

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 649 | 2,599 | 1.54 | 10.81 | 21.10 |
| off | randread_4k_qd1 | latency-rr | read | 702 | 2,812 | 1.42 | 10.81 | 18.22 |
| off | randread_4k_qd1 | pid | read | 65 | 260 | 15.35 | 242.22 | 859.83 |
| off | randread_4k_qd1 | queue | read | 1,181 | 4,726 | 0.84 | 10.16 | 12.78 |
| off | randread_4k_qd1 | round-robin | read | 241 | 967 | 4.13 | 17.70 | 28.97 |
| off | randread_4k_qd32 | latency | read | 1,706 | 6,827 | 18.75 | 162.53 | 254.80 |
| off | randread_4k_qd32 | latency-rr | read | 2,477 | 9,912 | 12.91 | 139.46 | 337.64 |
| off | randread_4k_qd32 | pid | read | 537 | 2,150 | 59.51 | 480.25 | 1,098.91 |
| off | randread_4k_qd32 | queue | read | 3,647 | 14,541 | 8.77 | 89.65 | 185.60 |
| off | randread_4k_qd32 | round-robin | read | 1,180 | 4,721 | 27.11 | 185.60 | 375.39 |
| off | seqread_1M_qd16 | latency | read | 236 | 241,664 | 67.75 | 371.20 | 1,384.12 |
| off | seqread_1M_qd16 | latency-rr | read | 229 | 234,496 | 69.76 | 574.62 | 1,803.55 |
| off | seqread_1M_qd16 | pid | read | 255 | 261,120 | 62.64 | 429.92 | 1,518.34 |
| off | seqread_1M_qd16 | queue | read | 265 | 272,384 | 60.18 | 392.17 | 1,249.90 |
| off | seqread_1M_qd16 | round-robin | read | 225 | 231,424 | 70.89 | 459.28 | 1,602.23 |
| on | randread_4k_qd1 | latency | read | 257 | 1,032 | 3.87 | 14.35 | 35.39 |
| on | randread_4k_qd1 | latency-rr | read | 585 | 2,343 | 1.70 | 12.39 | 22.94 |
| on | randread_4k_qd1 | pid | read | 53 | 213 | 18.27 | 208.67 | 767.56 |
| on | randread_4k_qd1 | queue | read | 967 | 3,872 | 1.03 | 10.68 | 16.91 |
| on | randread_4k_qd1 | round-robin | read | 38 | 155 | 24.48 | 304.09 | 843.06 |
| on | randread_4k_qd32 | latency | read | 833 | 3,336 | 38.37 | 187.70 | 557.84 |
| on | randread_4k_qd32 | latency-rr | read | 1,562 | 6,251 | 20.47 | 137.36 | 267.39 |
| on | randread_4k_qd32 | pid | read | 505 | 2,024 | 62.58 | 484.44 | 1,216.35 |
| on | randread_4k_qd32 | queue | read | 2,437 | 9,751 | 13.13 | 95.95 | 278.92 |
| on | randread_4k_qd32 | round-robin | read | 717 | 2,870 | 44.59 | 404.75 | 1,010.83 |
| on | seqread_1M_qd16 | latency | read | 150 | 154,624 | 106.28 | 977.27 | 1,753.22 |
| on | seqread_1M_qd16 | latency-rr | read | 199 | 204,800 | 80.07 | 242.22 | 1,920.99 |
| on | seqread_1M_qd16 | pid | read | 50 | 51,712 | 157.24 | 1,568.67 | 2,600.47 |
| on | seqread_1M_qd16 | queue | read | 247 | 252,928 | 64.70 | 471.86 | 1,333.79 |
| on | seqread_1M_qd16 | round-robin | read | 192 | 196,608 | 83.27 | 583.01 | 1,468.01 |

`raw.tar.xz` holds the fio output, the per-device `read_stats` and the
logs, with file system UUIDs replaced by `<fsid>`.

## Notes

`queue` beat all other policies in every test, without and with the
background defrag; random reads at QD1 went from 65 IOPS (`pid`) to 1181.
This run made `queue` the recommended policy. The gist's assistant-written
summary differs in places from the raw data.

[gist]: https://gist.github.com/kakra/ce99896e5915f9b26d13c5637f56ff37
[pr-36]: https://github.com/kakra/linux/pull/36
