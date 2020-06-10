# Changelog
All notable changes to the `l3kernel` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

### Changed
- Internal color model

## [2020-06-03]

### Added
- `\str_convert_pdfname:n`

## [2020-05-15]

### Changed
- Make `\text_purify:n` `f`-type expandable

## [2020-05-14]

### Changed
- Performance improvements in keyval processing

## [2020-05-11]

### Changed
- Internal changes to quark handling

## [2020-05-05]

### Added
- Recognize the exponent marker `E` (same as `e`) in floating point numbers

### Fixed
- Leave active characters untouched when case-changing (see #715)

## [2020-04-06]

### Added
- Control for start-of-titlecasing: see `\l_text_titlecase_check_letter_bool`

### Fixed
- Nesting of `\seq_shuffle:N` in another sequence mapping (issue #687)
- `\ior_shell_open:Nn` in engines other than LuaTeX - shell commands didn't
  execute, plus the command call would be left in the input stream.

## [2020-03-06]

### Added
- `\text_purify:n`

### Fixed
- Issue with case-changing Turkish

## [2020-03-03]

### Added
- `\tex...:D` coverage for TeX Live 2020 engine changes

### Changed
- New implementation for `\keyval_parse:NNn` - around 40% speed improvement,
  also *expandable*

### Fixed
- Make `expl3` reload-safe for `latexrelease` (see latex3/latex2e#295)

## [2020-02-25]

### Changed
- Extend case-changing encoding support to Cyrillic and Greek

## [2020-02-21]

### Added
- Option `suppress-backend-headers` (see matching change in
  `l3backend`)

### Changed
- Allow `dvisvgm` driver with XeTeX (issue #677)

### Fixed
- `undo-recent-deprecations` would not reload the deprecation code

## [2020-02-14]

### Fixed
- Interaction with some `babel` languages at the start of the document

## [2020-02-13]

### Changed
- Leave implicit tokens unchanged by `\text_expand:n`
- Extend the `de-alt` case changing locale to 8-bit engines

## [2020-02-11]

### Added
- Key property `.cs_set:Np` and variants

### Changed
- Support `\@uclclist` entries when case-changing

### Fixed
- Allow for full range of encodings when expanding text (issue #671)
- Support `\begin`/`\end` in text expansion

## [2020-02-08]

### Added
- `\l_keys_key_str` and `\l_keys_path_str`

### Deprecated
- `\l_keys_key_tl` and `\l_keys_path_tl`, replaced by `\l_keys_key_str` and
  `\l_keys_path_str`, respectively

## [2020-02-03]

### Changed
- Minor edits to LaTeX3 News

## [2020-01-31]

### Added
- Table of Contents for combined LaTeX3 News

### Changed
- Use Lua `utf8` library if available

### Fixed
- Undefined command in box debugging code

## [2020-01-22]

### Added
- Support for command replacement in text expansion

### Changed
- Require key values for numerical key types (dim, int, etc.) (see #661)

### Fixed
- Issue with keys where some leading spaces could be left in key names

## [2020-01-12]

### Added
- `bool_case_true:n(TF)` and `\bool_case_false:n(TF)`
- `\file_hex_dump:n(nn)` and `\file_get_hex_dump:n(nn)N(TF)`
- `\str_<type>case:n`
- `\text_<type>case:n(n)`
- `\text_expand:n` and supporting data structures

### Changed
- Distribute LaTeX3 News
- Moved `\char_<type>case:N` to stable
- Documentation improvements

### Fixed
- Inherit key required/forbidden properties (see #653)
- Set backend at the beginning of `\document` (see #657)

### Deprecated
- `\str_<type>_case:n` replaced by `\str_<type>case:n`
  except `\str_mixed_case:n` replaced by `\str_titlecase:n`
- `\tl_<type>_case:n(n)` replaced by `\text_<type>case:n(n)`,
  except `\tl_mixed_case:n(n)` replaced by `\text_titlecase:n(n)`

## [2019-11-07]

### Fixed
- Handling of repeated loading of a backend (issue #646)
- Handling of repeated loading of deprecated functions

## [2019-10-28]

### Fixed
- File searching when `\(pdf)filesize` is not available (fixes #644)

## [2019-10-27]

### Changed
- Internal structure of `\c_sys_jobname_str` altered
- Update upTeX test to follow guidance from developers

## [2019-10-24]

### Changed
- File names are now returned without quotes by `\file_full_name:n`

### Fixed
- `\file_if_exist:n(TF)`, etc., when dealing with file names containing
  spaces (see #642)

## [2019-10-21]

### Added
- Lua function `l3kernel.shellescape()`

### Changed
- Better coverage of (u)pTeX primitives following publication of
  pTeX manual in English
- Trim spaces surrounding file names

### Removed
- HarfTeX primitives

## [2019-10-14]

### Fixed
- Correct handling of 'traditional' class options for backend

## [2019-10-11]

### Changed
- Standard backend for (u)pTeX is now `dvips`
- Minimum LuaTeX version now v0.95
- Moved `\debug_on:`, `\debug_off:`, `\debug_suspend:` and `\debug_resume:`
  to stable
- Accept 'traditional' class options for backend (`dvipdfmx`, `dvips`, etc.)
- Performance enhancements when loading `expl3`

### Fixed
- Handling of files with no extension
- Behaviour of Lua function `l3kernel.charcat` in some circumstances
- Loading under ConTeXt

## [2019-10-02]

### Fixed
- Variants using `\exp_args` functions with more than 9 arguments (see #636)

## [2019-09-30]

### Fixed
- File searching using `\file_full_name:n` (see #634)

## [2019-09-28]

### Changed
- Speed up variants and reduce their `\tracingall` output
- Debug and deprecation code are now loaded independently of expl3 core
- `\file_compare_timestamp:nNn(TF)` now usable in expansion contexts
- Moved to stable:
  - `\bool_const:Nn`
  - `\dim_sign:n`
  - `\file_compare_timestamp:nNn(TF)`
  - FP `logb` operator
  - `\fp_sign:n`
  - `fparray` module
  - `\int_sign:n`
  - `\intarray_const_from_clist:Nn`
  - `\intarray_show:N`
  - `\ior_map_variable:NNn`
  - `\ior_str_map_variable:NNn`
  - `\mode_leave_vertical:`
  - `\prop_(g)set_from_clist:Nn`
  - `\prop_const_from_clist:Nn`
  - `\seq_const_from_clist:Nn`
  - `\seq_(g)shuffle:N`
  - `\sys_if_platform_unix:(TF)`
  - `\sys_if_platform_windows:(TF)`
  - `\sys_gset_rand_seed:`
  - `\sys_rand_seed:`
  - Shell access functions

### Fixed
- Key `.initial:n` property when combined with inherited keys (see #631)

## [2019-09-19]

### Fixed
- Loading Unicode data when some chars may be active (see #627)

## [2019-09-08]

### Fixed
- Missing internal variant (fixes #624)

## [2019-09-05]

### Added
- `\file_full_name:n`, `\file_mdfive_hash:n`, `\file_size:n`,
  `\file_timestamp:n`
- `\seq_map_tokens:Nn`, `\tl_map_tokens:nn`, `\tl_map_tokens:Nn`

### Changed
- Moved `\prop_map_tokens:Nn` to stable
- Generate chars with catcode as-supplied when case changing

## [2019-08-25]

### Added
- `\fp_if_nan:nTF`

### Changed
- Make round(.,nan)=nan with no "Invalid operation" error

### Fixed
- `\tl_rescan:nn` and `\tl_(g)set_rescan:Nnn` when single-line input
  contains a comment character (see #607)
- Final value of the variable in `\tl_map_variable:NNn` and
  `\clist_map_variable:NNn`.
- Remove duplicate keys in `\prop_set_from_keyval:Nn` (see #572)

## [2019-08-14]

### Deprecated
- `\c_term_ior`

### Fixed
- Coffin pole intersection in some cases (see #605)

## [2019-07-25]

### Fixed
- Loading for `expl3` with plain TeX

## [2019-07-01]

### Added
- Moved `l3str-convert` module to `l3kernel`

### Changed
- Ensure `\msg_fatal:nn` ends the TeX run if used inside an
  hbox (see #587)
- Moved backend code to a separate release schedule

### Fixed
- Handling of control sequences in key names (see #594)

## [2019-05-28]

### Added
- Experimental `\file_compare_timestamp:nNn(TF)`

### Changed
- Precedence of juxtaposition (implicit multiplication) in `l3fp`
  now different for keywords/variables and factors in parentheses

## [2019-05-09]

### Added
- Experimental driver-level interfaces for image inclusion
- Experimental `\ior_shell_open:Nn`

### Fixed
- Some issues in `dvisvgm` driver

## [2019-05-07]

### Added
- `.muskip_set:N` property

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
- `\(h|v)box_unpack_clear:N`, replaced by `\(h|v)box_unpack_drop:N`
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
- Handling of `\current@color` with `(x)dvipdfmx` (see #510)

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
- Implement `\tl_analysis_map_inline:nn`
- Implement `\exp_args_generate:n` to define new `\exp_args:N...`
  functions
- Low-level `\int_value:w` function
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
- Change `\int_rand:nn` (and rand_item functions) to better use
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

[Unreleased]: https://github.com/latex3/latex3/compare/2020-06-03...HEAD
[2020-06-03]: https://github.com/latex3/latex3/compare/2020-05-15...2020-06-03
[2020-05-15]: https://github.com/latex3/latex3/compare/2020-05-14...2020-05-15
[2020-05-14]: https://github.com/latex3/latex3/compare/2020-05-11...2020-05-14
[2020-05-11]: https://github.com/latex3/latex3/compare/2020-05-05...2020-05-11
[2020-05-05]: https://github.com/latex3/latex3/compare/2020-04-06...2020-05-05
[2020-04-06]: https://github.com/latex3/latex3/compare/2020-03-06...2020-04-06
[2020-03-06]: https://github.com/latex3/latex3/compare/2020-03-03...2020-03-06
[2020-03-03]: https://github.com/latex3/latex3/compare/2020-02-25...2020-03-03
[2020-02-25]: https://github.com/latex3/latex3/compare/2020-02-21...2020-02-25
[2020-02-21]: https://github.com/latex3/latex3/compare/2020-02-14...2020-02-21
[2020-02-14]: https://github.com/latex3/latex3/compare/2020-02-13...2020-02-14
[2020-02-13]: https://github.com/latex3/latex3/compare/2020-02-11...2020-02-13
[2020-02-11]: https://github.com/latex3/latex3/compare/2020-02-08...2020-02-11
[2020-02-08]: https://github.com/latex3/latex3/compare/2020-02-03...2020-02-08
[2020-02-03]: https://github.com/latex3/latex3/compare/2020-01-31...2020-02-03
[2020-01-31]: https://github.com/latex3/latex3/compare/2020-01-22...2020-01-31
[2020-01-22]: https://github.com/latex3/latex3/compare/2020-01-12...2020-01-22
[2020-01-12]: https://github.com/latex3/latex3/compare/2019-11-07...2020-01-12
[2019-11-07]: https://github.com/latex3/latex3/compare/2019-10-28...2019-11-07
[2019-10-28]: https://github.com/latex3/latex3/compare/2019-10-27...2019-10-28
[2019-10-27]: https://github.com/latex3/latex3/compare/2019-10-24...2019-10-27
[2019-10-24]: https://github.com/latex3/latex3/compare/2019-10-21...2019-10-24
[2019-10-21]: https://github.com/latex3/latex3/compare/2019-10-14...2019-10-21
[2019-10-14]: https://github.com/latex3/latex3/compare/2019-10-11...2019-10-14
[2019-10-11]: https://github.com/latex3/latex3/compare/2019-10-02...2019-10-11
[2019-10-02]: https://github.com/latex3/latex3/compare/2019-09-30...2019-10-02
[2019-09-30]: https://github.com/latex3/latex3/compare/2019-09-28...2019-09-30
[2019-09-28]: https://github.com/latex3/latex3/compare/2019-09-19...2019-09-28
[2019-09-19]: https://github.com/latex3/latex3/compare/2019-09-08...2019-09-19
[2019-09-08]: https://github.com/latex3/latex3/compare/2019-09-05...2019-09-08
[2019-09-05]: https://github.com/latex3/latex3/compare/2019-08-25...2019-09-05
[2019-08-25]: https://github.com/latex3/latex3/compare/2019-08-14...2019-08-25
[2019-08-14]: https://github.com/latex3/latex3/compare/2019-07-25...2019-08-14
[2019-07-25]: https://github.com/latex3/latex3/compare/2019-07-01...2019-07-25
[2019-07-01]: https://github.com/latex3/latex3/compare/2019-05-28...2019-07-01
[2019-05-28]: https://github.com/latex3/latex3/compare/2019-05-09...2019-05-28
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
