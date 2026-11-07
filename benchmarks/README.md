# Benchmarks

Measurements of the series, one directory per run or published data set:
`benchmarks/<date>-<topic>/`. The date is the day of the measurement.

Each directory has a `README.md` following [TEMPLATE.md](TEMPLATE.md):
system, kernel and series state, exact commands, results, and where the
data comes from. Raw data is kept next to it, compressed with `xz`.

The goal is to see changes over time and relate them to a change in the
kernel or in a series, not to prove every effect. A run that is repeated
later with the same script on the same system is the most useful kind of
entry.

Rules:

- Scripts live in `tools/bench/`. Results name the script and its
  revision (the commit of this repository).
- Results of other people keep their author and link the original
  source. Tables generated from raw data are marked as such.
- Raw data and logs contain no host names, home paths, user names, serial
  numbers, MAC addresses or file system UUIDs. File system UUIDs are
  replaced by `<fsid>`.
