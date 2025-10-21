This repository contains the LaTeX3 (expl3) development source. The
goal of these instructions is to give an AI coding agent the concise,
actionable project knowledge needed to edit, test and extend the codebase.

Key facts (big picture)
- Major components: `l3kernel` (stable API), `l3backend` (driver-level),
  `l3packages` (packages built on top of expl3), `l3experimental` and
  `l3trial` (work-in-progress). See `README.md` for an overview.
- Source format: most code is authored in literate `.dtx` files (e.g.
  `l3kernel/l3box.dtx`, `l3packages/xparse/xparse.dtx`). Generated artifacts
  (sty/ltx) come from `.ins`/docstrip rules.

Build, test and CI workflows (how to run things locally)
- Primary test/build tool: l3build. Typical commands:
  - Run full test suite: `l3build check -q -H --show-log-on-error`
  - Build documentation: `l3build doc -q -H`
  - Prepare CTAN package: `l3build ctan -q -H`
  Config is in `build-config.lua` and per-bundle `config-*.lua` files
  (see `l3kernel/config-*.lua`) which define `checkengines`, `testfiledir`,
  and special formats.
- CI: GitHub Actions runs `l3build` (see `.github/workflows/main.yaml` and
  `.github/workflows/deploy.yaml`). Actions install TeX Live using
  `.github/tl_packages` and rely on `ghostscript` for some backends.

Project-specific conventions and patterns
- Engine matrix: tests run across multiple engines (pdftex, xetex, luatex,
  uptex). Per-bundle `config-*.lua` override `checkengines` (example:
  `l3backend/config-backend.lua`).
- Tests: test files live in bundle-specific `testfiles*` directories and are
  referenced via `\TestFiles{...}` inside `.dtx` files (see `l3kernel/l3doc.dtx`).
- File layout: prefer editing the originating `.dtx` file. `.ins` files
  express docstrip rules; generated `.sty`/`.ltx` files should not be edited
  directly (they are derived).
- Version/tagging: `l3build` and `build-config.lua` handle tag updates
  (see `update_tag` hooks) — avoid manual edits to release metadata.

Integration points & external deps
- External tools: TeX Live (many packages), Ghostscript, extractbb, and
  system metafont/mfware for some tests. The required TeX packages are listed
  in `.github/tl_packages` used by CI. Local developers should have a recent
  TeX Live installation for reproducible results.
- l3build hooks: the project uses hooks (`checkinit_hook`, `docinit_hook`)
  to build formats or set runtime options (see `build-config.lua`). When
  changing build behavior, update these hooks.

Examples to cite when making edits
- To add or change an expl3 API function: edit the appropriate `.dtx` in
  `l3kernel/` and add a `\TestFiles{...}` entry if tests are needed
  (for example, `l3kernel/l3box.dtx`).
- To add CI/test coverage for a bundle, update or add `config-*.lua` to set
  `checkengines` and `testfiledir`, and add tests under the matching
  `testfiles*` directory.

What not to do
- Do not alter generated files produced by docstrip (`*.sty`, `*.ltx`) —
  change the originating `.dtx`/`.ins` instead.
- Avoid assuming a single TeX engine — tests run multi-engine and code
  should be engine-agnostic where possible.

Pointers for agents
- When proposing code changes, include the specific `.dtx` path, the
  testfile name under `testfiles*`, and the `l3build` command used to
  validate the change. Example: "Edited `l3kernel/l3box.dtx`; added
  `testfiles/m3box005.lvt`; command: `l3build check -q -H --show-log-on-error`."
- Prefer minimal, well-scoped patches touching the `.dtx` and testfiles.

If anything above is unclear or you'd like more detail on a particular
bundle (for example `l3backend` build hooks or `l3experimental` layout),
ask and I'll expand the instructions with bundle-specific examples.
