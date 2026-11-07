# Agent instructions

This repository pins and exports the maintainer's Linux kernel patch series.
Read `README.md` for the overview and `docs/workflow.md` for the branch
rules.

## Rules

- Everything in this repository is English: docs, scripts, commit messages.
  Write documentation neutrally, not from an assistant's point of view.
- Small, atomic commits. One topic per commit (one script, one series
  export, one history section). Commit messages follow the scheme below.
- Never push, never open issues or pull requests, never move or delete
  branches of the kernel clone or the fork without asking the maintainer.
  `main` of this repository is never force-pushed.
- The patch code lives in the kernel branches, not here. Change a patch on
  its branch, then re-export; never edit the generated files in
  `patches/` by hand.
- Exported series of older kernel series are history: do not change
  `patches/<older version>/`.
- Only pin and export states that are pushed to the fork and tracked by a
  pull request. Experiments and local variants stay out.
- Authorship: a series keeps the original authors of its commits. Do not
  mix authorship within a commit.
- Pull requests and issues: in Markdown files, link them with
  reference-style links (`PR [#40][pr-40]`, the URL at the end of the
  file). In commit messages, write them as plain text without URL or `#`,
  in a list at the end (`- kakra/linux PR 40`). GitHub adds a timeline
  entry for every pushed commit that links a pull request, and the kernel
  branches are force-pushed often. Commits are referenced by hash only.
- Report results as measured. A series that was only checked to apply is
  "applies, not built"; one that was built but not booted is "built, not
  tested".

## Commit messages

```
<area>: <summary>

<What changed and why, wrapped at 72 columns.>

References:
- kakra/linux PR 40

Co-Authored-By: ...
```

- `<area>` is one of `repo` (top-level files such as README, LICENSE,
  HISTORY.md, AGENTS.md), `series` (submodule entries without an export,
  e.g. dropping a series), `patches` (an export together with its pin),
  `tools`, `docs`.
- The summary is imperative and lower case, without a final period, and the
  whole subject line has at most 72 characters.
- The `References:` list is optional and plain text (see the rule above).
- Exports use the message written by `tools/export-series.sh --summary`.

## Workflow

- Setup once: `git config linux-patches.clone /path/to/linux` (the kernel
  clone that holds all branches). The submodule checkouts are worktrees of
  that clone; see `docs/workflow.md`.
- Export after changing a branch: `tools/export-series.sh --summary <name>`,
  review `git diff --stat patches/`, stage the pin
  (`git add series/<name>`) and commit with `build/export-message.txt`.
- Check that a series applies to its base, or to another tag:
  `tools/check-series.sh [--on <tag>] <version> [<name>...]`.
- A series moves to a new kernel series with `tools/add-series.sh`, a series
  that is given up is removed with `tools/drop-series.sh`. Describe both in
  `HISTORY.md`.
