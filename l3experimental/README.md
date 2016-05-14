Experimental LaTeX3 Concepts
============================

Release 2016/05/14 (r6495)

Overview
--------

The `l3experimental` packages are a collection of experimental implementations
for aspects of the LaTeX3 kernel, dealing with higher-level ideas such as the
Designer Interface. Some of them work as stand alone packages, providing new
functionality, and can be used on top of LaTeX2e with no changes to the
existing kernel. Others go further, and redefine LaTeX2e internals to provide
better methods for managing certain constructs. The packages in the collection
are under active development and the interfaces may change.

All of the material in the collection requires the LaTeX3 base layer package
[`l3kernel`](http://ctan.org/pkg/l3kernel). The two packages must be installed
in matching versions: if you update `l3experimental`, make sure that `l3kernel` is
updated at the same time.

Currently included in the CTAN release of l3experimental are the following
bundles:
* `l3sort`
* `l3str`
* `xcoffins`
* `xgalley`

`l3sort`
--------

Ordered variables content (in `tl`, `clist` or `seq` variables) may be sorted
in a flexible manner using the `l3sort` module. The definition of how to sort
two items is provided by the programmer at the point at which the sort is
carried out. Internally, the sorting algorithm is designed to take advantage
of TeX token registers to allow a high performance and scalable sort.

`l3str`
-------

A 'string' in TeX terms is a token list in which all of the tokens have
category code 12 ('other'), with the exception of spaces which have the
category code 10 ('space'). The `l3str` bundle consists of two parts. The
first is `l3str` itself. This is a collection of functions to act on strings,
including for manipulations such as UTF8 mappings in pdfTeX. The second
part of the bundle is `l3regex`, a regular expression search-and-replace
implementation written in TeX primitives. The regex module works on token
lists, and is part of `l3str` (currently) for historical reasons: the team
anticipate splitting the two in the future.

`xcoffins`
----------

A _coffin_ is a 'box with handles': a data structure which comprises
both a TeX box and associated information to allow controlled typesetting.
The `xcoffins` package provides a high-level interface for manipulating
coffins. This is supported by the lower-level `l3coffins` package, which
provides the data structure.

`xgalley`
---------

In LaTeX3 terminology a galley is a rectangular area which receives
text and other material filling it from top. The vertically extend of
a galley is normally not restricted: instead certain chunks are taken
off the top of an already partially filled galley to form columns or
similar areas on a page. This process is typically asynchronous but
there are ways to control or change its behaviour. The xgalley module
provides a mechanism for filling galleys and controlling the spacing,
hyphenation and justification within them.

Discussion
----------

Discussion concerning the approach, suggestions for improvements,
changes, additions, _etc._ should be addressed to the list
[LaTeX-L](http://news.gmane.org/group/gmane.comp.tex.latex.latex3).

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

The LaTeX3 Project
------------------

Development of LaTeX3 is carried out by
[The LaTeX3 Project](http://www.latex-project.org/latex3.html). Currently,
the team members are

* Johannes Braams
* David Carlisle
* Robin Fairbairns
* Morten Høgholm
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
* Alan Jeffrey
* Martin Schröder

The development team can be contacted
by e-mail: <latex-team@latex-project.org>; for general LaTeX3 discussion
the [LaTeX-L list](#Discussion) should be used.

-----

<p>Copyright (C) 1998-2011,2015 The LaTeX3 Project <br />
<a href="http://latex-project.org/">http://latex-project.org/</a> <br />
All rights reserved.</p>
