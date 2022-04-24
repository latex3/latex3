Experimental LaTeX3 Concepts
============================

Release 2022-04-20

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
* `l3benchmark`
* `l3bitset`
* `l3draw`
* `l3graphics`
* `l3opacity`
* `l3str`
* `l3sys-shell`
* `xcoffins`
* `xgalley`

`l3benchmark`
-------------

This module provides support for benchmarking the performance of code.

`l3bitset`
-------------

This module provides a `bitset` data type, a vector of bits, which can be set
and unset using their individual index in the vector, or using names assigned to
each position in the vector.  The bitset can be returned as a string of bits or
as a decimal integer.

`l3draw`
--------

This module provides a code-level interface for constructing drawings. The
interfaces are heavily inspired by the `pgf` layer of the widely-used
TikZ system.

`l3graphics`
-------------

This module provides interfaces for the inclusion of graphics files
in documents, similar to the `graphics` package.

`l3opacity`
-------

This module provides support for opacity in PDF output.

`l3str`
-------

A 'string' in TeX terms is a token list in which all of the tokens have
category code 12 ('other'), with the exception of spaces which have the
category code 10 ('space'). The `l3str-format` module provides methods
for formatting such strings.

`l3sys-shell`
-------------

This module provides abstractions for common shell functions, e.g. file
deletion and copying.

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

<p>Copyright (C) 1998-2004,2008-2012,2014-2022 The LaTeX Project <br />
<a href="http://latex-project.org/">http://latex-project.org/</a> <br />
All rights reserved.</p>
