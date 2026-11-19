# observations

## Purpose

Dated notes per kernel series on how the system behaves in daily use, to
notice changes over time and relate them to a change. `README.md`
describes the format for readers.

## Ownership

- `<version>.md`: one file per kernel series, sections per system state
  (kernel and installed series). Reports of other people go into the file
  of the series whose patch state they use; each entry names its author,
  links the source and names the kernel of the reporter, as far as known.

## Local Contracts

- Each entry names the date and the system state (`tools/state.sh`), what
  was noticed compared with before, and the suspected cause marked as a
  guess unless it was checked.
- Add follow-ups and corrections as new bullets; do not rewrite old
  entries. Link benchmarks that confirm or refute an observation.
- No UUIDs, host names or user names.

## Work Guidance

- The aim is to see whether the system feels better or worse and after
  which change, not to prove every effect.

## Verification

None.

## Child DOX Index

None.
