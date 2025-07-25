# Changelog
All notable changes to the `l3experimental` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

## [2025-06-30]

### Changed
- Add `set` into function names for adjusting drawing state, e.g.
  `\draw_set_linewidth:n` replacing `\draw_linewidth:n`

### Removed
- `l3str-format` package: integrated into `l3kernel`

## [2025-05-26]

### Removed
- `\draw_hidden_(begin|end):`

## [2025-04-14]

### Removed
- `l3benchmark` package: integrated into `l3kernel`
- `l3opacity` package: integrated into `l3kernel`

## [2025-03-26]

### Added
- `\g_draw_bb_xmin_dim`, `\g_draw_bb_ymin_dim`, `\g_draw_bb_xmax_dim`,
  `\g_draw_bb_ymax_dim`
- `\g_draw_id_int`

### Removed
- `l3graphics` package: integrated into `l3kernel`

## [2025-03-10]

### Added
- `\draw_hidden_(begin|end):`

### Changed
- Adjust `l3galley` version of `\clearpage` based on new insight into
  need for some lines in LaTeX2e version (see issue \#431)

## [2024-03-14]

### Added
- `\draw_path_replace_bb:`

### Changed
- `l3opacity` is sped up a bit
- Support fp expr in `\draw_path_corner_arc:nn`

### Fixed
- Interaction between drawing rotation and shift (issue \#1483)
- Shifting not applied to `\draw_path_rectangle:n` (issue \#1486)
- Out of boundary lines drawn by `\draw_path_grid:nnn` (issue \#1489)
- Two softpath markers with the same meaning in l3draw (issue \#1492)

### Removed
- `l3sys-shell` in favor of `l3sys-query` methods added to `l3kernel`

## [2024-02-20]

### Fixed
- Normalize `/` in `\sys_shell_split_ls:nN` on Windows: globs may use
  ``\``, return values always contain `/`
- Return paths relative to working directory in `\sys_shell_split_ls:nN` on Windows

## [2024-01-04]

### Changed
- Apply transformation matrix to drawing shifts

### Fixed
- Remove a stray scaling in `\draw_path_rectangle:nn` (issue \#1386)
- Correct baseline calculations in some `l3draw` cases (issue \#1400)

## [2023-12-08]

### Added
- `\draw_box_use:Nn` and `\draw_coffin_use:Nnnn` to allow
  placement of boxed material at an offset (issue \#1357)

### Removed
- `l3bitset`: moved to `l3kernel`

## [2023-11-01]

### Changed
- Track `expl3` core changes

## [2023-10-10]

### Changed
- Slowdown a l3benchmark slow branch code slightly to gain test suite
  robustness (issue \#1274)

## [2023-05-11]

### Changed
- Track `expl3` core changes

## [2023-04-19]

### Added
- Key `pdf-attr` to `l3graphics` for additional attribute setting

### Fixed
- Grouping in `\draw_path_arc_axes:nnnn` (see \#1195)

## [2023-03-30]

### Fixed
- 'Fallback' value used for benchmarking single op
  (see \#1182)

## [2023-01-24]

### Changed
- Track `expl3` core changes

## [2022-04-20]

### Fixed
- Finding graphics files with multiple extensions

## [2022-04-10]

### Added
- `\graphics_get_pagecount:nN(TF)`

### Changed
- Return an empty `seq` when `\sys_shell_split_ls:nN` is applied with a
  glob which matched no entries
- Heavily revise `l3graphics` to provide only necessary public interfaces

## [2022-02-05]

### Changed
- Documentation for horizontal coffin poles (see issue [\#1041](https://github.com/latex3/latex3/issues/1041))

## [2021-11-12]

### Added
- `\draw_point_intersect_line_circle:nnnnn`

## [2021-08-27]

### Changed
- Track message changes in `l3kernel`

## [2021-08-04]

### Added
- `\draw_baseline:n`
- `\draw_point:n`

## [2021-07-12]

### Added
- Module `l3opacity`

## [2021-05-27]

### Added
- `\benchmark_silent:n` and `\benchmark_once_silent:n` added to `l3benchmark`

### Changed
- store results of `l3benchmark` in documented user-level instead of private
  variables

## [2021-02-18]

### Removed
- `l3color`: moved to `l3kernel`
- `l3pdf`: moved to `l3kernel`

## [2021-02-06]

### Changed
- Use new (internal) interface for kerns

## [2021-01-29]

### Added
- New `l3bitset` module
- `\pdf_destination:nn` and `\pdf_destination_box:nn` added to l3pdf

## [2020-10-27]

### Changed
- Use Lua pseudo-primitives instead of `\directlua`

## [2020-09-24]

### Added
- Support for DeviceN color spaces

## [2020-09-11]

### Fixed
- Typos in CIELAB support

## [2020-09-01]

### Added
- Support for `Gray` color model
- Support for `hsb` color model
- Support for `wave` color model

### Changed
- Better support for color separations

### Fixed
- Integer range for `HSB` color model

## [2020-08-07]

### Changed
- Move drawing color functions to `l3color`, generalizing the approach
  with better `dvips` support (viz. `\draw_color:n` becomes `\color_select:n`,
  `\draw_color_[fill|stroke]:n` become `\color_[fill|stroke]:n`)

## [2020-07-17]

### Added
- `\color_export:nn(n)N` (see #742)
- Support for multiple color models (see #739)

### Removed
- `l3cctab`: moved to `l3kernel`

## [2020-06-18]

### Changed
- Internal color model
- Internal performance enhancements

## [2020-06-03]

### Added
- `\cctab_select:N`
- Support for `Hsb`, `HSB`, `HTML` and `RGB` color models

## [2020-05-18]

### Added
- `\pdf_object_if_exist:n(TF)`

## [2020-01-12]

### Changed
- Track `l3kernel` changes

### Fixed
- Bounding box for clipped paths (see #660)

## [2019-10-11]

### Fixed
- Error message for unknown colors (see #640)

## [2019-09-28]

### Changed
- `\sys_shell_get_pwd:N` renamed as `\sys_get_shell_pwd:N`

## [2019-09-19]

### Changed
- Various improvements to `l3cctab`

## [2019-08-25]

### Changed
- `\draw_unit_vector:n` returns a vertical vector when the length is
  zero (see #609)
- Collect `pwd` data with no `\endlinechar` (see #613)
- Default precision in `\fp_format:nn` when no style is specified

### Fixed
- Corrected behavior of catcode tables (see #610)

## [2019-07-01]

### Added
- New module `l3pdf`

### Changed
- Re-order arguments for polar points (`l3draw`)

### Removed
- `l3str-convert` module: moved to `l3kernel` (`expl3` core)

## [2019-05-28]

### Added
- New `l3graphics` module

### Fixed
- Missing `\scan_stop:` in benchmark code (fixes #577)

## [2019-05-03]

### Fixed
- Clipping of paths by `l3draw`

## [2019-03-05]

### Added
- Support for drawing layers

### Changed
- Update `l3draw` transformation names

## [2019-01-28]

### Changed
- Track `expl3` changes

## [2018-10-31]

### Added
- New module `l3cctab`

## [2018-10-26]

### Added
- New module `l3benchmark`

## [2018-08-24]

### Fixed
- Actually distribute `l3sys-shell`

## [2018-08-23]

### Added
- `CHANGELOG.md` (fixes #460)
- `l3sys-shell` for experimental shell functions

## [2018-05-12]

### Changed
- Track changes in primitive naming in `l3kernel`

## [2018-04-30]

### Changed
- Switch to ISO date format
- Improve cross-module use of internal functions

## [2018-03-05]

### Added
- Several new functions added to `l3draw`

## [2018-02-21]

### Added
- New `l3color` module using `xcolor`-like expression syntax
- New `l3draw` module, based on `pgf` layer of the TikZ system

[Unreleased]: https://github.com/latex3/latex3/compare/2025-06-30...HEAD
[2025-06-30]: https://github.com/latex3/latex3/compare/2025-05-26...2025-06-30
[2025-05-26]: https://github.com/latex3/latex3/compare/2025-04-14...2025-05-26
[2025-04-14]: https://github.com/latex3/latex3/compare/2025-03-26...2025-04-14
[2025-03-26]: https://github.com/latex3/latex3/compare/2025-03-10...2025-03-26
[2025-03-10]: https://github.com/latex3/latex3/compare/2024-03-14...2025-03-10
[2024-03-14]: https://github.com/latex3/latex3/compare/2024-02-20...2024-03-14
[2024-02-20]: https://github.com/latex3/latex3/compare/2024-01-04...2024-02-20
[2024-01-04]: https://github.com/latex3/latex3/compare/2023-12-08...2024-01-04
[2023-12-08]: https://github.com/latex3/latex3/compare/2023-11-01...2023-12-08
[2023-11-01]: https://github.com/latex3/latex3/compare/2023-10-10...2023-11-01
[2023-10-10]: https://github.com/latex3/latex3/compare/2023-05-11...2023-10-10
[2023-05-11]: https://github.com/latex3/latex3/compare/2023-04-19...2023-05-11
[2023-04-19]: https://github.com/latex3/latex3/compare/2023-03-30...2023-04-19
[2023-03-30]: https://github.com/latex3/latex3/compare/2023-01-24...2023-03-30
[2023-01-24]: https://github.com/latex3/latex3/compare/2022-04-20...2023-01-24
[2022-04-20]: https://github.com/latex3/latex3/compare/2022-04-10...2022-04-20
[2022-04-10]: https://github.com/latex3/latex3/compare/2022-02-05...2022-04-10
[2022-02-05]: https://github.com/latex3/latex3/compare/2021-11-12...2022-02-05
[2021-11-12]: https://github.com/latex3/latex3/compare/2021-08-27...2021-11-12
[2021-08-27]: https://github.com/latex3/latex3/compare/2021-08-04...2021-08-27
[2021-08-04]: https://github.com/latex3/latex3/compare/2021-07-12...2021-08-04
[2021-07-12]: https://github.com/latex3/latex3/compare/2021-05-27...2021-07-12
[2021-05-27]: https://github.com/latex3/latex3/compare/2021-02-18...2021-05-27
[2021-02-18]: https://github.com/latex3/latex3/compare/2021-02-06...2021-02-18
[2021-02-06]: https://github.com/latex3/latex3/compare/2021-01-29...2021-02-06
[2021-01-29]: https://github.com/latex3/latex3/compare/2021-10-27...2021-01-29
[2020-10-27]: https://github.com/latex3/latex3/compare/2020-09-24...2020-10-27
[2020-09-24]: https://github.com/latex3/latex3/compare/2020-09-11...2020-09-24
[2020-09-11]: https://github.com/latex3/latex3/compare/2020-09-01...2020-09-11
[2020-09-01]: https://github.com/latex3/latex3/compare/2020-08-07...2020-09-01
[2020-08-07]: https://github.com/latex3/latex3/compare/2020-07-17...2020-08-07
[2020-07-17]: https://github.com/latex3/latex3/compare/2020-06-18...2020-07-17
[2020-06-18]: https://github.com/latex3/latex3/compare/2020-06-03...2020-06-18
[2020-06-03]: https://github.com/latex3/latex3/compare/2020-05-18...2020-06-03
[2020-05-18]: https://github.com/latex3/latex3/compare/2020-01-12...2020-05-18
[2020-01-12]: https://github.com/latex3/latex3/compare/2019-10-11...2020-01-12
[2019-10-11]: https://github.com/latex3/latex3/compare/2019-09-28...2019-10-11
[2019-09-28]: https://github.com/latex3/latex3/compare/2019-09-19...2019-09-28
[2019-09-19]: https://github.com/latex3/latex3/compare/2019-08-25...2019-09-19
[2019-08-25]: https://github.com/latex3/latex3/compare/2019-07-01...2019-08-25
[2019-07-01]: https://github.com/latex3/latex3/compare/2019-05-28...2019-07-01
[2019-05-28]: https://github.com/latex3/latex3/compare/2019-05-03...2019-05-28
[2019-05-03]: https://github.com/latex3/latex3/compare/2019-03-05...2019-05-03
[2019-03-05]: https://github.com/latex3/latex3/compare/2019-01-28...2019-03-05
[2019-01-28]: https://github.com/latex3/latex3/compare/2018-10-31...2019-01-28
[2018-10-31]: https://github.com/latex3/latex3/compare/2018-10-26...2018-10-31
[2018-10-26]: https://github.com/latex3/latex3/compare/2018-10-17...2018-10-26
[2018-10-17]: https://github.com/latex3/latex3/compare/2018-08-24...2018-10-17
[2018-08-24]: https://github.com/latex3/latex3/compare/2018-08-23...2018-08-24
[2018-08-23]: https://github.com/latex3/latex3/compare/2018-05-12...2018-08-23
[2018-05-12]: https://github.com/latex3/latex3/compare/2018-04-30...2018-05-12
[2018-04-30]: https://github.com/latex3/latex3/compare/2018-03-05...2018-04-30
[2018-03-05]: https://github.com/latex3/latex3/compare/2018-02-21...2018-03-05
[2018-02-21]: https://github.com/latex3/latex3/compare/2017-12-16...2018-02-21
