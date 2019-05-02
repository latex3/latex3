# Changelog
All notable changes to the `l3packages` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

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

[Unreleased]: https://github.com/latex3/latex3/compare/2019-03-05...HEAD
[2019-03-05]: https://github.com/latex3/latex3/compare/2019-09-24...2019-03-05
[2018-09-24]: https://github.com/latex3/latex3/compare/2018-08-23...2018-09-24
[2018-08-23]: https://github.com/latex3/latex3/compare/2018-05-12...2018-08-23
[2018-05-12]: https://github.com/latex3/latex3/compare/2018-04-30...2018-05-12
[2018-04-30]: https://github.com/latex3/latex3/compare/2017-12-16...2018-04-30
