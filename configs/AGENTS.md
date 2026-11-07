# configs

## Purpose

Kconfig fragments for the test builds of `tools/ci-build.sh`.

## Ownership

- `base.config`: options for every test build (64-bit, since tinyconfig
  is 32-bit on x86).
- `<name>.config`: the options series `<name>` needs to compile its code.

## Local Contracts

- One fragment per active series, named after the series.
- Only `CONFIG_<x>=y` lines; `ci-build.sh` fails when one of them is not
  set after `olddefconfig`, so every dependency must be listed.
- A comment explains each option that is only there to satisfy a
  dependency of the series (e.g. `SYSCTL` for le9uo).

## Work Guidance

None.

## Verification

- `tools/ci-build.sh <version> <name>` builds the series alone,
  `tools/ci-build.sh <version>` all of them together.

## Child DOX Index

None.
