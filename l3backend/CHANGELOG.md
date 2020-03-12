# Changelog
All notable changes to the `l3backend` bundle will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

## [2020-03-12]

### Fixed
- Creation of PDF annotations with `dvips` backend

## [2020-02-23]

### Fixed
- Mismatch between release tag and CTAN version

## [2020-02-21]

### Added
- Support for suppressing backend headers (see matching change in
  `l3kernel`)

## [2020-02-03]

### Fixed
- Corrected release string information

## [2019-11-25]

### Changed
- Move dvips header material to `.pro` file

## [2019-10-11]

### Changed
- Improved functionality in generic mode

## [2019-09-05]

### Added
- Support for EPS and PDF files with `dvisvgm` backend

### Fixed
- Some primitive use in the `dvips` backend

## [2019-08-25]

### Fixed
- Setting for PDF version in `dvipdfmx` route
- Support for PDF objects with XeTeX

## [2019-07-01]

### Added
- Driver support for anonymous objects

### Changed
- Moved backend code to separate release module `l3backend`
- Include `l3backend` in file names
- Moved backend code to internal for each 'parent' module

[Unreleased]: https://github.com/latex3/latex3/compare/2020-03-12...HEAD
[2020-03-12]: https://github.com/latex3/latex3/compare/2020-02-23...2020-03-12
[2020-02-23]: https://github.com/latex3/latex3/compare/2020-02-21...2020-02-23
[2020-02-21]: https://github.com/latex3/latex3/compare/2020-02-03...2020-02-21
[2020-02-03]: https://github.com/latex3/latex3/compare/2019-11-25...2020-02-03
[2019-11-25]: https://github.com/latex3/latex3/compare/2019-10-11...2019-11-25
[2019-10-11]: https://github.com/latex3/latex3/compare/2019-09-05...2019-10-11
[2019-09-05]: https://github.com/latex3/latex3/compare/2019-08-25...2019-09-05
[2019-08-25]: https://github.com/latex3/latex3/compare/2019-07-01...2019-08-25
[2019-07-01]: https://github.com/latex3/latex3/compare/2019-05-28...2019-07-01
