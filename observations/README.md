# Observations

How the system feels in daily use, per kernel series: `observations/<version>.md`.
These are notes, not measurements. They exist to notice changes over time
and to relate them to a change: a new kernel, a series added or updated, a
setting changed.

Each entry has:

- the date and the system state (kernel, installed series and their
  revisions, relevant settings; `tools/state.sh` prints them),
- what was noticed, compared with what before,
- the suspected cause, marked as a guess unless it was checked,
- a follow-up if one is planned (a benchmark in `benchmarks/`, a setting
  to toggle).

When an observation is confirmed or refuted by a measurement, add a note
with a link to the benchmark instead of rewriting the entry.
