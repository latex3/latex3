LaTeX3 High-Level Concepts
==========================

Release 2022-01-12

Overview
--------

The `l3packages` collection contains implementations for aspects of the
LaTeX3 kernel, dealing with higher-level ideas such as the Designer Interface.
The packages here are considered broadly stable (The LaTeX Project does not
expect the interfaces to alter radically). These packages are build on LaTeX2e
conventions at the interface level, and so may not migrate in the current form
to a stand-alone LaTeX3 format.

All of the material in the collection requires the LaTeX3 base layer package
[`l3kernel`](http://ctan.org/pkg/l3kernel). The two packages must be installed
in matching versions: if you update `l3packages`, make sure that `l3kernel` is
updated at the same time.

Currently included in the CTAN release of `l3packages` are the following
bundles:
* `l3keys2e`
* `xfp`     (from 2022-06-01 part of the LaTeX format)
* `xfrac`
* `xparse`
* `xtemplate`

`l3keys2e`
----------

The `l3keys2e` package allows keys defined using `l3keys` to be used as package
and class options with LaTeX2e. This is tied to the method the existing kernel
uses for processing options, and so it is likely that a stand-alone LaTeX3
kernel will use a very different approach.

`xfp`
-----

The `xfp` package provides a document-level interface for the LaTeX3
FPU. As such, it is a wrapper around the core `\fp_eval:n` function
but does not require code syntax. It provides the expandable command
`\fpeval`, which can be used inside for example `\edef` or contexts
where TeX requires a number.
From 2022-06-01 release if LaTeX this will be included in the format
so that the package  doesn't need loading any longer.

`xfrac`
-------

The `xfrac` package uses the interface defined by `xtemplate` to provide
flexible split-level fractions _via_ the `\sfrac` macro. This is both a
demonstration of the power of the template concept and also a useful addition
to the available functionality in LaTeX2e.

`xparse` (deprecated)
-------

The `xparse` package provides a high-level interface for declaring document
commands, e.g., a uniform way to define commands taking optional arguments,
optional stars (and others), mandatory arguments and more.

The development of `xparse` moved to the
[LaTeX2e repository](https://github.com/latex3/latex2e) as `ltcmd`, which is
preloaded in the LaTeX format, and the code for `xparse` in this repository
contains only the deprecated argument types `G`, `l`, and `u`.

`xtemplate`
-----------

The `xtemplate` package provides an interface for defining generic
functions using a key=val syntax. This is designed to be
"self-documenting", with the key definitions providing information
on how they are to be used.

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
