# Changelog
All notable changes to the `l3packages` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

## [2020-05-15]

## [2020-05-14]

### Changed
- Internal packaging of `xparse` in advance of changes to the LaTeX2e kernel

## [2020-03-06]

### Added
- Pre-loader file `xparse.ltx`

## [2020-03-03]

### Changed
- Delimited arguments (`DdRrEet`) now allow control sequence tokens
  as delimiters (issues #367 and #368)

## [2020-02-25]

### Changed
- Issue warnings for unsupported delimiters in `xparse`

## [2020-02-14]

### Fixed
- Grabbing `r`-type arguments by expandable commands (issse #672)

## [2020-02-08]

### Changed
- Document that `\CurrentOption` is available and should be used in
  `l3keys2e`

## [2020-02-03]

### Fixed
- Unknown key error text after loading `l3keys2e`

## [2020-01-12]

### Changed
- Track `l3kernel` changes

## [2019-10-11]

### Fixed
- `xparse`: Allow processors to depend on other arguments (fixes #629)

## [2019-05-28]

### Fixed
- `xparse`: Remove stray spaces in processor information

## [2019-05-03]

### Added
- `xparse`: Support for `trace` package

## [2019-03-05]

### Added
- `xparse`: b-type argument to grab body of environments

### Changed
- `xparse`: make \IfBooleanTF safer
- `xparse`: clearer error messages, especially for environments
- `xparse`: when defining an environment, trim spaces at ends of its name

## [2018-09-24]

### Changed
- `xparse`: put spaces back when a trailing optional arg is absent (fixes #466)

## [2018-08-23]

### Added
- `CHANGELOG.md` (fixes #460)

## [2018-05-12]

### Changed
- Track changes in primitive naming in `l3kernel`

## [2018-04-30]

### Changed
- `xparse`: allow spaces before trailing optional arguments,
  with new "!" modifier to control behavior
- Switch to ISO date format
- Improve cross-module use of internal functions

[Unreleased]: https://github.com/latex3/latex3/compare/2020-05-15...HEAD
[2020-05-15]: https://github.com/latex3/latex3/compare/2020-05-14...2020-05-15
[2020-05-14]: https://github.com/latex3/latex3/compare/2020-03-06...2020-05-14
[2020-03-06]: https://github.com/latex3/latex3/compare/2020-03-03...2020-03-06
[2020-03-03]: https://github.com/latex3/latex3/compare/2020-02-25...2020-03-03
[2020-02-25]: https://github.com/latex3/latex3/compare/2020-02-14...2020-02-25
[2020-02-14]: https://github.com/latex3/latex3/compare/2020-02-08...2020-02-14
[2020-02-08]: https://github.com/latex3/latex3/compare/2020-02-03...2020-02-08
[2020-02-03]: https://github.com/latex3/latex3/compare/2020-01-12...2020-02-03
[2020-01-12]: https://github.com/latex3/latex3/compare/2019-10-11...2020-01-12
[2019-10-11]: https://github.com/latex3/latex3/compare/2019-05-28...2019-10-11
[2019-05-28]: https://github.com/latex3/latex3/compare/2019-05-03...2019-05-28
[2019-05-03]: https://github.com/latex3/latex3/compare/2019-03-05...2019-05-03
[2019-03-05]: https://github.com/latex3/latex3/compare/2019-09-24...2019-03-05
[2018-09-24]: https://github.com/latex3/latex3/compare/2018-08-23...2018-09-24
[2018-08-23]: https://github.com/latex3/latex3/compare/2018-05-12...2018-08-23
[2018-05-12]: https://github.com/latex3/latex3/compare/2018-04-30...2018-05-12
[2018-04-30]: https://github.com/latex3/latex3/compare/2017-12-16...2018-04-30
