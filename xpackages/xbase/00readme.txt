
   Experimental Packages Demonstrating
   A Possible LaTeX3 Programming Convention
   ========================================

   2008/06/20


WHERE TO GET IT
---------------

The current version of these packages can be obtained by following the
instructions at <http://www.latex-project.org/code.html>.

OVERVIEW
--------

The xbase bundle provides the packages xparse and template, and the
support package ldcsetup.

The packages require expl3 to be installed.

The xparse provides a high-level interface for declaring document
commands, e.g., a uniform way to define commands taking optional
arguments, optional stars (and others), mandatory arguments and more.

The template package provides an interface for defining generic
functions using a key=val syntax.

The ldcsetup package used to establish prototype LaTeX3 coding conventions,
needed by xparse and xbase, but is now slowly being stripped in favor
of functionality added to expl3.


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
report it via the standard LaTeX bug reporting mechanism of the LaTeX
distribution (see bugs.txt there) using the category "Experimental
LaTeX kernel".  However please do *not* use this method for
suggestions / comments / improvements / etc. For this the list LATEX-L
should be used instead.

Also please don't expect these package to work with *any* code that
floats around in the LaTeX2e world. :-)


--- Copyright 1998 -- 2008
    The LaTeX3 Project.  All rights reserved ---
