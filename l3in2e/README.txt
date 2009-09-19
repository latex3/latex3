
   An Experimental LaTeX3 Programming Convention
   =============================================

   2009/08/02


WHERE TO GET IT
---------------

The files in this distribution represent a snapshot of selected files
from the Subversion (SVN) repository of the LaTeX3 Project.

To obtain current versions of the files, visit
<http://www.latex-project.org/code.html> which contains further
instructions.

OVERVIEW
--------

The files of the expl3 bundle provide a low-level API for TeX
programmers with special syntax conventions, completely separating it
from document level syntax. Hence, the commands provided are not
intended for use at the document level nor for use in describing
design layouts in document class files.

This API provides the foundation on which the LaTeX3 kernel and other
advanced extensions are built. Special care has been taken so that
they can be used within a LaTeX2e context as regular packages.

While expl3 is still experimental, the bundle is now regarded as
broadly stable. The syntax conventions and functions provided are now
ready for wider use. There may still be changes to some functions, but
these will be minor when compared to the scope of expl3.


THE GUILTY PERSONS
------------------

   Frank Mittelbach, Denys Duchier, Johannes Braams, Michael Downes,
   David Carlisle, Alan Jeffrey, Chris Rowley, Rainer Schoepf 
   Javier Bezos, Morten Hoegholm, Thomas Lotze, Will Robertson,
   Joseph Wright


DISCUSSION
----------

Discussion concerning the approach, suggestions for improvements, 
changes, additions, etc. should be addressed to the list LATEX-L. 

You can subscribe to this list by sending mail to

  listserv@urz.uni-heidelberg.de

with the body containing

  subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>


BUGS
----

If you find a real bug that makes a package stop working you can
report it via the standard LaTeX bug reporting mechanism of the LaTeX
distribution (see bugs.txt there) using the category "Experimental
LaTeX kernel".  However please do *not* use this method for
suggestions / comments / improvements / etc. For this the list LATEX-L
should be used instead.


MANIFEST
--------

The following packages are in this release.

l3names
=======

Documents the general naming scheme, and gives new names to all of the 
TeX primitives.

l3basics
========

Some basic definitions that are used by the other packages.

l3chk
=====

Functions that check definitions. (Comparable to LaTeX2's 
\newcommand/\renewcommand.)

l3alloc
=======

Generic functions for allocating registers.

l3toks
======

TeX's token registers.  (Can be compiled with checking enabled.)

l3tl
=====

Token Lists and Token List variables, a basic LaTeX3 datatype for 
storing token lists. (These are essentially macros with no arguments.)
The module also provides functions for arbitrary token lists. 
(Package can be compiled with checking enabled.)

l3expan
=======

The argument expansion module. One of the main features of the 
language proposed here is a systematic treatment of the handling of 
argument expansion. The basic functions for preprocessing command 
arguments are defined here.

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

l3msg
=====

Module providing a new mechanism to provide user messages.

l3calc
=====

Module for using infix notation for the built-in register types
(lengths and counters).

l3keyval
=====

Module for extracting data from a key=val list for further processing.

l3keys
=====

Module for defining keys at a higher level than l3keyval; intended as
the main programmer's interface for creating keyval settings and 
arguments.

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

l3format.ins
============

Process with plain TeX or LaTeX2e to generate the experimental
format file lbase.ltx and its companion lbase.ini.
Then run

  pdfetex --ini "*lbase.ini" 

to produce the experimental format. 

=====================================================================

source3.tex
===========

This file contains an introduction to the expl3 programming language
followed by the full typeset documentation and code listing for each
expl3 module.

To compile source3.pdf, ensure that l3doc.cls is installed or at least
present in the same directory (run `tex l3doc.dtx` to extract it if
necessary), then execute the following:

    pdflatex source3 
    makeindex -s l3doc.ist -o source3.ind source3.idx
    pdflatex source3 
    pdflatex source3 

This typesets the documentation, then generates the index, and then
requires one or two more compilations to fully resolve the cross-references.
  

expl3.dtx
=========

This provides a single "load point" for the entire expl3 bundle.
Running pdflatex expl3.dtx will produce a general overview document
explaining the basics of expl3 programming.

=====================================================================

--- Copyright 1998 -- 2009 The LaTeX3 Project. All rights reserved ---

