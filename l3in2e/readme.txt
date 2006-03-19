
   Experimental Packages Demonstrating
   A Possible LaTeX3 Programming Convention
   ========================================

   2006/03/19


OVERVIEW
--------

The packages in this directory implement a possible language for `low
level' programming in TeX.  The syntax conventions described here are NOT
intended either for use in documents or for use in describing design
layouts in document class files.

All aspects of these package are *experimental*. The names of the
packages, and the names of any commands that they define, may change
at any time.  They are being released in this form to allow public
discussion and comment.

Currently all the code is distributed in a format suitable for running
as LaTeX2e packages.  Further documentation may be produced by processing
either the individual .dtx files, or the file source3.tex with
LaTeX2e.  The packages may be installed by processing l3.ins with 
plain TeX or LaTeX.

This code has been developed over time and has been used in previous
versions for prototype implementations, experiments, etc. Its internal
documentation (in the .dtx files) reflects the age of parts of it; it
often contains personal comments and it sometimes refers to parts that
are  at present not distributed.  We kindly ask you to overlook its
deficiencies and inaccuracies --- if we had tried to clean this up it
would never have surfaced and, for the purpose of discussions and
comments, we hope its present form is adequate.


NOTE (docstrip version)
-----------------------
  
If   latex l3.ins
produces the `docstrip interactive mode' prompt:

  * First type the extension of your input file(s):  *
  \infileext=

Then your version of docstrip is too old.
Quit (eg by hitting `enter' to all questions) and get a newer
docstrip.tex. It must be at least version 2.4.

A suitable docstrip.tex may be found from `CTAN' archives such as
ftp.dante.de   tex-archive/macros/latex/unpacked/docstrip.tex

Docstrip is part of the base LaTeX distribution, so if you have
an old docstrip then your LaTeX is out of date and you may consider
getting the whole of that directory and re-installing LaTeX.
However you need to fetch only the file docstrip.tex to unpack
this expl3 distribution with your existing format.



THE GUILTY PERSONS
------------------

   Frank Mittelbach, Denys Duchier, Johannes Braams, Michael Downes,
   David Carlisle, Alan Jeffrey, Chris Rowley, Rainer Schoepf 
   Javier Bezos, Morten Hoegholm, Thomas Lotze


DISCUSSION
----------

Discussion concerning the approach, suggestions for improvements, changes,
additions, etc. should be addressed to the list LATEX-L. 

You can subscribe to this list by sending mail to

  listserv@urz.uni-heidelberg.de

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

l3alloc
=======

Generic functions for allocating registers.

l3toks
======

TeX's token registers.  (Can be compiled with checking enabled)

l3tlp
=====

Token List Pointers. A basic LaTeX3 datatype for storing token lists.
(These are essentially macros with no arguments.) The module also
provides functions for arbitrary token lists. (Package can be compiled
with checking enabled.)

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

l3clist
=======

A module implementing the handling of comma separated lists

l3prop
======

Property lists are the datatype for handling key/value assignments.

l3int
=====

Integer and fake integer registers. With eTeX/Omega becoming more and
more accessible this module is, at least in parts only of historical
significance.  (Can be compiled with checking enabled)

l3num
=====

Storing numbers as token-lists in macros

l3skip
======

Dealing with length registers

l3precom
=========

Low-level pointer-related code, with further checking and tracing.

l3io
====

Low-level input and ouput.

l3prg
=====

Experimental control structures. This covers booleans and various
other code.

l3box
=====

Low level box handling code

l3token
=====

Functions that investigate tokens and determine of which categories
they are. For instance, is the token in question expandable or not? Is
it a macro taking arguments?  Also functions for peeking ahead in the
token stream.

l3xref
=====

Module providing the low-level interface for cross references. This
module also contains a test file which is generated along with the
package.

l3messages
=====

Module providing a new mechanism to provide longer warning and error
messages based on storing the messages in external files.

=====================================================================

Install file
=============

l3.ins
======

Process with plain TeX or LaTeX2e to generate the experimental
packages.

=====================================================================

Experimental LaTeX3 Format
==========================

l3vers.dtx
==========

This file contains the version information and other release related
coding. 

l3final.dtx
===========

This file is reserved for the last minute coding for producing a
format (such as the dump instruction).

source3.tex
===========

Run this file with pdfLaTeX in extended mode:
pdflatex "*source3.tex" to produce the documentation.
Doing this will produce three extra files (source3.ist, l3doc.cfg and
l3full.cfg). The first of these is a style file for makeindex; the
others or configuration files for the documentation class.
If you want to full documentation including the code listings than
rename l3full.cfg to l3doc.cfg and run LaTeX again.
Alternatively, run (in extended mode)
  pdflatex "\PassOptionsToClass{full}{l3doc}\input{source3}"
After that run makeindex to produce the index, like so:
makeindex -s source3.ist source3
and rerun LaTeX.

l3format.ins
============

Process with plain TeX or LaTeX2e to generate the experimental
format file lbase.ltx and its companion lbase.ini.
The run pdfetex --ini "*lbase.ini" to produce the experimental
format. 

=====================================================================

Test Files
==========

Two test files show the expansion module at work.

test1.tex
=========

Test document showing the expansion module at work.

test2.tex
=========

The same test as the file test1, but this time the l3names package is
loaded with [removeoldnames]. This is useful for testing, but as it
breaks all LaTeX2 code, it is not so useful for documents.  (For
example {document} would generate an error.)  In this mode
\RequirePackage may be used to load further packages, as demonstrated
in this file, but any other LaTeX2 command is likely to fail.

test3.tex
=========

This tests the io and precomp modules.


=====================================================================

--- Copyright 1998 -- 2006
    The LaTeX3 Project.  All rights reserved ---

