
   Experimental LaTeX3 High-Level Concepts
   =======================================

   2011/05/11


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
    xparse
    xtemplate
    xtras

xparse
-----

The xparse package provides a high-level interface for declaring
document commands, e.g., a uniform way to define commands taking
optional arguments, optional stars (and others), mandatory arguments
and more.

xtemplate
-----

The xtemplate package provides an interface for defining generic
functions using a key=val syntax. This is designed to be 
"self-documenting", with the key definitions providing information
on how they are to be used.

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
