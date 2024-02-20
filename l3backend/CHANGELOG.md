# Changelog
All notable changes to the `l3backend` bundle will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

### Fix
- Setting `\l_graphics_search_ext_seq` before declaration if loaded in
  formats other than LaTeX

## [2024-02-20]

### Fixed
- Naming of a variable in the `draw` code

## [2024-01-04]

### Changed
- Documentation tweaks

## [2023-11-09]

### Changed
- Changed `luaotfload` integration to allow coexistance with (x)color.

## [2023-11-04]

### Fixed
- Interaction with `luaotfload` transparency colorstacks

## [2023-10-23]

### Changed
- Update minimal `expl3` version required

## [2023-10-10]

### Changed
- Track `expl3` changes

## [2023-04-19]

### Changed
- Pass additional attributes when loading graphics in PDF mode

### Fixed
- Remove a stray `>` from graphics inclusion code for `dvipdfmx`

## [2023-03-30]

### Changed
- Integrate `l3color` and `l3opacity` with `luaotfload` to ensure that
  opacity specifications don't conflict

## [2023-01-16]

### Changed
- Adjust internal scope of a PDF function

## [2022-10-26]

### Changed
- Avoid setting media box if `\mag` is non-standard

## [2022-09-28]

### Changed
- Add support for media box setting

## [2022-08-30]

### Added
- Support for new approach to writing PDF objects

## [2022-08-23]

### Changed
- Approach to setting current color data from LaTeX2e

## [2022-08-05]

### Changed
- Add no-op backend functions for annotations with `dvisvgm`

## [2022-07-01]

#### Fixed
- Do not include PDF file to count pages on pdfTeX
- Opacity creation with `dvipdfmx`/XeTeX  (issue [\#1106](https://github.com/latex3/latex3/issues/1106))
- Reset opacity when no stack is available at the backend (issue [\#1107](https://github.com/latex3/latex3/issues/1107))

## [2022-04-20]

### Changed
- Adjust `(x)dvipdfmx` backend approach to color following issues with
  multiple color stacks in `xetex.def`
- Move some functions to `l3color`

## [2022-04-14]

### Added
- Support for SVG graphic inclusion by `dvisvgm`

### Fixed
- `\color_ensure_current:` backend with DVI-based routes (issue [\#1085](https://github.com/latex3/latex3/issues/1085))

## [2022-04-10]

### Added
- Support for graphics (PDF) page count extraction

### Fixed
- Setup for graphics extension searching
- Various internal issues in graphics inclusion
- Some missing functions for `dvisvgm` color support added

### Removed
- Support for pre-2020-11-11 `dvipdfmx`

## [2022-02-07]

### Fixed
- Use of color stack int in scope end for `(x)dvipdfmx`

## [2022-01-12]

### Changed
- Move some functions to `l3color`

## [2021-12-14]

### Fixed
- Scoping issues for `dvisvgm`
- Some incorrect functions in `l3draw` backend for `dvisvgm`

## [2021-10-17]

### Changed
- Better DeviceN support

## [2021-10-12]

### Fixed
- Issues with creating DeviceN color spaces

## [2021-08-04]

### Changed
- Only use `pdfmanagement` module if active

## [2021-07-12]

### Fixed
- GoTo link formation for Distiller-based workflows (issue [\#957](https://github.com/latex3/latex3/issues/957))
- Support transparency with Distiller

## [2021-05-07]

### Changed
- `\pdf_version_gset:n` in `dvips` now sets `\pdf_version_minor:` and
  `\pdf_version_major:`. This doesn't set the PDF version but allows to test
  which version the user intents to create.

## [2021-03-18]

### Fixed
- Maintain stack color correctly with `(x)dvipdfmx`

## [2021-03-02]

### Changed
- Drop 'correction' for link placement in `(x)dvidpfmx`: no longer required
- Define `\main@pdfcolorstack` for `(x)dvipdfmx` if it does not exist

### Fixed
- Initialisation of color stacks for `(x)dvipdfmx`

## [2021-02-18]

### Changed
- Update tracking of PDF management functions

### Fixed
- Opacity support for pdfTeX/LuaTeX

## [2021-02-06]

### Changed
- Use new (internal) interface for kerns

## [2021-01-29]

### Added
- Basic opacity support

### Changed
- Use color stack for fill color, and for stroke color if possible

### Fixed
- Implementation of `filldraw` for `dvips`

## [2021-01-09]

### Added
- Support for referencing last link with `(x)dvipdfmx` (requires an up-to-date
  backend)

### Changed
- Implementation of color wtih (x)dvipdfmx (requires an up-to-date
  backend)

## [2020-09-24]

### Fixed
- Documented source as PDF

## [2020-09-11]

### Added
- Support for CIELAB separations with `dvips`

### Fixed
- Some PDF object functions
- Separation color selection for `dvipdfmx`/XeTeX
- Logic for some aspects of CIELAB Separation color

## [2020-09-01]

### Changed
- Improved support for Separation colors
- Updated approach to `dvipdfmx`/XeTeX color support
- Split `pdfmode` driver into pdfTeX- and LuaTeX-specific  files
- Renamed `xdvipdfmx` backend files to `xetex`

## [2020-08-07]

### Changed
- Color selection implementation
- Improved support for Separation colors

## [2020-06-29]

### Fixed
- Loading with `dvisvgm`

## [2020-06-23]

### Changed
- Improved color support for drawings with `dvisvgm`

### Fixed
- Loading with `dvisvgm`

## [2020-06-18]

### Changed
- Use `scn` operator for separations
- Internal color model
- Internal performance enhancements

## [2020-06-03]

### Fixed
- Unneeded `[nobreak]` in `dvips` driver (issue [\#709](https://github.com/latex3/latex3/issues/709))
- `\__pdf_backend_object_write_fstream:nn` with `dvips` backend (issue [\#710](https://github.com/latex3/latex3/issues/710))
- Array writing in `dvips` mode

## [2020-05-05]

### Added
- `\__pdf_backend_pageobject_ref:n`

### Changed
- Extend PDF compression control to `dvips`

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

[Unreleased]: https://github.com/latex3/latex3/compare/2024-02-20...HEAD
[2024-02-20]: https://github.com/latex3/latex3/compare/2024-01-04...2024-02-20
[2024-01-04]: https://github.com/latex3/latex3/compare/2023-11-09...2024-01-04
[2023-11-09]: https://github.com/latex3/latex3/compare/2023-11-04...2023-11-09
[2023-11-04]: https://github.com/latex3/latex3/compare/2023-10-23...2023-11-04
[2023-10-23]: https://github.com/latex3/latex3/compare/2023-10-10...2023-10-23
[2023-10-10]: https://github.com/latex3/latex3/compare/2023-04-19...2023-10-10
[2023-04-19]: https://github.com/latex3/latex3/compare/2023-03-30...2023-04-19
[2023-03-30]: https://github.com/latex3/latex3/compare/2023-01-16...2023-03-30
[2023-01-16]: https://github.com/latex3/latex3/compare/2022-10-26...2023-01-16
[2022-10-26]: https://github.com/latex3/latex3/compare/2022-09-28...2022-10-26
[2022-09-28]: https://github.com/latex3/latex3/compare/2022-08-30...2022-09-28
[2022-08-30]: https://github.com/latex3/latex3/compare/2022-08-23...2022-08-30
[2022-08-23]: https://github.com/latex3/latex3/compare/2022-08-05...2022-08-23
[2022-08-05]: https://github.com/latex3/latex3/compare/2022-07-01...2022-08-05
[2022-07-01]: https://github.com/latex3/latex3/compare/2022-04-20...2022-07-01
[2022-04-20]: https://github.com/latex3/latex3/compare/2022-04-14...2022-04-20
[2022-04-14]: https://github.com/latex3/latex3/compare/2022-04-10...2022-04-14
[2022-04-10]: https://github.com/latex3/latex3/compare/2022-02-07...2022-04-10
[2022-02-07]: https://github.com/latex3/latex3/compare/2022-01-12...2022-02-07
[2022-01-12]: https://github.com/latex3/latex3/compare/2021-12-14...2022-01-12
[2021-12-14]: https://github.com/latex3/latex3/compare/2021-10-17...2021-12-14
[2021-10-17]: https://github.com/latex3/latex3/compare/2021-10-12...2021-10-17
[2021-10-12]: https://github.com/latex3/latex3/compare/2021-08-04...2021-10-12
[2021-08-04]: https://github.com/latex3/latex3/compare/2021-07-12...2021-08-04
[2021-07-12]: https://github.com/latex3/latex3/compare/2021-05-07...2021-07-12
[2021-05-07]: https://github.com/latex3/latex3/compare/2021-03-18...2021-05-07
[2021-03-18]: https://github.com/latex3/latex3/compare/2021-03-02...2021-03-18
[2021-03-02]: https://github.com/latex3/latex3/compare/2021-02-18...2021-03-02
[2021-02-18]: https://github.com/latex3/latex3/compare/2021-02-06...2021-02-18
[2021-02-06]: https://github.com/latex3/latex3/compare/2021-01-29...2021-02-06
[2021-01-29]: https://github.com/latex3/latex3/compare/2021-01-09...2021-01-29
[2021-01-09]: https://github.com/latex3/latex3/compare/2020-09-24...2021-01-09
[2020-09-24]: https://github.com/latex3/latex3/compare/2020-09-11...2020-09-24
[2020-09-11]: https://github.com/latex3/latex3/compare/2020-09-01...2020-09-11
[2020-09-01]: https://github.com/latex3/latex3/compare/2020-08-07...2020-09-01
[2020-08-07]: https://github.com/latex3/latex3/compare/2020-06-29...2020-08-07
[2020-06-29]: https://github.com/latex3/latex3/compare/2020-06-23...2020-06-29
[2020-06-23]: https://github.com/latex3/latex3/compare/2020-06-18...2020-06-23
[2020-06-18]: https://github.com/latex3/latex3/compare/2020-06-03...2020-06-18
[2020-06-03]: https://github.com/latex3/latex3/compare/2020-05-05...2020-06-03
[2020-05-05]: https://github.com/latex3/latex3/compare/2020-03-12...2020-05-05
[2020-03-12]: https://github.com/latex3/latex3/compare/2020-02-23...2020-03-12
[2020-02-23]: https://github.com/latex3/latex3/compare/2020-02-21...2020-02-23
[2020-02-21]: https://github.com/latex3/latex3/compare/2020-02-03...2020-02-21
[2020-02-03]: https://github.com/latex3/latex3/compare/2019-11-25...2020-02-03
[2019-11-25]: https://github.com/latex3/latex3/compare/2019-10-11...2019-11-25
[2019-10-11]: https://github.com/latex3/latex3/compare/2019-09-05...2019-10-11
[2019-09-05]: https://github.com/latex3/latex3/compare/2019-08-25...2019-09-05
[2019-08-25]: https://github.com/latex3/latex3/compare/2019-07-01...2019-08-25
[2019-07-01]: https://github.com/latex3/latex3/compare/2019-05-28...2019-07-01
