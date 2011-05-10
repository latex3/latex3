
   An Experimental LaTeX3 Programming Convention
   =============================================

   2011/05/10


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

REQUIREMENTS
------------

The expl3 bundle requires the e-TeX extensions and the functionality
of the \pdfstrcmp primitive. As a result, the bundle will only work
with the following engines:

 - pdfTeX v1.30 or later
 - XeTeX v0.9994 or later
 - LuaTeX v0.40 or later
 
pdfTeX v1.30 was released in 2005, and so any recent TeX distribution
will support expl3. Both XeTeX and LuaTeX have developed more
actively over the past few years, and for this reason only recent 
releases of these engines are supported.

THE GUILTY PERSONS
------------------

   Frank Mittelbach, Denys Duchier, Johannes Braams, Michael Downes,
   David Carlisle, Alan Jeffrey, Chris Rowley, Rainer Schoepf 
   Javier Bezos, Morten Hoegholm, Thomas Lotze, Will Robertson,
   Joseph Wright, Bruno Le Floch


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

=====================================================================

--- Copyright 1998-2011 The LaTeX3 Project. All rights reserved ---

