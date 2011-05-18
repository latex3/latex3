
   LaTeX3 High-Level Concepts
   ==========================

   2011/05/18


WHERE TO GET IT
---------------

The files in this distribution represent a snapshot of selected files
from the Subversion (SVN) repository of the LaTeX3 Project.

To obtain current versions of the files, visit
<http://www.latex-project.org/code.html> which contains further
instructions.

OVERVIEW
--------

The l3package collection is contains implementations for aspects of the
LaTeX3 kernel, dealing with higher-level ideas such as the Designer
Interface. The packages here are considered broadly stable (The LaTeX3
Project does not expect the interfaces to alter radically). These
packages are build on LaTeX2e conventions at the interface level, and
so may not migrate in the current form to a stand-alone LaTeX3 format.

All of the material in the collection require expl3. The packages may also
depend upon one another.

Currently included in the CTAN release of l3package are the following
bundles:
 * xparse
 * xtemplate

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
