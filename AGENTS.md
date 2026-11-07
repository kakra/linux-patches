# Agent instructions

This repository pins and exports the maintainer's Linux kernel patch series.
Read `README.md` for the overview and `docs/workflow.md` for the branch
rules.

## DOX framework

- DOX is highly performant AGENTS.md hierarchy installed here
- Agent must follow DOX instructions across any edits

### Core Contract

- AGENTS.md files are binding work contracts for their subtrees
- Work products, source materials, instructions, records, assets, and durable docs must stay understandable from the nearest applicable AGENTS.md plus every parent AGENTS.md above it

### Read Before Editing

1. Read the root AGENTS.md
2. Identify every file or folder you expect to touch
3. Walk from the repository root to each target path
4. Read every AGENTS.md found along each route
5. If a parent AGENTS.md lists a child AGENTS.md whose scope contains the path, read that child and continue from there
6. Use the nearest AGENTS.md as the local contract and parent docs for repo-wide rules
7. If docs conflict, the closer doc controls local work details, but no child doc may weaken DOX

Do not rely on memory. Re-read the applicable DOX chain in the current session before editing.

### Update After Editing

Every meaningful change requires a DOX pass before the task is done.

Update the closest owning AGENTS.md when a change affects:

- purpose, scope, ownership, or responsibilities
- durable structure, contracts, workflows, or operating rules
- required inputs, outputs, permissions, constraints, side effects, or artifacts
- user preferences about behavior, communication, process, organization, or quality
- AGENTS.md creation, deletion, move, rename, or index contents

Update parent docs when parent-level structure, ownership, workflow, or child index changes. Update child docs when parent changes alter local rules. Remove stale or contradictory text immediately. Small edits that do not change behavior or contracts may leave docs unchanged, but the DOX pass still must happen.

### Hierarchy

- Root AGENTS.md is the DOX rail: project-wide instructions, global preferences, durable workflow rules, and the top-level Child DOX Index
- Child AGENTS.md files own domain-specific instructions and their own Child DOX Index
- Each parent explains what its direct children cover and what stays owned by the parent
- The closer a doc is to the work, the more specific and practical it must be

### Child Doc Shape

- Create a child AGENTS.md when a folder becomes a durable boundary with its own purpose, rules, responsibilities, workflow, materials, or quality standards
- Work Guidance must reflect the current standards of the project or user instructions; if there are no specific standards or instructions yet, leave it empty
- Verification must reflect an existing check; if no verification framework exists yet, leave it empty and update it when one exists

Default section order:
- Purpose
- Ownership
- Local Contracts
- Work Guidance
- Verification
- Child DOX Index

### Style

- Keep docs concise, current, and operational
- Document stable contracts, not diary entries
- Put broad rules in parent docs and concrete details in child docs
- Prefer direct bullets with explicit names
- Do not duplicate rules across many files unless each scope needs a local version
- Delete stale notes instead of explaining history
- Trim obvious statements, repeated rules, misplaced detail, and warnings for risks that no longer exist

### Closeout

1. Re-check changed paths against the DOX chain
2. Update nearest owning docs and any affected parents or children
3. Refresh every affected Child DOX Index
4. Remove stale or contradictory text
5. Run existing verification when relevant
6. Report any docs intentionally left unchanged and why

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
- Only pin and export states that are, or will be, pushed to the fork and
  tracked by a pull request: push the kernel branches before this
  repository. Experiments and local variants stay out.
- Authorship: a series keeps the original authors of its commits. Do not
  mix authorship within a commit.
- Commits on the kernel branches follow
  `Documentation/process/coding-assistants.rst`: an assistant adds an
  `Assisted-by: Claude` trailer to commits it wrote or changed (a new
  commit, a conflict resolution with a `[Rebased onto ...]` note) and never
  a `Signed-off-by`, no `Co-Authored-By` either. The maintainer adds his
  own `Signed-off-by` after review. The kernel clone has a
  `prepare-commit-msg` hook that adds it automatically, so commit there
  with `git -c core.hooksPath=/dev/null` as an assistant.
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
  `base` (the pin of the `base/` submodule), `tools` (including
  `configs/`), `docs`, `benchmarks`, `observations`, `github` (the
  workflows in `.github/`).
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
- Test-build exports on tinyconfig plus `configs/<name>.config`:
  `tools/ci-build.sh <version> [<name>...]` (the GitHub workflow runs each
  series alone and all together). Add the options a new series needs to
  its fragment.
- Check that a series applies to its base, or to another tag:
  `tools/check-series.sh [--on <tag>] <version> [<name>...]`.
- A series moves to a new kernel series with `tools/add-series.sh`, a series
  that is given up is removed with `tools/drop-series.sh`. Describe both in
  `HISTORY.md`.

## User Preferences

- Plan with the maintainer before larger changes and ask back when a
  decision is open; work in small, atomic commits.
- Nothing is pushed before the maintainer has reviewed it (also with a
  second review tool).
- Kernel branches: only patches that apply independently of the other
  series; series are cut by purpose (`platform` for servers and desktops,
  `gaming` for desktop and gaming), with patches fetched from their
  upstream projects in their newest revision. Patches that their upstream
  dropped are dropped too, unless they are kept for another reason.
- Observations and benchmarks are for seeing changes over time and their
  likely cause, not for proving every effect.

## Child DOX Index

- `tools/AGENTS.md`: scripts for pinning, exporting, checking and
  test-building series, `state.sh`, and the benchmark scripts in
  `tools/bench/`.
- `configs/AGENTS.md`: Kconfig fragments of the test builds.
- `patches/AGENTS.md`: the generated exports per kernel series.
- `benchmarks/AGENTS.md`: benchmark runs and published results with raw
  data.
- `observations/AGENTS.md`: dated notes per kernel series.

Owned by this file: the top-level files (`README.md`, `HISTORY.md`,
`LICENSE`, `.gitmodules`), `docs/`, `.github/` and the submodule pins
`base/` and `series/<name>/`. The submodules are kernel worktrees and get
no AGENTS.md files.
