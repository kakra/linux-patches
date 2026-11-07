# btrfs read policies with 1 and 4 fio jobs (ForzaTNG)

- Date: 2025-05-05 to 2025-05-08
- Author: ForzaTNG
- Source: gist comment of 2025-05-08 ([gist][gist-5571411]); the tables in
  the [Allocator Hints guide][wiki] are based on this data set
- Script: `benchmark-read-policies.sh` of the gist, run with 1 and with 4
  fio jobs

## System

The server of [2025-05-04](../2025-05-04-btrfs-read-policies-forza/): HDD
RAID1 and SATA SSD RAID10.

## Kernel and series

6.12 with the btrfs series of PR [#36][pr-36] as of early May 2025.

## Steps

The tests of the original script, each with 1 and with 4 fio jobs, with and
without a background defrag.

## Results

Generated with `tools/bench/fio-summary.py` from the raw data.

### HDD RAID1, 1 job (`hdd-raid1-jobs1.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 89 | 358 | 11.16 | 26.61 | 32.90 |
| off | randread_4k_qd1 | latency-rr | read | 87 | 348 | 11.48 | 28.18 | 33.82 |
| off | randread_4k_qd1 | pid | read | 81 | 328 | 12.21 | 30.02 | 242.22 |
| off | randread_4k_qd1 | queue | read | 102 | 409 | 9.77 | 24.51 | 35.39 |
| off | randread_4k_qd1 | round-robin | read | 93 | 374 | 10.69 | 26.08 | 60.03 |
| off | randread_4k_qd32 | latency | read | 1,508 | 6,035 | 21.21 | 126.35 | 233.83 |
| off | randread_4k_qd32 | latency-rr | read | 1,459 | 5,837 | 21.93 | 111.67 | 185.60 |
| off | randread_4k_qd32 | pid | read | 1,725 | 6,900 | 18.55 | 93.85 | 147.85 |
| off | randread_4k_qd32 | queue | read | 2,064 | 8,259 | 15.50 | 55.84 | 78.12 |
| off | randread_4k_qd32 | round-robin | read | 1,772 | 7,092 | 18.05 | 71.83 | 112.72 |
| off | seqread_1M_qd16 | latency | read | 267 | 273,408 | 59.82 | 104.00 | 205.00 |
| off | seqread_1M_qd16 | latency-rr | read | 263 | 270,336 | 60.67 | 105.00 | 266.00 |
| off | seqread_1M_qd16 | pid | read | 266 | 273,408 | 59.94 | 99.00 | 211.00 |
| off | seqread_1M_qd16 | queue | read | 292 | 299,008 | 54.70 | 211.00 | 1,620.00 |
| off | seqread_1M_qd16 | round-robin | read | 267 | 273,408 | 59.89 | 104.00 | 224.00 |
| on | randread_4k_qd1 | latency | read | 36 | 146 | 27.39 | 320.87 | 683.67 |
| on | randread_4k_qd1 | latency-rr | read | 50 | 200 | 19.97 | 214.96 | 408.94 |
| on | randread_4k_qd1 | pid | read | 40 | 162 | 24.67 | 354.42 | 541.07 |
| on | randread_4k_qd1 | queue | read | 80 | 324 | 12.36 | 80.22 | 304.09 |
| on | randread_4k_qd1 | round-robin | read | 43 | 175 | 22.86 | 278.92 | 476.05 |
| on | randread_4k_qd32 | latency | read | 1,210 | 4,844 | 26.42 | 206.57 | 497.03 |
| on | randread_4k_qd32 | latency-rr | read | 1,083 | 4,333 | 29.54 | 250.61 | 513.80 |
| on | randread_4k_qd32 | pid | read | 1,159 | 4,640 | 27.59 | 287.31 | 708.84 |
| on | randread_4k_qd32 | queue | read | 1,662 | 6,651 | 19.24 | 91.75 | 240.12 |
| on | randread_4k_qd32 | round-robin | read | 1,191 | 4,767 | 26.85 | 235.93 | 442.50 |
| on | seqread_1M_qd16 | latency | read | 247 | 253,952 | 64.64 | 266.00 | 1,003.00 |
| on | seqread_1M_qd16 | latency-rr | read | 251 | 258,048 | 63.59 | 228.00 | 961.00 |
| on | seqread_1M_qd16 | pid | read | 230 | 236,544 | 69.33 | 409.00 | 1,045.00 |
| on | seqread_1M_qd16 | queue | read | 282 | 288,768 | 56.66 | 249.00 | 1,167.00 |
| on | seqread_1M_qd16 | round-robin | read | 268 | 274,432 | 59.69 | 300.00 | 869.00 |

### HDD RAID1, 4 jobs (`hdd-raid1-jobs4.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 389 | 1,556 | 10.27 | 31.07 | 44.83 |
| off | randread_4k_qd1 | latency-rr | read | 358 | 1,436 | 11.14 | 34.34 | 141.56 |
| off | randread_4k_qd1 | pid | read | 369 | 1,478 | 10.82 | 30.54 | 40.11 |
| off | randread_4k_qd1 | queue | read | 432 | 1,730 | 9.24 | 27.92 | 35.39 |
| off | randread_4k_qd1 | round-robin | read | 361 | 1,447 | 11.05 | 31.85 | 45.35 |
| off | randread_4k_qd32 | latency | read | 2,423 | 9,695 | 52.80 | 350.23 | 530.58 |
| off | randread_4k_qd32 | latency-rr | read | 2,691 | 10,752 | 47.56 | 308.28 | 467.67 |
| off | randread_4k_qd32 | pid | read | 3,188 | 12,800 | 40.13 | 224.00 | 351.00 |
| off | randread_4k_qd32 | queue | read | 3,649 | 14,643 | 35.07 | 171.00 | 264.00 |
| off | randread_4k_qd32 | round-robin | read | 3,211 | 12,800 | 39.85 | 212.86 | 329.25 |
| off | seqread_1M_qd16 | latency | read | 571 | 585,728 | 111.81 | 642.00 | 1,670.00 |
| off | seqread_1M_qd16 | latency-rr | read | 489 | 501,760 | 130.18 | 810.00 | 1,737.00 |
| off | seqread_1M_qd16 | pid | read | 668 | 684,032 | 95.60 | 567.00 | 1,452.00 |
| off | seqread_1M_qd16 | queue | read | 609 | 624,640 | 104.78 | 550.00 | 1,351.00 |
| off | seqread_1M_qd16 | round-robin | read | 553 | 567,296 | 115.24 | 709.00 | 1,787.00 |
| on | randread_4k_qd1 | latency | read | 153 | 615 | 26.01 | 329.25 | 583.01 |
| on | randread_4k_qd1 | latency-rr | read | 180 | 723 | 22.14 | 250.61 | 467.67 |
| on | randread_4k_qd1 | pid | read | 171 | 688 | 23.25 | 299.89 | 518.00 |
| on | randread_4k_qd1 | queue | read | 300 | 1,201 | 13.31 | 104.33 | 354.42 |
| on | randread_4k_qd1 | round-robin | read | 173 | 692 | 23.11 | 259.00 | 505.41 |
| on | randread_4k_qd32 | latency | read | 1,970 | 7,884 | 64.93 | 513.80 | 1,115.68 |
| on | randread_4k_qd32 | latency-rr | read | 2,498 | 9,996 | 51.21 | 358.61 | 725.62 |
| on | randread_4k_qd32 | pid | read | 2,786 | 11,162 | 45.91 | 316.67 | 624.95 |
| on | randread_4k_qd32 | queue | read | 3,394 | 13,619 | 37.69 | 204.47 | 358.61 |
| on | randread_4k_qd32 | round-robin | read | 2,886 | 11,571 | 44.33 | 275.00 | 768.00 |
| on | seqread_1M_qd16 | latency | read | 577 | 590,848 | 110.65 | 860.00 | 2,500.00 |
| on | seqread_1M_qd16 | latency-rr | read | 518 | 530,432 | 123.08 | 676.00 | 1,838.00 |
| on | seqread_1M_qd16 | pid | read | 488 | 500,736 | 130.76 | 760.00 | 1,888.00 |
| on | seqread_1M_qd16 | queue | read | 576 | 590,848 | 110.81 | 684.00 | 1,921.00 |
| on | seqread_1M_qd16 | round-robin | read | 557 | 570,368 | 114.56 | 676.00 | 1,804.00 |

### SSD RAID10, 1 job (`ssd-raid10-jobs1.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 5,495 | 22,016 | 0.18 | 0.39 | 0.44 |
| off | randread_4k_qd1 | latency-rr | read | 4,683 | 18,739 | 0.21 | 0.40 | 0.45 |
| off | randread_4k_qd1 | pid | read | 4,841 | 19,354 | 0.21 | 0.40 | 5.67 |
| off | randread_4k_qd1 | queue | read | 5,366 | 21,504 | 0.19 | 0.40 | 0.44 |
| off | randread_4k_qd1 | round-robin | read | 5,169 | 20,685 | 0.19 | 0.40 | 0.44 |
| off | randread_4k_qd32 | latency | read | 142,000 | 569,344 | 0.22 | 0.31 | 0.40 |
| off | randread_4k_qd32 | latency-rr | read | 137,000 | 547,840 | 0.23 | 0.33 | 0.45 |
| off | randread_4k_qd32 | pid | read | 68,800 | 275,456 | 0.46 | 8.03 | 10.29 |
| off | randread_4k_qd32 | queue | read | 143,000 | 571,392 | 0.22 | 0.46 | 0.59 |
| off | randread_4k_qd32 | round-robin | read | 143,000 | 572,416 | 0.22 | 0.34 | 0.63 |
| off | seqread_1M_qd16 | latency | read | 2,839 | 2,908,160 | 5.63 | 7.70 | 10.42 |
| off | seqread_1M_qd16 | latency-rr | read | 2,924 | 2,995,200 | 5.47 | 7.77 | 11.47 |
| off | seqread_1M_qd16 | pid | read | 2,594 | 2,657,280 | 6.17 | 9.63 | 15.53 |
| off | seqread_1M_qd16 | queue | read | 5,411 | 5,540,864 | 2.96 | 3.92 | 5.54 |
| off | seqread_1M_qd16 | round-robin | read | 5,316 | 5,443,584 | 3.01 | 4.29 | 6.85 |
| on | randread_4k_qd1 | latency | read | 1,193 | 4,772 | 0.84 | 8.85 | 82.31 |
| on | randread_4k_qd1 | latency-rr | read | 1,264 | 5,057 | 0.79 | 8.59 | 78.12 |
| on | randread_4k_qd1 | pid | read | 2,853 | 11,366 | 0.35 | 2.97 | 19.01 |
| on | randread_4k_qd1 | queue | read | 2,046 | 8,185 | 0.49 | 4.42 | 35.91 |
| on | randread_4k_qd1 | round-robin | read | 1,399 | 5,598 | 0.71 | 6.98 | 69.73 |
| on | randread_4k_qd32 | latency | read | 50,100 | 200,704 | 0.64 | 5.34 | 70.78 |
| on | randread_4k_qd32 | latency-rr | read | 64,200 | 257,024 | 0.50 | 4.49 | 41.68 |
| on | randread_4k_qd32 | pid | read | 66,500 | 266,240 | 0.48 | 4.05 | 44.30 |
| on | randread_4k_qd32 | queue | read | 88,600 | 354,304 | 0.36 | 2.31 | 27.66 |
| on | randread_4k_qd32 | round-robin | read | 45,000 | 180,224 | 0.71 | 7.83 | 86.51 |
| on | seqread_1M_qd16 | latency | read | 1,695 | 1,735,680 | 9.44 | 58.98 | 270.53 |
| on | seqread_1M_qd16 | latency-rr | read | 2,365 | 2,422,784 | 6.76 | 25.00 | 71.00 |
| on | seqread_1M_qd16 | pid | read | 1,428 | 1,463,296 | 11.20 | 109.58 | 210.76 |
| on | seqread_1M_qd16 | queue | read | 3,801 | 3,893,248 | 4.21 | 23.99 | 107.48 |
| on | seqread_1M_qd16 | round-robin | read | 2,453 | 2,512,896 | 6.52 | 66.32 | 191.89 |

### SSD RAID10, 4 jobs (`ssd-raid10-jobs4.tar.xz`)

| Defrag | Test | Policy | Dir | IOPS | BW (KiB/s) | Avg lat (ms) | 99% (ms) | 99.9% (ms) |
|---|---|---|---|---:|---:|---:|---:|---:|
| off | randread_4k_qd1 | latency | read | 29,900 | 119,808 | 0.13 | 0.20 | 0.25 |
| off | randread_4k_qd1 | latency-rr | read | 29,300 | 116,736 | 0.14 | 0.20 | 0.27 |
| off | randread_4k_qd1 | pid | read | 24,200 | 96,768 | 0.16 | 0.31 | 8.09 |
| off | randread_4k_qd1 | queue | read | 29,500 | 117,760 | 0.13 | 0.20 | 0.24 |
| off | randread_4k_qd1 | round-robin | read | 29,000 | 115,712 | 0.14 | 0.20 | 0.26 |
| off | randread_4k_qd32 | latency | read | 436,000 | 1,744,896 | 0.29 | 0.84 | 1.56 |
| off | randread_4k_qd32 | latency-rr | read | 428,000 | 1,710,080 | 0.30 | 0.67 | 1.63 |
| off | randread_4k_qd32 | pid | read | 227,000 | 910,336 | 0.56 | 8.29 | 10.55 |
| off | randread_4k_qd32 | queue | read | 408,000 | 1,631,232 | 0.31 | 0.86 | 1.42 |
| off | randread_4k_qd32 | round-robin | read | 447,000 | 1,789,952 | 0.29 | 0.72 | 1.78 |
| off | seqread_1M_qd16 | latency | read | 2,877 | 2,946,048 | 22.24 | 33.42 | 36.44 |
| off | seqread_1M_qd16 | latency-rr | read | 3,708 | 3,796,992 | 17.24 | 29.00 | 35.00 |
| off | seqread_1M_qd16 | pid | read | 4,746 | 4,859,904 | 13.48 | 26.87 | 39.06 |
| off | seqread_1M_qd16 | queue | read | 5,880 | 6,022,144 | 10.86 | 16.00 | 236.00 |
| off | seqread_1M_qd16 | round-robin | read | 5,750 | 5,889,024 | 11.13 | 17.43 | 19.79 |
| on | randread_4k_qd1 | latency | read | 7,058 | 28,262 | 0.57 | 5.93 | 52.69 |
| on | randread_4k_qd1 | latency-rr | read | 5,525 | 22,118 | 0.72 | 8.09 | 61.60 |
| on | randread_4k_qd1 | pid | read | 13,600 | 54,579 | 0.29 | 2.51 | 12.78 |
| on | randread_4k_qd1 | queue | read | 9,965 | 39,834 | 0.40 | 3.46 | 37.49 |
| on | randread_4k_qd1 | round-robin | read | 10,300 | 40,960 | 0.39 | 3.59 | 26.08 |
| on | randread_4k_qd32 | latency | read | 160,000 | 640,000 | 0.80 | 7.96 | 45.88 |
| on | randread_4k_qd32 | latency-rr | read | 175,000 | 701,440 | 0.73 | 7.83 | 45.35 |
| on | randread_4k_qd32 | pid | read | 260,000 | 1,038,336 | 0.49 | 4.15 | 18.74 |
| on | randread_4k_qd32 | queue | read | 287,000 | 1,147,904 | 0.45 | 2.90 | 34.34 |
| on | randread_4k_qd32 | round-robin | read | 177,000 | 708,608 | 0.72 | 7.83 | 48.50 |
| on | seqread_1M_qd16 | latency | read | 2,729 | 2,795,520 | 23.44 | 40.63 | 56.89 |
| on | seqread_1M_qd16 | latency-rr | read | 2,969 | 3,041,280 | 21.55 | 48.00 | 91.00 |
| on | seqread_1M_qd16 | pid | read | 4,258 | 4,361,216 | 15.02 | 46.00 | 92.00 |
| on | seqread_1M_qd16 | queue | read | 5,026 | 5,147,648 | 12.72 | 42.00 | 201.00 |
| on | seqread_1M_qd16 | round-robin | read | 5,276 | 5,402,624 | 12.12 | 23.00 | 136.00 |

## Notes

The tables in the gist comment and in the guide were generated by an
assistant (the comment says so) and differ from the raw data in places,
e.g. in the average latencies; the tables above come from the raw files.
The guide also shows an SSD RAID1 setup (the RAID10 file system converted
to RAID1); there is no raw data for it here, see the [guide][wiki]. In the
gist discussion, `queue` came out ahead for nearly all reads and `pid`
for writes. File system UUIDs in the raw data are replaced by `<fsid>`.

[gist-5571411]: https://gist.github.com/kakra/ce99896e5915f9b26d13c5637f56ff37?permalink_comment_id=5571411#gistcomment-5571411
[wiki]: https://wiki.tnonline.net/w/Btrfs/Allocator_Hints#Benchmarks
[pr-36]: https://github.com/kakra/linux/pull/36
