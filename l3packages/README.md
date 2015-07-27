LaTeX3 High-Level Concepts
==========================

Overview
--------

The `l3packages` collection is contains implementations for aspects of the
LaTeX3 kernel, dealing with higher-level ideas such as the Designer Interface.
The packages here are considered broadly stable (The LaTeX3 Project does not
expect the interfaces to alter radically). These packages are build on LaTeX2e
conventions at the interface level, and so may not migrate in the current form
to a stand-alone LaTeX3 format.

All of the material in the collection requires the LaTeX3 base layer package
[`l3kernel`](http://ctan.org/pkg/l3kernel). The two packages must be installed
in matching versions: if you update l3packages, make sure that `l3kernel` is
updated at the same time.

Currently included in the CTAN release of `l3packages` are the following
bundles:
 * `l3keys2e`
 * `xfrac`
 * `xparse`
 * `xtemplate`

`l3keys2e`
----------

The `l3keys2e` package allows keys defined using `l3keys` to be used as package
and class options with LaTeX2e. This is tied to the method the existing kernel
uses for processing options, and so it is likely that a stand-alone LaTeX3
kernel will use a very different approach.

`xfrac`
-------

The `xfrac` package uses the interface defined by `xtemplate` to provide
flexible split-level fractions _via_ the `\sfrac` macro. This is both a
demonstration of the power of the template concept and also a useful addition
to the available functionality in LaTeX2e.

`xparse`
-------

The `xparse` package provides a high-level interface for declaring document
commands, e.g., a uniform way to define commands taking optional arguments,
optional stars (and others), mandatory arguments and more.

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
the [LaTeX-L list](http://news.gmane.org/group/gmane.comp.tex.latex.latex3)
should be used.

--- Copyright 1998-2011
    The LaTeX3 Project.  All rights reserved ---