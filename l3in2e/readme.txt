

   Experimental Packages Demonstrating
   A Possible LaTeX3 Programming Convention
   ========================================

   1998/04/17


OVERVIEW
--------

The packages in this directory implement a possible language for `low
level' programming in TeX. The syntax conventions described here are NOT
intended either for use in documents or for use in describing design
layouts in document class files.

All aspects of these package are *experimental*. The names of the
packages, and the names of any commands that they define, may change at
any time.  They are being released in this form to allow public
discussion and comment.

Currently all the code is distributed in a format suitable for running
as LaTeX2e packages, Further documentation may be produced by processing
the `dtx' file with LaTeX2e. The packages may be installed by processing
l3.ins with plain TeX or LaTeX.

This code has be developed over time and has been used in previous
version for prototype implementations, experiments, etc. Its internal
documentation (in the .dtx files) reflect the age of parts of it; it
often contains personal comments, sometimes refers to parts not being
distributed.  We kindly ask you to overlook its deficiencies and
inaccuracies --- if we had tried to clean this up it would never have
surfaced and, for the purpose of discussions and comments, we hope its
present form is adequate enough.


DISCUSSION
----------

Discussions about the approach, suggestions for improvements, changes,
additions, etc. should be addressed to the list LATEX-L. 

You can subscribe to this list by sending mail to

  listserv@vm.uni-heidelberg.de

with the body containing

  subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>


BUGS
----

If you find a real bug that makes a package stop working you can
report it via the standard latexbug.tex mechanism of the LaTeX
distribution (see bugs.txt there) using the category "l3exp". 
However please do *not* use this method for suggestions / comments /
improvements / etc. For this the list LATEX-L should be used instead.

Also please don't expect these package to work with *any* code that
floats around in the LaTeX2e world. :-)



MANIFEST
--------

The following packages are in this release:


l3names
=======

Documents the general naming scheme, and gives new names to all the TeX
primitives.

If this package is used with the option [removeoldnames] then the
original TeX primitive names (\hbox, \def, ...) are made *undefined* and
so free to be defined for other purposes if needed. Of course this
breaks almost all existing LaTeX2 code, but it may be used for testing
purposes, see test2.tex.

l3basics
========

Some basic definitions that are used by the other packages.

l3chk
=====

Functions that check definitions.
(Comparable to LaTeX2's \newcommand/\renewcommand.)

l3tlp
=====

Token List Pointers. A basic LaTeX3 datatype for storing token lists.
(These are essentially macros with no arguments.)
(Package can be compiled with checking enabled.)

l3expan
=======

The argument expansion module. One of the main features of the language
proposed here is a systematic treatment of the handling of argument
expansion. The basic functions for preprocessing command arguments are
defined here.

l3quark
=======

A `quark' is a command that is defined to expand to itself. So it may
not be directly used (it would generate an infinite loop) but has many
uses as special markers within LaTeX code.

l3seq
=====

A module implementing the basic list and stack datatypes.

l3prop
======

Property lists are the datatype for handling key/value assignments.

l3int
=====

Integer and fake integer registers. With eTeX becoming more and more
accessible this module is, at least in parts only of historical
significance.  (Can be compiled with checking enabled)

l3toks
======

TeX's token registers.  (Can be compiled with checking enabled)


====================================================================

Install file
=============

l3.ins
======

Process with plain TeX or LaTeX2e to generate the experimental packages.

=====================================================================

Test Files
==========

Two test files show the expansion module at work.

test1.tex
=========

Test document showing the expansion module at work.


test2.tex
=========

The same test as the file test1, but this time the l3names package
is loaded with [removeoldnames]. This is useful for testing, but as it
breaks all LaTeX2 code, it is not so useful for documents. (For example
\begin{document} would generate an error.) In this mode \RequirePackage
may be used to load further packages, as demonstrated in this file,
but any other LaTeX2 command is likely to fail.


