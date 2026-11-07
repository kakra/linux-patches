# tools

## Purpose

Scripts that pin, export, check and test-build the series, and the
benchmark helpers in `tools/bench/`.

## Ownership

- `tools/*.sh`: series management (`lib.sh`, `add-series.sh`,
  `drop-series.sh`, `export-series.sh`), checks (`check-series.sh`,
  `check-matrix.sh`), test builds (`ci-build.sh`) and `state.sh`.
- `tools/bench/`: benchmark scripts and their summaries; their results
  belong to `benchmarks/`.
- The Kconfig fragments used by `ci-build.sh` are owned by `configs/`.

## Local Contracts

- Bash with `set -euo pipefail` (`state.sh` without `-e`: missing values
  are reported as `n/a`). Series scripts source `lib.sh` and find the
  repository through `git rev-parse --show-toplevel`.
- The kernel clone comes from the local config `linux-patches.clone`;
  submodule checkouts are worktrees of it. No script clones the kernel
  history except `ci-build.sh`, which clones the base tag shallowly.
- Scripts never commit, push or touch branches of the kernel clone.
  `add-series.sh` and `drop-series.sh` only edit `.gitmodules` and stage
  the pin; temporary files go to `build/`.
- Output written into the repository is generated and reproducible:
  `export-series.sh` uses `--zero-commit --no-signature --no-numbered`.
- `state.sh` and the benchmark scripts print no UUIDs, machine ids, host
  or user names: replace them with placeholders.
- Benchmark scripts that need root say so and are run by the maintainer.

## Work Guidance

- Keep the usage comment at the top of each script current; it is the
  documentation.
- A new check or helper gets its own script and commit.

## Verification

- `bash -n tools/*.sh tools/bench/*.sh` and
  `python3 -I -m py_compile tools/bench/fio-summary.py`
- `tools/check-series.sh <version>` for exports,
  `tools/check-matrix.sh <branch>...` for independence,
  `tools/ci-build.sh <version> [<name>...]` for builds

## Child DOX Index

None.
