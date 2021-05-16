# Changelog
All notable changes to the `l3kernel` bundle since the start of 2018
will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
this project uses date-based 'snapshot' version identifiers.

## [Unreleased]

### Added
- `\prop_to_keyval:N`
- Support for validity scope for keys

### Changed
- Allow indirect conversions between colorspaces though fallback models
- Move some color functions from `l3backend`

### Removed
- Lua functions in `l3kernel` table

## [2021-11-22]

### Added
- Support for legacy `if` switches in `l3keys`

### Changed
- Documentation improvements
- Implementation of `intarray` data type with LuaTeX
- Better support for LuaMetaTeX

## [2021-11-12]

### Fixed
- DeviceN colorspace conversions with alternative model RGB

### Added
- `.str_set:N`, etc., key properties (issue #1007)
- `\bool_to_str:n` (issue #1010)

### Changed
- `\prop_..._from_keyval:Nn` functions now support active comma or
  equal sign (pull #1012)

## [2021-10-18]

### Added
- Support for ICC-based color profiles
- `\color_profile_apply:nn`

## [2021-10-17]

### Changed
- Better DeviceN support

## [2021-10-12]

### Fixed
- Global assignments for `\box_gresize_to_ht_plus_dp:Nn`
  and `\coffin_gattach:NnnNnnnn`
- Conversion of DeviceN colors to device fallback

## [2021-08-27]

### Changed
- Formatting of expandable errors (issue #931)
- Internal code for kernel messages

## [2021-07-12]

### Fixed
- Handling of multiple color models (issue #962)

### Removed
- Functions marked for removal end-2020

## [2021-06-18]

### Fixed
- Local assignment to `\g__sys_backend_tl`
- Incorrect internal function name (issue #939)
- Case-changing exceptions for (u)pTeX (issue #939)
- Low-level error if accent commands are not followed by
  letter when case changing (see #946)

## [2021-06-01]

### Fixed
- Loading when `\expanded` is not available

## [2021-05-27]

### Fixed
- Correctly detect local formats in `Mismatched LaTeX support files` error.

## [2021-05-25]

### Added
- `\msg_note:nnnnnn` (issue #911)
- `\str_compare:nNnTF` (issue #927)
- `\sys_timer:`
- `\prop_concat:NNN`, `\prop_put_from_keyval:Nn` (issue #924)
- Functions to show and log various datatypes (issue #241):
  `\coffin_show:Nnn`, `\coffin_show:N`, `\coffin_log:Nnn`, `\coffin_log:N`,
  `\color_log:n`, `\group_show_list:`, `\group_log_list:`,
  `\ior_show:N`, `\ior_log:N`, `\iow_show:N`, `\iow_log:N`,
  `\tl_log_analysis:N`, `\tl_log_analysis:n`
- `\legacy_if_set_true:n`, `\legacy_if_set_false:n`, `\legacy_if_set:nn`
- Matching multiple regex at the same time (issue #433):
  `\regex_case_match:nn(TF)`,
  `\regex_case_replace_once:nN(TF)`,
  `\regex_case_replace_all:nN(TF)`

### Fixed
- Checking brace balance in all regex functions (issue #377)
- Removing duplicates in clists when items contain commas (issue #917)

### Changed
- Slight speed up in some elementary int/dim/skip/muskip operations and
  in setting tl or clist variables equal.
- Speed up mapping functions in l3clist, l3prop, l3seq, l3tl

## [2021-05-11]

### Added
- `\cctab_item:Nn` (issue #880)
- `\clist_use:nnnn` and `\clist_use:nn` (issue #561)

### Fixed
- Loading of backend in generic DVI mode (issue #905)
- Make `\keyval_parse:nnn` alignment-safe (issue #896)
- Control sequences and category codes in regex replacements (issue #909)

### Changed
- Speed up `\group_align_safe_begin:` (pull #906)

## [2021-05-07]

### Added
- Color export in comma-separated format
- `\ur{...}` escape in `l3regex` to compose regexes
- `\seq_set_split_keep_spaces:Nnn` (see #784)
- `\seq_set_item:Nnn(TF)` and `\seq_pop_item:NnN(TF)`
- `\box_ht_plus_dp:N` (issue #899)
- `\clist_map_tokens:nn`, `\clist_map_tokens:Nn`,
  `\str_map_tokens:nn`, `\str_map_tokens:Nn`

### Changed
- Use prevailing catcodes instead of string in regex replacement (issue #621)
  (*Breaking change*)
- `\__kernel_file_name_sanitize:n` now uses a faster `\csname`-based
  approach to expand the file name
- Improved performance for basic conditionals
- `\pdf_version_gset:n` support for `dvips`
- Improve handling of `\exp_not:n` in `\text_expand:n` (issue #875)
- `\file_full_name:n` now avoids calling `\pdffilesize` primitive multiple times
  on the same file
- Show printable characters explicitly in `\regex_show:n`
- Regex replacement now errors when using a submatch (`\1` etc) for which
  the regex has too few groups
- Showing complex datatypes now validates their internal structure (issue #884)
- Indexing in l3doc: all page references before codeline references,
  improve target placement, solve pdfTeX and makeindex warnings

### Fixed
- Evalutate integer constants only once (issue #861)
- Detect `\ior_map_inline:Nn` calls on undefined streams (issue #194)

### Deprecated
- `l3docstrip` converted to a stub which simply loads DocStrip: use
   the latter directly

## [2021-02-18]

### Added
- `l3color`: Moved from `l3experimental`
- `l3pdf`: Moved from `l3experimental`
- `default` alias to str_convert

### Changed
- Re-ordered `interface3` documentation
- Moved `msg_show:nn(nnnn)` to stable

## [2021-02-06]

### Changed
- Use new (internal) interface for kerns

## [2021-02-02]

### Added
- `\c_zero_str`

## [2021-01-09]

### Added
- `\keyval_parse:nnn`

### Changed
- `\keyval_parse:NNn` is set equal to `\keyval_parse:nnn`

### Fixed
- Handling of encoding-specfic commands in `\text_purify:n`

## [2020-12-07]

### Fixed
- `\peek_analysis_map_inline:n` with spaces and braces

## [2020-12-05]

### Fixed
- Setting of line width in vertical coffins in LaTeX

## [2020-12-03]

### Added
- `\peek_analysis_map_inline:n`
- `\peek_regex:nTF`, `\peek_regex_remove_once:nTF`, and
  `\peek_regex_replace_once:nnTF`
- `\token_case_catcode:NnTF`, `\token_case_charcode:NnTF`, and
  `\token_case_meaning:NnTF`

### Changed
- Extend `\text_expand:n` to cover `\@protected@testopt`
- Extend `\text_purify:n` to cover `\@protected@testopt`

## [2020-10-27]

### Added
-  `\token_if_font_selection:N(TF)` (see #806)

### Fixed
- Avoid relying on braced `\input` primitive syntax
- Correct expansion of environments in `\text_purify:n`
- Some aspects of `cctab` setup with 8-bit engines(issue #814)

### Changed
- Improved performance for `tl` functions
- Extend case changer to cover all of Greek with pdfTeX

## [2020-10-05]

### Fixed
- Correctly detect LaTeX when pre-loading expl3 and setting up
  case changer
- Lua emulation of \strcmp (issue #813)

## [2020-09-24]

### Changed
- Use Lua pseudo-primitives instead of `\directlua`
- `\token_if_primitive:N(TF)` now reports pseudo-primitives as primitives in LuaTeX

## [2020-09-06]

### Fixed
- Loading in generic mode (issue #800)

## [2020-09-03]

### Fixed
- Save primitive definition of `\pdfoutput` with CSLaTeX

## [2020-09-01]

### Added
- `\hbox_overlap_center:n`

### Changed
- Backend setting for direct PDF output
- Backend setting for XeTeX support

### Deprecated
- Backend setting `pdfmode`

### Fixed
- `\file_compare_timestamp:nNn(TF)` in LuaTeX (issue #792)
- Text case changing and expansion where an excluded command is equivalent
  to `\use:n`

## [2020-08-07]

### Changed
- Color selection implementation
- Performance enhancements for `\keys_set:nn`

### Fixed
- Loading generically on ConTeXt (issue #783)

## [2020-07-17]

### Added
- `l3cctab` module for using category code tables
- `\file_parse_full_name:n` and `\file_parse_full_name_apply:nN`
- Additional `\prop_put:Nnn` variants
- `\seq_set_map_x:NNn`
- `\msg_term:nn(nnnn)`

### Fixed
- File lookup with `\input@path`
- 8-bit encodings in `\str_set_convert:Nnnn`

### Changed
- Implementation of `\file_parse_full_name:nNNN` now uses
  `\file_parse_full_name:n` internally
- `\seq_set_map:NNn` no longer `x`-expands `<inline function>`
  (`\seq_set_map_x:NNn` now does that).  Both moved to stable.

### Removed
- Functions deprecated at end of 2019

### Deprecated
- `\str_declare_eight_bit_encoding:nnn`

## [2020-06-18]

### Changed
- Use `scn` operator for separations
- Internal color model
- Internal performance enhancements
- Moved `\msg_expandable_error:nn(nnnn)` to stable.
- Moved `\seq_indexed_map_inline:Nn` and `\seq_indexed_map_function:Nn`
  to stable as `\seq_map_indexed_inline:Nn` and `\seq_map_indexed_function:Nn`.
- Internal changes to `expl3` to allow loading earlier in LaTeX2e.

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
- `\bool_case_true:n(TF)` and `\bool_case_false:n(TF)`
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
- Correct date string in `expl3.dtx`
- Correct `\c_sys_engine_version_str` when using XeTeX

## [2018-05-12]

### Added
- Define `\c_zero_int` and `\c_one_int`
- Implement `\c_sys_engine_version_str`
- Implement `\seq_indexed_map_function/inline`
- Implement `\intarray_gzero:N`
- Implement `\intarray_const_from_clist:Nn`
- Implement `\bool_set_inverse:N`
- Implement `\bool_xor:nnTF` instead of just `\bool_xor_p:nn`
- Implement candidate `\int_rand:n`
- Implement `\intarray_gset_rand:Nnn`
- Implement candidate `l3fparray` module

## Changed
- Update minimal required versions of XeTeX and LuaTeX
- Deprecate named integer constants `\c_zero`. etc.
- Move all primitives to `\tex_...:D namespace`,
  deprecating older engine-dependent prefixes
- Several internal optimisations

### Fixed
- Expand boolean expression before calling `\chardef` (fixes #461)

### Removed
- Remove undocumented `\fp_function:Nw` and `\fp_new_function:Npn`

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
- Step functions have been added for dim variables,
  e.g. `\dim_step_inline:nnnn`

[Unreleased]: https://github.com/latex3/latex3/compare/2021-11-22...HEAD
[2021-11-22]: https://github.com/latex3/latex3/compare/2021-11-12...2021-11-22
[2021-11-12]: https://github.com/latex3/latex3/compare/2021-10-18...2021-11-12
[2021-10-18]: https://github.com/latex3/latex3/compare/2021-10-17...2021-10-18
[2021-10-17]: https://github.com/latex3/latex3/compare/2021-10-12...2021-10-17
[2021-10-12]: https://github.com/latex3/latex3/compare/2021-08-27...2021-10-12
[2021-08-27]: https://github.com/latex3/latex3/compare/2021-07-12...2021-08-27
[2021-07-12]: https://github.com/latex3/latex3/compare/2021-06-18...2021-07-12
[2021-06-18]: https://github.com/latex3/latex3/compare/2021-06-01...2021-06-18
[2021-06-01]: https://github.com/latex3/latex3/compare/2021-05-27...2021-06-01
[2021-05-27]: https://github.com/latex3/latex3/compare/2021-05-25...2021-05-27
[2021-05-25]: https://github.com/latex3/latex3/compare/2021-05-11...2021-05-25
[2021-05-11]: https://github.com/latex3/latex3/compare/2021-05-07...2021-05-11
[2021-05-07]: https://github.com/latex3/latex3/compare/2021-02-18...2021-05-07
[2021-02-18]: https://github.com/latex3/latex3/compare/2021-02-06...2021-02-18
[2021-02-06]: https://github.com/latex3/latex3/compare/2021-02-02...2021-02-06
[2021-02-02]: https://github.com/latex3/latex3/compare/2021-01-09...2021-02-02
[2021-01-09]: https://github.com/latex3/latex3/compare/2020-12-07...2021-01-09
[2020-12-07]: https://github.com/latex3/latex3/compare/2020-12-05...2020-12-07
[2020-12-05]: https://github.com/latex3/latex3/compare/2020-12-03...2020-12-05
[2020-12-03]: https://github.com/latex3/latex3/compare/2020-10-27...2020-12-03
[2020-10-27]: https://github.com/latex3/latex3/compare/2020-10-05...2020-10-27
[2020-10-05]: https://github.com/latex3/latex3/compare/2020-09-24...2020-10-05
[2020-09-24]: https://github.com/latex3/latex3/compare/2020-09-06...2020-09-24
[2020-09-06]: https://github.com/latex3/latex3/compare/2020-09-03...2020-09-06
[2020-09-03]: https://github.com/latex3/latex3/compare/2020-09-01...2020-09-03
[2020-09-01]: https://github.com/latex3/latex3/compare/2020-08-07...2020-09-01
[2020-08-07]: https://github.com/latex3/latex3/compare/2020-07-17...2020-08-07
[2020-07-17]: https://github.com/latex3/latex3/compare/2020-06-18...2020-07-17
[2020-06-18]: https://github.com/latex3/latex3/compare/2020-06-03...2020-06-18
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
