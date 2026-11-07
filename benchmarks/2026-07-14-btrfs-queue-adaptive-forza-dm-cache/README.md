# queue against queue-adaptive on dm-cache HDD RAID1 (ForzaTNG)

- Date: 2026-07-14
- Author: ForzaTNG
- Source: PR [#40][pr-40], comment of 2026-07-14, with Kai Krakow's
  reading of the latency distribution on 2026-07-15

## System

btrfs RAID1 on four HDDs, each behind dm-cache on SATA SSDs.

## Kernel and series

6.18 with the btrfs series of PR [#40][pr-40] after the update of
2026-07-10: the `queue` policy breaks ties by mirror age ("v2"), and the new
`queue-adaptive` policy adds a latency guard.

## Steps

One fio run per policy:

```
fio --name=randread --ioengine=io_uring --iodepth=16 --rw=randread --bs=4k \
    --direct=1 --size=4096M --numjobs=4 --runtime=240 --group_reporting
```

## Results

From the fio output posted in the comment (completion latency
percentiles in µs):

| Policy | IOPS | BW (MiB/s) | Avg lat (µs) | 99.00th | 99.50th | 99.90th | 99.95th | 99.99th | max (ms) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| queue (v2) | 227k | 885 | 281 | 502 | 1037 | 3884 | 5604 | 21365 | 138 |
| queue-adaptive | 236k | 922 | 269 | 363 | 400 | 1860 | 3621 | 16712 | 30 |

## Notes

ForzaTNG: `queue-adaptive` didn't add much here, likely because the SSD
cache on the SATA bus was the limit. The averages are close, but the tail
is clearly shorter with `queue-adaptive`: the 99.5th percentile drops from
about 1 ms to 0.4 ms, the 99.9th from 3.9 ms to 1.9 ms, and the maximum
from 138 ms to 30 ms. That is the point Kai Krakow made in the follow-up
comment of 2026-07-15.

[pr-40]: https://github.com/kakra/linux/pull/40
