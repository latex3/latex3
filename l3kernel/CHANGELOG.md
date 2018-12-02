# Changelog
All notable changes to the `l3kernel` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

### Changed

- Apply `\par` only at the end of vertical boxes
- Move `\int_rand:n` to stable
- Move `\<var>_rand_item:N` to stable

## [2018-11-19]

### Added

- Support for cross-compatibility primitives in XeTeX
- `\int_sign:n`, `\dim_sign:n` and `\fp_sign:n`

## [2018-10-19]

### Fixed

- Wrapping of text in messages, etc., for some line lengths (fixes #491)

## [2018-10-17]

### Added

- `\g_msg_module_documentation_prop` (see #471)
- `\peek_remove_spaces:n`

### Changed

- Formatting of messages: now follows LaTeX2e closely

### Deprecated

- `\msg_interrupt:nn`, `\msg_log:n` and `\msg_term:n`

### Fixed

- Handling of inheritance for choice keys (fixes #483)

## [2018-09-24]

### Added
- Some driver-level support for PDF features
- `\peek_catcode_collect_inline:Nn`, `\peek_charcode_collect_inline:Nn`,
  `\peek_meaning_collect_inline:Nn`

### Fixed
- Handling of unknown keys when inheritance is active (fixes #481)

## [2018-08-23]

### Added
- `\lua_escape:e`, `\lua_now:e` and `\lua_shipout_e:n`
- `\str_case_e:nn(TF)` and `\str_if_eq:ee(TF)`
- `\sys_if_platform_unix:(TF)` and `\sys_if_platform_windows:(TF)`
- `\tl_(g)set_from_shell:Nnn`

### Deprecated
- `\lua_escape_x:n`, `\lua_now_x:n` and `\lua_shipout_x:n`
- `\str_case_x:nn(TF)` and `\str_if_eq_x:nn(TF)`

## [2018-06-14]

### Added
- Support for `e`-type argument using `\expanded` or macro emulation

## [2018-06-01]

### Added
- `CHANGELOG.md` (fixes #460)

### Fixed
- Loading `expl3` with LuaTeX/XeTeX and certain letter tokens set
  to be active (see #462)

### Changed
- Alter `\char_codepoint_from_bytes:n` to produce four groups in all
  cases; make `f`-type expandable

## [2018-05-13]

### Fixed
- Cor­rect date string in `ex­pl3.dtx`
- Cor­rect `\c_sys_en­gine_ver­sion_str` when using XeTeX

## [2018-05-12]

### Added
- Define `\c_zero_int` and `\c_one_int`
- Im­ple­ment `\c_sys_en­gine_ver­sion_str`
- Im­ple­ment `\seq_in­dexed_map_func­tion/in­line`
- Im­ple­ment `\in­tar­ray_gzero:N`
- Im­ple­ment `\in­tar­ray_const_from_clist:Nn`
- Im­ple­ment `\bool_set_in­verse:N`
- Im­ple­ment `\bool_xor:nnTF` in­stead of just `\bool_xor_p:nn`
- Im­ple­ment can­di­date `\int_rand:n`
- Im­ple­ment `\in­tar­ray_gset_rand:Nnn`
- Im­ple­ment can­di­date `l3f­par­ray` mod­ule

## Changed
- Up­date min­i­mal re­quired ver­sions of XeTeX and LuaTeX
- Dep­re­cate named in­te­ger con­stants `\c_zero`. etc.
- Move all prim­i­tives to `\tex_...:D names­pace`,
  dep­re­cat­ing older en­gine-de­pen­dent pre­fixes
- Several internal optimisations

### Fixed

- Ex­pand boolean ex­pres­sion be­fore call­ing `\chardef` (fixes #461)

### Removed
- Re­move un­doc­u­mented `\fp_func­tion:Nw` and `\fp_new_func­tion:Npn`

## [2018-04-30]

### Added
- Implement \tl_analysis_map_inline:nn
- Implement \exp_args_generate:n to define new \exp_args:N...
  functions
- Low-level \int_value:w function
- New experimental functions for
  - Building token lists piecewise
  - Fast manipulation of integer arrays
  - Sequence shuffling
  - `\seq_set_from_function:NnN`
  - `\char_codepoint_to_bytes:n`

### Changed
- Significant internal revision to use only internal functions
  'private' to specific modules
- Better documentation of cross-module kernel-internal functions
- Enable `\char_generate:nn` for active chars
- Renamed `\tl_show_analysis:(N|n)n` as `\tl_analysis_show:(N|n)n`
- Change \int_rand:nn (and rand_item functions) to better use
  the RNG
- Make prg break functions public
- Make scan marks mechanism public
- Make `\prg_do_nothing:` long rather than nopar (fixes #455)
- Several performance improvements
- Documentation improvements

### Fixed
- Only index TF, T, F functions together if they are `expl3`
  functions (fixes #453)
- Make `\infty` and `\pi` into errors in fp expressions
  (fixes #357)

### Removed
- Deprecated functions expiring at end of 2017
- Old module `.sty` files

## [2018-03-05]

### Changes
- Adjustments to `l3drivers` to support `l3draw` development in
  `l3experimental` bundle

## [2018-02-21]

### Added
- Tuple support in fp expressions
- Step func­tions have been added for dim vari­ables,
  e.g. `\dim_step_in­line:nnnn`

[Unreleased]: https://github.com/latex3/latex3/compare/2018-11-19...HEAD
[2018-11-19]: https://github.com/latex3/latex3/compare/2018-10-31...2018-11-19
[2018-10-31]: https://github.com/latex3/latex3/compare/2018-10-26...2018-10-31
[2018-10-26]: https://github.com/latex3/latex3/compare/2018-10-19...2018-10-26
[2018-10-19]: https://github.com/latex3/latex3/compare/2018-10-17...2018-10-19
[2018-10-17]: https://github.com/latex3/latex3/compare/2018-09-24...2018-10-17
[2018-09-24]: https://github.com/latex3/latex3/compare/2018-08-23...2018-09-24
[2018-08-23]: https://github.com/latex3/latex3/compare/2018-06-14...2018-08-23
[2018-06-14]: https://github.com/latex3/latex3/compare/2018-06-01...2018-06-14
[2018-06-01]: https://github.com/latex3/latex3/compare/2018-05-13...2018-06-01
[2018-05-13]: https://github.com/latex3/latex3/compare/2018-05-12...2018-05-13
[2018-05-12]: https://github.com/latex3/latex3/compare/2018-04-30...2018-05-12
[2018-04-30]: https://github.com/latex3/latex3/compare/2018-03-05...2018-04-30
[2018-03-05]: https://github.com/latex3/latex3/compare/2018-02-21...2018-03-05
[2018-02-21]: https://github.com/latex3/latex3/compare/2017-12-16...2018-02-21
