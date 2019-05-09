# Changelog
All notable changes to the `l3kernel` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

## [2019-05-09]

### Added

- Experimental driver-level interfaces for image inclusion
- Experimental `\ior_shell_open:Nn`

### Fixed

- Some issues in `dvisvgm` driver

## [2019-05-07]

### Added

- `.muskip:N` property

### Changed

- Experimental `\driver_pdf_compress_objects:n` replaces
  `\driver_pdf_objects_(en|dis)able:`

## [2019-05-05]

### Added

- `\char_str_<target>_case:N`

### Fixed

- Infinite loop in some cases in DVI mode due to link-breaking code
  (see #570)
- Category code of output from `\char_<target>_case:N`, and
  same issue in `\str_<target>_case:n`

## [2019-05-03]

### Added

- New `l3legacy` module containing
  - `\legacy_if:n(TF)`

### Changed

- Moved `\file_get_mdfive_hash:nN(TF)`, `\file_get_size:nN(TF)`
   and `\file_get_timestamp:nN(TF)` to stable
- Moved `\file_if_exist_input:n` and `\file_if_exist_input:nF` to stable
- Moved `\file_input_stop:` to stable
- Moved `\peek_N_type:TF` to stable

## [2019-04-21]

### Added

- Experimental support for a range of PDF concepts at the lowest
  (driver abstraction) level

## [2019-04-06]

### Changed

- Moved `\tl_if_single_token:n(TF)` to stable

### Fixed

- Support for ConTeXt from mid-December 2018

## [2019-03-26]

### Fixed

- Loading when pre-TL'18 XeTeX is in use (see #555)

## [2019-03-05]

### Added

- `\str_log:n`, `\str_log:N`
- `TF` versions for `\file_get_...:nN` and `\ior_(str_)get:NN` functions
- `\cs_prefix_spec:N`, `\cs_argument_spec:N`, `\cs_replacement_spec:N`
- `undo-recent-deprecations` option
- `factorial` function in `l3fp`

### Changed

- Return values from `\file_get:nnN`, `\file_get_...:nN`, `\ior_get:NN`,
  `\sys_shell_get:nnN`
- Moved coffin affine transformations to stable
- Moved `\prop_count:N` to stable
- Moved `\tl_count_tokens:n` to stable
- Completed emulation of e-type argument when `\expanded` is unavailable
- Made expandable messages expand their result, like usual messages
- Made deprecation errors less intrusive by default
- Stopped providing do-nothing `\color` macro when undefined

### Deprecated
- `\token_get_prefix_spec:N`, `\token_get_arg_spec:N`,
  `\token_get_replacement_spec:N` replaced by `\cs_prefix_spec:N`,
  `\cs_argument_spec:N`, `\cs_replacement_spec:N`, respectively

### Fixed

- Treatment of inherited keys when setting only known keys (see #548)

### Removed

- Experimental `\skip_split_finite_else_action:nnNN`
- Experimental `\tl_reverse_tokens:n`

## [2019-02-15]

### Changed

- Defensive code for redefinition of `\time`, `\day`, `\month` and `\year`

### Fixed

- Resetting of key inheritance (see #535)
- Issue in deprecated command `\tl_set_from_file:Nnn`
  (see https://tex.stackexchange.com/q/474813/)

## [2019-02-03]

### Added

- Support for return of whole path by `\keys_set_known:nnN`-like
  function `\keys_set_known:nnnN` (see #508)
- `.prop_(g)put:N` key property (see #444)

### Fixed

- Handling of nested key setting when filtering, _etc._ (see #526)
- Inheritance of default values (see #504)

## [2019-01-28]

### Added

- Global versions of box affine functions, e.g. `\box_grotate:Nn`
- Global versions of box size adjustment functions
- `\box_(g)set_eq_drop:NN`, `\(h|v)box_unpack_drop:N`
- `\file_get:nnN` and `\file_get:nnNTF`
- Experimental functions `\sys_shell_get:nnN` and `\sys_shell_get:nnNTF`

### Changed

- `\char_generate:nn` now always takes exactly two expansions
- Move `\prg_generate_conditional_variant:Nnn` to stable
- Renamed experimental `\box_trim:Nnnnn` and `\box_viewport:Nnnnn` as
  `\box_set_trim:Nnnnn` and `\box_set_viewport:Nnnnn`, respectively

### Deprecated

- `\box_(g)set_eq_clear:NN`, replaced by `\box_(g)set_eq_drop:NN`
- `\(h|v)box_unpack_clear:N`, replaced by `\(h|v)box_unpack_drop:N
- `\tl_(g)set_from_file(_x):Nnn`, replaced by `\file_get:nnN`

### Fixed

- Scope treatment of `\box_set_dp:N`, _etc._
- In (u)platex: detection of spaces in `\tl_rescan:nn` and related functions

### Removed

- Experimental function family `\tl_(g)set_from_shell:(N|c)nn`
  (replaced by `\sys_shell_get:nnN`)

## [2019-01-13]

### Added

- `\ior_map_variable:NNn` and `\ior_str_map_variable:NNn`

### Fixed

- Unclosed conditional with Unicode engines

## [2019-01-12]

### Changed

- Improved `expl3` loading time with LuaTeX and XeTeX
- Improved performance of `\ior_map_inline:Nn` and related functions

### Fixed

- Handling of accented characters under mixed case changing in 8-bit engines
  (see #514)

## [2019-01-01]

### Added

- `\iow_allow_break:`

### Fixed

- Correct fp randint with zero argument (see #507)
- Handling of `\current@color` with (x)dvipdfmx` (see #510)

### Removed

- Support for stand-alone `l3regex`, `l3sort`, `l3srt`, `l3tl-analysis`,
  `l3tl-build`
- `\box_resize:Nnn`
- `\box_use_clear:N`
- `\c_minus_one`
- `\file_add_path:nN`
- `\file_list:`
- `\file_path_include:n` and `\file_path_remove:n`
- `\io(r|w)_list_streams:` and `\io(r|w)_log_streams:`
- `\sort_ordered:` and `\sort_reversed:`
- `\token_new:Nn`
- Generation of invalid variants from `n`/`N` base types

## [2018-12-12]

### Changed

- Move `\tl_range:nnn` to stable

### Fixed

- Loading in ConTeXt MkIV

## [2018-12-11]

### Changed

- Enable `\char_generate:nn` to create active tokens with XeTeX

## [2018-12-06]

### Changed

- Apply `\par` only at the end of vertical boxes
- Move `\int_rand:n` to stable
- Move `\<var>_rand_item:N` to stable

### Fixed

- Typo in `\lua_shipout_e:n` (see #503)

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

[Unreleased]: https://github.com/latex3/latex3/compare/2019-05-09...HEAD
[2019-05-09]: https://github.com/latex3/latex3/compare/2019-05-07...2019-05-09
[2019-05-07]: https://github.com/latex3/latex3/compare/2019-05-05...2019-05-07
[2019-05-05]: https://github.com/latex3/latex3/compare/2019-05-03...2019-05-05
[2019-05-03]: https://github.com/latex3/latex3/compare/2019-04-21...2019-05-03
[2019-04-21]: https://github.com/latex3/latex3/compare/2019-04-06...2019-04-21
[2019-04-06]: https://github.com/latex3/latex3/compare/2019-03-26...2019-04-06
[2019-03-26]: https://github.com/latex3/latex3/compare/2019-03-05...2019-03-26
[2019-03-05]: https://github.com/latex3/latex3/compare/2019-02-15...2019-03-05
[2019-02-15]: https://github.com/latex3/latex3/compare/2019-02-03...2019-02-15
[2019-02-03]: https://github.com/latex3/latex3/compare/2019-01-28...2019-02-03
[2019-01-28]: https://github.com/latex3/latex3/compare/2019-01-13...2019-01-28
[2019-01-13]: https://github.com/latex3/latex3/compare/2019-01-12...2019-01-13
[2019-01-12]: https://github.com/latex3/latex3/compare/2019-01-01...2019-01-12
[2019-01-01]: https://github.com/latex3/latex3/compare/2018-12-12...2019-01-01
[2018-12-12]: https://github.com/latex3/latex3/compare/2018-12-11...2018-12-12
[2018-12-11]: https://github.com/latex3/latex3/compare/2018-12-06...2018-12-11
[2018-12-06]: https://github.com/latex3/latex3/compare/2018-11-19...2018-12-06
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
