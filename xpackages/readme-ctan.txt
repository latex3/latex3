
   Experimental LaTeX3 High-Level Concepts
   =======================================

   2009/11/25


WHERE TO GET IT
---------------

The files in this distribution represent a snapshot of selected files
from the Subversion (SVN) repository of the LaTeX3 Project.

To obtain current versions of the files, visit
<http://www.latex-project.org/code.html> which contains further
instructions.

OVERVIEW
--------

The xpackages are a collection of experimental implementations
for aspects of the LaTeX3 kernel, dealing with higher-level
ideas such as the Desginer Interface. Some of them work as stand
alone packages, providing new functionality, and can be used
on top of LaTeX2e with no changes to the existing kernel.
Others go further, and redefine LaTeX2e internals to provide
better methods for managing certain constructs.

All xpackages require expl3 and, in addition to this, many require
functionality provided by the packages within the xbase bundle.

Currently included in the CTAN release of xpackages are the following
bundles:
    xbase
    xtras

xbase
-----

The xbase bundle provides mechansims for defining document commands
(xparse) and design constructions (xtemplate).

The xparse package provides a high-level interface for declaring
document commands, e.g., a uniform way to define commands taking
optional arguments, optional stars (and others), mandatory arguments
and more.

The xtemplate package provides an interface for defining generic
functions using a key=val syntax. This is designed to be
"self-documenting", with the key definitions providing information
on how they are to be used.

The legacy template and ldcsetup packages are included at the
present time, but new LaTeX3 code will not use these!

Source files:
  - xbase.ins
  - xparse.dtx
  - xtemplate.dtx

xtras
-----

The xtras bundle provides functionality to bridge between LaTeX2e
and LaTeX3. It provides add-ons to LaTeX2e to allow other xpackages
to be used in the LaTeX2e context.

The l3keys2e package allows keys defined using l3keys to be used
as package and class options with LaTeX2e. This is tied to the
method the existing kernel uses for processing options, and so it
is likely that a stand-alone LaTeX3 kernel will use a very different
approach.


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


--- Copyright 1998 -- 2009
    The LaTeX3 Project.  All rights reserved ---
