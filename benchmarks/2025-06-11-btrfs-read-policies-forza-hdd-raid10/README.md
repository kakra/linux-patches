# btrfs read policies on HDD RAID10 (ForzaTNG)

- Date: 2025-06-11 (posted)
- Author: ForzaTNG
- Source: gist comment of 2025-06-11 ([gist][gist-5613616])
- Script: `benchmark-read-policies.sh` of the gist

## System

The server of [2025-05-04](../2025-05-04-btrfs-read-policies-forza/), with
the HDD file system converted from RAID1 to RAID10.

## Kernel and series

6.12 with the btrfs series of PR [#36][pr-36] as of mid 2025.

## Steps

The tests of the original script with 1 and 4 fio jobs, with and without a
background defrag.

## Results

ForzaTNG's tables as posted; there is no raw data for this run.

Hi @kakra, Here are some results from the same system as before, but now in a HDD RAID10 configuration instead of RAID1.
### Defrag OFF
| Storage     | Jobs | Test                | Policy      |  IOPS | BW (KiB/s) | Avg Lat (ms) | 99 % Lat (ms) | 99.9 % Lat (ms) |
|-------------|------|---------------------|-------------|------:|-----------:|-------------:|--------------:|----------------:|
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | latency     |   475 |       1904 |        8.383 |        27.395 |          38.536 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | latency-rr  |   460 |       1843 |        8.660 |        27.395 |          41.157 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | pid         |   486 |       1948 |        8.102 |        25.035 |          41.157 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | queue       |   537 |       2151 |        7.417 |        22.938 |          32.370 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | round-robin |   453 |       1814 |        8.800 |        28.443 |          39.584 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | latency     |  2792 |      11161 |       45.813 |       316.670 |         608.175 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | latency-rr  |  3314 |      13209 |       38.580 |       283.116 |         683.672 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | pid         |  3200 |      12800 |       39.795 |       214.959 |         392.168 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | queue       |  3884 |      15564 |       32.913 |       191.890 |         354.419 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | round-robin |  3687 |      14745 |       34.669 |       191.890 |         346.031 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | latency     |   985 |    1008640 |       62.662 |         0.326 |           0.894 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | latency-rr  |   964 |     987136 |       65.056 |         0.409 |           0.969 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | pid         |  1465 |    1500160 |       43.116 |         0.372 |           2.433 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | queue       |  1044 |    1070080 |       59.451 |       367.002 |         734.004 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | round-robin |   869 |     890880 |       71.724 |         0.527 |           1.418 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | latency     |   162 |        650 |        6.130 |        17.695 |          22.676 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | latency-rr  |   133 |        535 |        7.452 |        26.084 |          34.341 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | pid         |   140 |        561 |        7.028 |        22.938 |          31.327 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | queue       |   148 |        594 |        6.716 |        21.103 |          28.443 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | round-robin |   141 |        565 |        6.937 |        22.414 |          30.802 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | latency     |  1066 |       4264 |       29.332 |       132.710 |         193.177 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | latency-rr  |  1205 |       4821 |       25.948 |       122.779 |         178.171 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | pid         |  1155 |       4620 |       27.047 |       118.550 |         171.776 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | queue       |  1313 |       5256 |       23.866 |       112.442 |         162.071 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | round-robin |  1263 |       5053 |       24.825 |       114.688 |         165.176 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | latency     |   217 |     222208 |       72.866 |         0.343 |           0.841 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | latency-rr  |   219 |     224256 |       71.869 |         0.325 |           0.894 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | pid         |   257 |     263168 |       61.038 |         0.293 |           0.805 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | queue       |   243 |     248832 |       64.638 |         0.312 |           0.860 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | round-robin |   239 |     244736 |       65.643 |         0.314 |           0.853 |

### Defrag ON
| Storage     | Jobs | Test                | Policy      |  IOPS | BW (KiB/s) | Avg Lat (ms) | 99 % Lat (ms) | 99.9 % Lat (ms) |
|-------------|------|---------------------|-------------|------:|-----------:|-------------:|--------------:|----------------:|
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | latency     |   267 |       1069 |       14.930 |        82.314 |         132.645 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | latency-rr  |   260 |       1042 |       15.254 |        73.925 |         123.208 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | pid         |   283 |       1134 |       14.003 |        83.362 |         131.597 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | queue       |   309 |       1236 |       12.909 |        67.634 |         114.820 |
| HDD RAID10  | 4    | RandRead 4 KiB QD1  | round-robin |   251 |       1007 |       15.787 |        85.459 |         132.645 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | latency     |  2072 |       8291 |       60.783 |       387.974 |         784.335 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | latency-rr  |  2011 |       8048 |       62.175 |         0.321 |           0.527 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | pid         |  2632 |      10547 |       47.840 |       265.290 |         442.500 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | queue       |  2254 |       9018 |       55.400 |         0.226 |           0.376 |
| HDD RAID10  | 4    | RandRead 4 KiB QD32 | round-robin |  2257 |       9029 |       55.573 |       295.699 |         501.220 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | latency     |   908 |     929792 |       68.699 |         0.359 |           0.676 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | latency-rr  |   797 |     816128 |       77.247 |         0.493 |           0.927 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | pid         |  1386 |    1420288 |       45.259 |         0.376 |           1.150 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | queue       |   840 |     861184 |       72.758 |       392.168 |         742.392 |
| HDD RAID10  | 4    | SeqRead 1 MiB QD16  | round-robin |   718 |     736256 |       85.469 |         0.676 |           1.871 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | latency     |    63 |        253 |       15.789 |        82.314 |         132.645 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | latency-rr  |    67 |        269 |       14.821 |        72.877 |         120.062 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | pid         |    64 |        257 |       15.426 |        88.605 |         141.558 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | queue       |    75 |        304 |       13.142 |        55.837 |         112.722 |
| HDD RAID10  | 1    | RandRead 4 KiB QD1  | round-robin |    64 |        258 |       15.456 |        87.557 |         124.257 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | latency     |  1643 |       6576 |       19.262 |       103.285 |         183.501 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | latency-rr  |  1662 |       6651 |       19.084 |        99.091 |         185.598 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | pid         |  1579 |       6318 |       20.164 |       145.753 |         299.893 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | queue       |  1893 |       7575 |       16.795 |        76.022 |         127.402 |
| HDD RAID10  | 1    | RandRead 4 KiB QD32 | round-robin |  1569 |       6278 |       20.193 |        94.897 |         164.627 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | latency     |   911 |     932864 |       17.242 |         0.082 |           0.178 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | latency-rr  |   763 |     781312 |       20.526 |         0.097 |           0.255 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | pid         |   894 |     915456 |       17.650 |         0.085 |           0.169 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | queue       |   728 |     746496 |       21.423 |       100.140 |         175.113 |
| HDD RAID10  | 1    | SeqRead 1 MiB QD16  | round-robin |   638 |     654336 |       24.144 |         0.130 |           0.292 |

## Notes

For sequential reads on RAID10, `pid` had the highest throughput with 4 jobs
(1465 IOPS against 1044 for `queue` without defrag), and `queue` showed
99.9th percentile latencies of 734 to 742 ms with 4 jobs and 175 ms with 1
job and defrag, where the other policies stayed below about 2.5 ms. The
table is ForzaTNG's own; it may not be generated from raw data the same
way as the tables of the other runs.

[gist-5613616]: https://gist.github.com/kakra/ce99896e5915f9b26d13c5637f56ff37?permalink_comment_id=5613616#gistcomment-5613616
[pr-36]: https://github.com/kakra/linux/pull/36
