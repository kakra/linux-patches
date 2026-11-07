# benchmarks

## Purpose

Benchmark runs and published results, one directory per run or data set,
to see changes over time and relate them to a kernel or series change.
`README.md` describes the layout for readers.

## Ownership

- `<date>-<topic>/README.md` and its raw data; `TEMPLATE.md`.
- The scripts that produce the data are owned by `tools/bench/`.

## Local Contracts

- Each entry follows `TEMPLATE.md`: system, kernel and series state,
  exact commands, results, source.
- Tables are generated from the raw data (`tools/bench/fio-summary.py`),
  not copied from posts; tables of others without raw data are marked as
  theirs.
- Raw data is compressed with `xz`. File system UUIDs become `<fsid>`; no
  host names, home paths, user names, serial or MAC addresses, also
  inside archives.
- Results of other people keep their author and link the original
  source; content under another license (e.g. CC BY-SA) is linked, not
  copied.

## Work Guidance

- Prefer repeating an existing benchmark with the same script over a new
  one, so runs stay comparable.

## Verification

- Re-run `tools/bench/fio-summary.py` on the raw data and compare with the
  tables.

## Child DOX Index

None.
