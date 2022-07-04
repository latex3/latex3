LaTeX3 Programming Conventions
==============================

Release 2022-07-04

Overview
--------

The files of the `l3kernel` bundle provide an API for TeX programmers
with defined syntax conventions, completely separating it from document level
syntax. Hence, the commands provided are not intended for use at the document
level nor for use in describing design layouts in document class files.

This API provides the foundation on which new additions to the LaTeX kernel and
other advanced extensions are built. The programming layer is designed to be
loaded as part of LaTeX2e format building or as a loaded package with plain TeX
or other formats.

The syntax and functionality provided by `l3kernel` is regarded by the LaTeX
team as stable. There may still be changes to some functions, but these will be
very minor when compared to the scope of `l3kernel`. In particular, no functions
will be removed, although some may be deprecated.

Programmers making use of `l3kernel` are *strongly* encouraged to subscribe to
the LaTeX-L mailing list (see below): announcements concerning the deprecation
or modification of functions are made on the list.

Requirements
------------

The `l3kernel` bundle requires the e-TeX extensions and a number of additional
'utility' primitives, almost all of which were first added to pdfTeX. In
particular, the functionality equivalent to the following pdfTeX primitives must
be available

- `\ifpdfprimitive`
- `\pdfcreationdate`
- `\pdfelapsedtime`
- `\pdffiledump`
- `\pdffilemoddate`
- `\pdffilesize`
- `\pdflastxpos`
- `\pdflastypos`
- `\pdfmdfivesum`
- `\pdfnormaldeviate`
- `\pdfpageheight`
- `\pdfpagewidth`
- `\pdfprimitive`
- `\pdfrandomseed`
- `\pdfresettimer`
- `\pdfsavepos`
- `\pdfsetrandomseed`
- `\pdfshellescape`
- `\pdfstrcmp`
- `\pdfuniformdeviate`

For ease of reference, these primitives will be referred to as the 'pdfTeX
utilities'. With the exception of `\expanded`, these have been present in pdfTeX
since the release of version 1.40.0 in 2007; `\expanded` was added for TeX Live
2019. Similarly, the full set of these utility primitives has been available in
XeTeX from the 2019 TeX Live release, and has always been available in LuaTeX
(some by Lua emulation). The Japanese pTeX and upTeX gained all of the above
(except `\ifincsname`) for TeX Live 2019 `\ifincsname` for TeX Live 2020.

At present, the `\expanded` primitive is emulated if unavailable. This code is
slow and imposes some coding restrictions. As such, it will be *removed* for TeX
Live 2022.

In addition to the above, engines which are fully Unicode-compatible
must provde the functionality of the following primitives, documented in the
LuaTeX manual

- `\Uchar`
- `\Ucharcat`
- `\Umathcode`

The existence of the primitive `\Umathcode` is used as the marker for Unicode
support.

Discussion
----------

Discussion concerning the approach, suggestions for improvements,
changes, additions, _etc._ should be addressed to the list
[LaTeX-L](https://listserv.uni-heidelberg.de/cgi-bin/wa?A0=LATEX-L).

You can subscribe to this list by sending mail to

    listserv@urz.uni-heidelberg.de

with the body containing

    subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>

Issues
------

The issue tracker for LaTeX3 is currently located
[on GitHub](https://github.com/latex3/latex3/issues).

Please report specific issues with LaTeX3 code there; more general
discussion should be directed to the [LaTeX-L list](#Discussion).

The LaTeX Project
------------------

Development of LaTeX3 is carried out by
[The LaTeX Project](https://www.latex-project.org/latex3/).

The development team can be contacted
by e-mail: <latex-team@latex-project.org>; for general LaTeX3 discussion
the [LaTeX-L list](#Discussion) should be used.

-----

<p>Copyright (C) 1998-2012,2015-2022 The LaTeX Project <br />
<a href="http://latex-project.org/">http://latex-project.org/</a> <br />
All rights reserved.</p>
