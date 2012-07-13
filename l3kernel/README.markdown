LaTeX3 Programming Conventions
==============================

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

The `l3kernel` bundle requires the e-TeX extensions and the functionality
of the `\pdfstrcmp` primitive. As a result, the bundle will only work
with the following engines:

 - pdfTeX v1.30 or later
 - XeTeX v0.9994 or later
 - LuaTeX v0.40 or later

pdfTeX v1.30 was released in 2005, and so any recent TeX distribution
will support `l3kernel`. Both XeTeX and LuaTeX have developed more
actively over the past few years, and for this reason only recent
releases of these engines are supported.

Discussion
----------

Discussion concerning the approach, suggestions for improvements,
changes, additions, _etc._ should be addressed to the list
[LaTeX-L](http://news.gmane.org/group/gmane.comp.tex.latex.latex3).

You can subscribe to this list by sending mail to

  listserv@urz.uni-heidelberg.de

with the body containing

  subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>

Bugs
----

The issue tracker for LaTeX3 bugs is currently located at

  https://github.com/latex3/svn-mirror/issues

Please report specific issues with LaTeX3 code there. More general
discussion should be directed to the LaTeX-L lists.

The LaTeX3 Project
------------------

Development of LaTeX3 is carried out by
[The LaTeX3 Project](http://www.latex-project.org/latex3.html). Currently,
the team members are

  * Johannes Braams
  * David Carlisle
  * Robin Fairbairns
  * Bruno Le Floch
  * Thomas Lotze
  * Frank Mittelbach
  * Will Robertson
  * Chris Rowley
  * Rainer Schöpf
  * Joseph Wright

Former members of The LaTeX3 Project team were

  * Michael Downes
  * Denys Duchier
  * Morten Høgholm
  * Alan Jeffrey
  * Martin Schröder

The development team can be contacted
by e-mail: <latex-team@latex-project.org>; for general LaTeX3 discussion
the [LaTeX-L list](http://news.gmane.org/group/gmane.comp.tex.latex.latex3)
should be used.

-----

Copyright (C) 1998-2012 The LaTeX3 Project
All rights reserved