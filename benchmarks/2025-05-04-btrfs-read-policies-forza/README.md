# btrfs read policies on HDD RAID1 and SSD RAID10 (ForzaTNG)

- Date: 2025-05-03 and 2025-05-04
- Author: ForzaTNG
- Source: PR [#36][pr-36] (2025-05-04) and the gist comment of the same day
  ([gist][gist-5565397]); raw data from paste.tnonline.net
- Script: `benchmark-read-policies.sh` of the gist; the read/write run uses
  a variant with `randrw` tests

## System

A server with two btrfs file systems: HDD RAID1 and SATA SSD RAID10 (mixed
Kingston, WD and Seagate drives, as described in PR [#36][pr-36]).

## Kernel and series

6.12 with the btrfs series of PR [#36][pr-36] after the fix that made the
read counters `unsigned int` (it stopped the general protection faults seen
with `latency-rr` during a long balance).

## Steps

The tests of the original script: random reads 4k QD1 and QD32, sequential
reads 1M QD16, 120 s each. The published raw data of these three runs only
contains the runs without background defrag; ForzaTNG skipped the defrag
for the read/write run because it finished too fast. Runs with defrag
follow in [2025-05-08](../2025-05-08-btrfs-read-policies-forza-jobs/).

## Results

Generated with `tools/bench/fio-summary.py` from the raw data.

### HDD RAID1 (2025-05-04, `hdd-raid1.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 103 | 413 | 9.69 | 26.08 | 33.16 |
| off | randread_4k_qd1 | latency-rr | read | 96 | 386 | 10.36 | 26.87 | 33.82 |
| off | randread_4k_qd1 | pid | read | 100 | 402 | 9.94 | 25.82 | 34.34 |
| off | randread_4k_qd1 | queue | read | 100 | 402 | 9.96 | 25.56 | 33.82 |
| off | randread_4k_qd1 | round-robin | read | 89 | 358 | 11.16 | 26.61 | 35.39 |
| off | randread_4k_qd32 | latency | read | 1,644 | 6,577 | 19.46 | 76.02 | 115.87 |
| off | randread_4k_qd32 | latency-rr | read | 1,691 | 6,765 | 18.92 | 73.92 | 114.82 |
| off | randread_4k_qd32 | pid | read | 1,782 | 7,130 | 17.95 | 70.78 | 104.33 |
| off | randread_4k_qd32 | queue | read | 2,315 | 9,262 | 13.82 | 46.92 | 61.60 |
| off | randread_4k_qd32 | round-robin | read | 1,968 | 7,874 | 16.25 | 53.22 | 69.73 |
| off | seqread_1M_qd16 | latency | read | 259 | 266,240 | 61.60 | 80.00 | 117.00 |
| off | seqread_1M_qd16 | latency-rr | read | 253 | 259,072 | 63.21 | 78.00 | 87.00 |
| off | seqread_1M_qd16 | pid | read | 257 | 264,192 | 62.02 | 78.00 | 113.00 |
| off | seqread_1M_qd16 | queue | read | 287 | 293,888 | 55.73 | 209.00 | 961.00 |
| off | seqread_1M_qd16 | round-robin | read | 252 | 258,048 | 63.39 | 79.00 | 112.00 |

### SSD RAID10 (2025-05-03, `ssd-raid10.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 6,754 | 27,034 | 0.15 | 0.24 | 0.39 |
| off | randread_4k_qd1 | latency-rr | read | 6,830 | 27,341 | 0.15 | 0.22 | 0.51 |
| off | randread_4k_qd1 | pid | read | 6,792 | 27,136 | 0.15 | 0.22 | 0.37 |
| off | randread_4k_qd1 | queue | read | 6,795 | 27,136 | 0.15 | 0.22 | 0.47 |
| off | randread_4k_qd1 | round-robin | read | 6,787 | 27,136 | 0.15 | 0.23 | 0.61 |
| off | randread_4k_qd32 | latency | read | 143,000 | 570,368 | 0.22 | 0.61 | 1.39 |
| off | randread_4k_qd32 | latency-rr | read | 128,000 | 512,000 | 0.25 | 0.90 | 1.91 |
| off | randread_4k_qd32 | pid | read | 125,000 | 498,688 | 0.26 | 1.07 | 1.70 |
| off | randread_4k_qd32 | queue | read | 145,000 | 580,608 | 0.22 | 0.56 | 1.09 |
| off | randread_4k_qd32 | round-robin | read | 143,000 | 570,368 | 0.22 | 0.72 | 1.32 |
| off | seqread_1M_qd16 | latency | read | 2,927 | 2,997,248 | 5.46 | 6.72 | 9.24 |
| off | seqread_1M_qd16 | latency-rr | read | 3,001 | 3,074,048 | 5.33 | 6.39 | 8.46 |
| off | seqread_1M_qd16 | pid | read | 2,692 | 2,757,632 | 5.94 | 6.72 | 8.98 |
| off | seqread_1M_qd16 | queue | read | 5,433 | 5,563,392 | 2.94 | 3.98 | 6.19 |
| off | seqread_1M_qd16 | round-robin | read | 5,093 | 5,215,232 | 3.14 | 4.82 | 7.96 |

### SSD RAID10, random read/write (2025-05-03, `ssd-raid10-randrw.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randrw_4k_qd1 | latency | read | 2,754 | 11,059 | 0.20 | 0.69 | 4.69 |
| off | randrw_4k_qd1 | latency-rr | read | 2,655 | 10,650 | 0.21 | 1.40 | 4.08 |
| off | randrw_4k_qd1 | pid | read | 2,792 | 11,162 | 0.16 | 0.26 | 1.55 |
| off | randrw_4k_qd1 | queue | read | 3,317 | 13,312 | 0.18 | 0.50 | 3.88 |
| off | randrw_4k_qd1 | round-robin | read | 3,425 | 13,722 | 0.16 | 0.47 | 2.31 |
| off | randrw_4k_qd1 | latency | write | 2,750 | 10,957 | 0.16 | 1.47 | 8.09 |
| off | randrw_4k_qd1 | latency-rr | write | 2,653 | 10,650 | 0.16 | 1.45 | 4.36 |
| off | randrw_4k_qd1 | pid | write | 2,789 | 11,162 | 0.20 | 1.17 | 4.55 |
| off | randrw_4k_qd1 | queue | write | 3,313 | 13,210 | 0.12 | 1.16 | 7.63 |
| off | randrw_4k_qd1 | round-robin | write | 3,420 | 13,722 | 0.13 | 1.22 | 3.88 |
| off | randrw_4k_qd32 | latency | read | 19,000 | 76,186 | 0.76 | 3.98 | 30.80 |
| off | randrw_4k_qd32 | latency-rr | read | 23,800 | 95,130 | 0.63 | 5.28 | 30.54 |
| off | randrw_4k_qd32 | pid | read | 11,200 | 44,749 | 1.23 | 3.13 | 12.39 |
| off | randrw_4k_qd32 | queue | read | 28,100 | 112,640 | 0.44 | 2.70 | 11.08 |
| off | randrw_4k_qd32 | round-robin | read | 17,900 | 71,782 | 0.84 | 4.23 | 31.85 |
| off | randrw_4k_qd32 | latency | write | 19,000 | 76,083 | 0.92 | 5.41 | 14.75 |
| off | randrw_4k_qd32 | latency-rr | write | 23,800 | 95,130 | 0.71 | 4.36 | 9.24 |
| off | randrw_4k_qd32 | pid | write | 11,200 | 44,749 | 1.63 | 5.54 | 10.16 |
| off | randrw_4k_qd32 | queue | write | 28,000 | 112,640 | 0.70 | 5.41 | 9.77 |
| off | randrw_4k_qd32 | round-robin | write | 17,900 | 71,680 | 0.94 | 3.92 | 7.37 |
| off | seqreadwrite_1M_qd16 | latency | read | 241 | 247,808 | 30.52 | 73.00 | 460.00 |
| off | seqreadwrite_1M_qd16 | latency-rr | read | 268 | 275,456 | 29.24 | 78.00 | 271.00 |
| off | seqreadwrite_1M_qd16 | pid | read | 537 | 549,888 | 15.84 | 55.00 | 234.00 |
| off | seqreadwrite_1M_qd16 | queue | read | 281 | 287,744 | 28.58 | 84.00 | 259.00 |
| off | seqreadwrite_1M_qd16 | round-robin | read | 343 | 351,232 | 23.35 | 68.00 | 102.00 |
| off | seqreadwrite_1M_qd16 | latency | write | 242 | 247,808 | 35.50 | 75.00 | 911.00 |
| off | seqreadwrite_1M_qd16 | latency-rr | write | 269 | 275,456 | 30.12 | 77.00 | 422.00 |
| off | seqreadwrite_1M_qd16 | pid | write | 534 | 546,816 | 13.88 | 43.25 | 145.75 |
| off | seqreadwrite_1M_qd16 | queue | write | 281 | 288,768 | 28.11 | 66.00 | 228.00 |
| off | seqreadwrite_1M_qd16 | round-robin | write | 342 | 350,208 | 23.22 | 63.00 | 95.00 |

## Notes

The tables in the original post give fio's submission latency (`slat`) as
the average latency; the tables above are generated from the raw data and
use the total latency (`lat`).

ForzaTNG's summary: `queue` doubled the sequential read throughput of
`pid` on the SSDs; on the HDDs it was better too, by less. In the read/write
run, `queue` led the random tests, while `pid` was well ahead for sequential
reads and writes (534 write IOPS against 281 for `queue`). File system UUIDs
in the raw data are replaced by `<fsid>`.

[pr-36]: https://github.com/kakra/linux/pull/36
[gist-5565397]: https://gist.github.com/kakra/ce99896e5915f9b26d13c5637f56ff37?permalink_comment_id=5565397#gistcomment-5565397
