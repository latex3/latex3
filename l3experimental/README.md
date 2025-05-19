Experimental LaTeX3 Concepts
============================

Release 2025-05-19

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
in matching versions: if you update `l3experimental`, make sure that `l3kernel`
is updated at the same time.

Currently included in the CTAN release of l3experimental are the following
bundles:
* `l3draw`
* `l3str`
* `xcoffins`
* `xgalley`

`l3draw`
--------

This module provides a code-level interface for constructing drawings. The
interfaces are heavily inspired by the `pgf` layer of the widely-used
TikZ system.

`l3str`
-------

A 'string' in TeX terms is a token list in which all of the tokens have
category code 12 ('other'), with the exception of spaces which have the
category code 10 ('space'). The `l3str-format` module provides methods
for formatting such strings.

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

Issues
------

The issue tracker for LaTeX3 is currently located
[on GitHub](https://github.com/latex3/latex3/issues).

The LaTeX Project
------------------

Development of LaTeX3 is carried out by
[The LaTeX Project](https://www.latex-project.org/latex3/).

-----

<p>Copyright (C) 1998-2004,2008-2012,2014-2025 The LaTeX Project <br />
<a href="http://latex-project.org/">http://latex-project.org/</a> <br />
All rights reserved.</p>
