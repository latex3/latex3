
   Experimental LaTeX3 High-Level Concepts
   =======================================

   2011/08/14


WHERE TO GET IT
---------------

The files in this distribution represent a snapshot of selected files
from the Subversion (SVN) repository of the LaTeX3 Project.

To obtain current versions of the files, visit
<http://www.latex-project.org/code.html> which contains further
instructions.

OVERVIEW
--------

The l3experimental packages are a collection of experimental implementations
for aspects of the LaTeX3 kernel, dealing with higher-level ideas such as the
Designer Interface. Some of them work as stand alone packages, providing new
functionality, and can be used on top of LaTeX2e with no changes to the
existing kernel. Others go further, and redefine LaTeX2e internals to provide
better methods for managing certain constructs. The packages in the collection
are under active development and the interfaces may change.

Currently included in the CTAN release of l3experimental are the following
bundles:
 * l3dt
 * l3sort
 * l3str
 * xcoffins
 * xgalley

l3dt
----

A 'data table' is a method of storing data in a spreadsheet-like format,
with rows and fields. This module provides the basic management structures
needed to work with data tables, including the ability to map to fields
on a row-by-row basis.

l3sort
------

Ordered variables content (in tl, clist or seq variables) may be sorted
in a flexible manner using the l3sort module. The definition of how to sort
two items is provided by the programmer at the point at which the sort is
carried out. Internally, the sorting algorithm is designed to take advantage
of TeX token registers to allow a high performance and scalable sort.

l3str
-----

A 'string' in TeX terms is a token list in which all of the tokens have
category code 12 ('other'), with the exception of spaces which have the
category code 10 ('space'). The l3str bundle consists of two parts. The
first is l3str itself. This is a collection of functions to act on strings,
including for manipulations such as UTF8 mappings in pdfTeX. The second
part of the bundle is l3regex, a regular expression search-and-replace
implementation written in TeX primitives. The regex module works on a string
basis, ignoring category codes.

xcoffins
--------

A _coffin_ is a 'box with handles': a data structure which comprises
both a TeX box and associated information to allow controlled typesetting.
The xcoffins package provides a high-level interface for manipulating
coffins. This is supported by the lower-level l3coffins package, which
provides the data structure.

xgalley
-------

In LaTeX3 terminology a galley is a rectangular area which receives
text and other material filling it from top. The vertically extend of
a galley is normally not restricted: instead certain chunks are taken
off the top of an already partially filled galley to form columns or
similar areas on a page. This process is typically asynchronous but
there are ways to control or change its behaviour. The xgalley module
provides a mechanism for filling galleys and controlling the spacing,
hyphenation and justification within them.

DISCUSSION
----------

Discussion concerning the approach, suggestions for improvements,
changes, additions, etc. should be addressed to the list LaTeX-L.

You can subscribe to this list by sending mail to

  listserv@urz.uni-heidelberg.de

with the body containing

  subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>

BUGS
----

The issue tracker for LaTeX3 bugs is currently located at

  https://github.com/latex3/svn-mirror/issues

Please report specific issues with LaTeX3 code there. More general
discussion should be directed to the LaTeX-L lists.

--- Copyright 1998 -- 2011
    The LaTeX3 Project.  All rights reserved ---
