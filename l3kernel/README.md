LaTeX3 Programming Conventions
==============================

Release 2022-01-21

Overview
--------

The files of the `l3kernel` bundle provide a low-level API for TeX programmers
with special syntax conventions, completely separating it from document level
syntax. Hence, the commands provided are not intended for use at the document
level nor for use in describing design layouts in document class files.

This API provides the foundation on which the LaTeX3 kernel and other advanced
extensions are built. Special care has been taken so that they can be used
within a LaTeX2e context as regular packages.

While `l3kernel` is still experimental, the bundle is now regarded as broadly
stable. The syntax conventions and functions provided are now ready for wider
use. There may still be changes to some functions, but these will be minor when
compared to the scope of `l3kernel`.

Programmers making use of `l3kernel` are *strongly* encouraged to subscribe to
the LaTeX-L mailing list (see below): announcements concerning the deprecation
or modification of functions are made on the list.

Requirements
------------

The `l3kernel` bundle requires the e-TeX extensions and additional functionality
to support string comparisons, expandable character generation with arbitrary
category codes (for Unicode engines) and PDF support primitives (where direct
PDF generation is used). The bundle only works with the following engines:
* pdfTeX v1.40 or later
* XeTeX v0.99992 or later
* LuaTeX v1.10 or later
* e-(u)pTeX from mid-2012 onward

pdfTeX v1.40 was released in 2007, and so any recent TeX distribution
supports `l3kernel`. Both XeTeX and LuaTeX have developed more
actively over the past few years, and for this reason only recent
releases of these engines are supported.

(Engine developers should contact the team for detailed discussion about
primitive requirements.)

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
