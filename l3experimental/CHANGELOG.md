# Changelog
All notable changes to the `l3experimental` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

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
- Corrected behaviour of catcode tables (see #610)

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

## Fixed

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

[Unreleased]: https://github.com/latex3/latex3/compare/2020-06-18...HEAD
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
