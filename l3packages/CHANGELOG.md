# Changelog
All notable changes to the `l3packages` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

### Fixed
- Support for optimised commands using `\GetDocumentCommandArgSpec` (issue
  [\#1550](https://github.com/latex3/latex3/issues/1550))
- Unmatched `macrocode` environment in `xtemplate`

## [2024-05-08]

### Changed
- Prepare for kernel adjustments to templates:
  `\IfInstanceExist(TF)` as alias for `\IfInstanceExists(TF)`

## [2024-03-14]

### Changed
- Add a new intro to `xparse.dtx` pointing to kernel methods

## [2024-02-18]

### Changed
- Re-added `\IfInstanceExist(TF)` to docs - is required

## [2024-02-13]

### Changed
- Preparation for move of `xtemplate` concepts to the kernel

### Removed
- `\IfInstanceExist(TF)`
- `xfrac`: moved to https://github.com/latex3/xfrac

## [2023-10-10]

### Changed
- Track `expl3` changes

## [2023-08-29]

### Added
- Re-add `\GetDocumentCommandArgSpec`, etc., to `xparse` stub

## [2023-02-02]

### Changed
- Re-order arguments of `\DeclareInstanceCopy`

## [2023-02-01]

### Added
- `\DeclareInstanceCopy`

### Changes
- Set only known keys in `\SetTemplateKeys`

## [2023-01-16]

### Fixed
- Ad hoc adjustment of template `function` keys

### Removed
- Template key type `code`

## [2022-12-17]

### Fixed
- Template editing following restricted template setting
  (issue [\#1155](https://github.com/latex3/latex3/issues/1155))

## [2022-06-22]

### Changed
- Revert alterations to `l3keys2e`

### Deprecated
- Package `l3keys2e`

## [2022-06-16]

### Changed
- Only remove key name part from `\@unusedoptionlist`

## [2022-06-07]

### Fixed
- Space stripping from `xtemplate` key types
- Fix `log-declarations=true` (issue [\#1095](https://github.com/latex3/latex3/issues/1095))

## [2022-05-30]

### Added
- `\SetTemplateKeys` for _ad hoc_ adjustment of template values

### Changed
- Make `\AssignTemplateKeys` optional

### Removed
- `\EvaluateNow` command

## [2022-01-12]

### Changed
- Use `\ProvideExp...` in `xfp` because the package will soon no longer be needed
  and just remains so that old documents still compile correctly.

## [2021-11-12]

### Added
- Added `\NewCommandCopy` support for deprecated argument types.

## [2021-08-27]

### Changed
- Track message changes in `l3kernel`

## [2021-08-04]

### Changed
- Adjust `l3keys2e` to allow for future kernel provision of
  same ideas

## [2021-06-18]

### Fixed
- Correct internal changes to message naming

## [2021-06-01]

### Fixed
- Restore one parameter in `xfrac`

## [2021-05-27]

### Changed
- Internal changes to message naming

## [2021-05-07]

### Fixed
- Implementation of `\DeclareRestrictedTemplate`
- Incorrect use of restricted template in `xfrac`

## [2021-03-12]

### Fixed
- Pass options to frozen `xparse`

## [2021-02-02]

### Changed
- Freeze the `xparse` code, and move the development to the LaTeX2e
  repository as `ltcmd`.

## [2020-10-27]

### Changed
- Avoid relying on braced `\input` primitive syntax

## [2020-10-05]

### Changed
- Load generic code using `\input` not `\file_input:n` to avoid an issue
  when `openin_any = p` is set

## [2020-05-15]

### Changed
- Internal packaging of `xparse` in advance of changes to the LaTeX2e kernel

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

[Unreleased]: https://github.com/latex3/latex3/compare/2024-05-08...HEAD
[2024-05-08]: https://github.com/latex3/latex3/compare/2024-03-14...2024-05-08
[2024-03-14]: https://github.com/latex3/latex3/compare/2024-02-18...2024-03-14
[2024-02-18]: https://github.com/latex3/latex3/compare/2024-02-13...2024-02-18
[2024-02-13]: https://github.com/latex3/latex3/compare/2023-10-10...2024-02-13
[2023-10-10]: https://github.com/latex3/latex3/compare/2023-08-29...2023-10-10
[2023-08-29]: https://github.com/latex3/latex3/compare/2023-02-02...2023-08-29
[2023-02-02]: https://github.com/latex3/latex3/compare/2023-02-01...2023-02-02
[2023-02-01]: https://github.com/latex3/latex3/compare/2023-01-16...2023-02-01
[2023-01-16]: https://github.com/latex3/latex3/compare/2022-12-17...2023-01-16
[2022-12-17]: https://github.com/latex3/latex3/compare/2022-06-22...2022-12-17
[2022-06-22]: https://github.com/latex3/latex3/compare/2022-06-16...2022-06-22
[2022-06-16]: https://github.com/latex3/latex3/compare/2022-06-07...2022-06-16
[2022-06-07]: https://github.com/latex3/latex3/compare/2022-05-30...2022-06-07
[2022-05-30]: https://github.com/latex3/latex3/compare/2022-01-12...2022-05-30
[2022-01-12]: https://github.com/latex3/latex3/compare/2021-11-12...2022-01-12
[2021-11-12]: https://github.com/latex3/latex3/compare/2021-08-27...2021-11-12
[2021-08-27]: https://github.com/latex3/latex3/compare/2021-08-04...2021-08-27
[2021-08-04]: https://github.com/latex3/latex3/compare/2021-06-18...2021-08-04
[2021-06-18]: https://github.com/latex3/latex3/compare/2021-06-01...2021-06-18
[2021-06-01]: https://github.com/latex3/latex3/compare/2021-05-27...2021-06-01
[2021-05-27]: https://github.com/latex3/latex3/compare/2021-05-07...2021-05-27
[2021-05-07]: https://github.com/latex3/latex3/compare/2021-03-12...2021-05-07
[2021-03-12]: https://github.com/latex3/latex3/compare/2021-02-02...2021-03-12
[2021-02-02]: https://github.com/latex3/latex3/compare/2020-10-27...2021-02-02
[2020-10-27]: https://github.com/latex3/latex3/compare/2020-10-05...2020-10-27
[2020-10-05]: https://github.com/latex3/latex3/compare/2020-05-15...2020-10-05
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
