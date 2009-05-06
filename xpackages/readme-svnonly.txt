   Experimental Packages Demonstrating
   Possible LaTeX3 High-Level Concepts
   ====================================

   2008/08/05


WHERE TO GET IT
---------------

The current version of these packages can be obtained by following the
instructions at <http://www.latex-project.org/code.html>.

OVERVIEW
--------

The modules listed here are currently not available from CTAN. See
readme-ctan.txt for what is included there. This SVN only list
contains the following bundles:

galley
xcontents
xfootnote
xfrontm
xhead
xinitials
xlang
xor

All of these require expl3 and, in most cases, xbase to be installed.


galley
------

The galley package provides a low-level interface for handling
inter-paragraph material and paragraph shapes.

The xhj package provides higher-level templates using the galley
package.

The xlists package redefines all list environments in LaTeX to use the
framework provided by galley and xhj.

Files included:
  source: galley2.dtx, xhj.dtx, xlists.dtx, galley2.ins
  test:   xhj-test.tex



xcontents
---------

The xcontents package implements a data structure for contents information

Files included:
  source: xcontents.dtx, xcontents.ins

Additional requirements: galley



xfootnote
---------

The xfootnote package is a prototype implementation of different
footnote styles and layouts using templates.

Files included:
  source: xfootnote.dtx, xfootnote.ins
  test:   xfootnote-test.tex

xfrontm
-------

The xfrontm module is the first prototype implementation of the new
front matter interface (xfm) for LaTeX2e*.

xfm.dtx          describes the frontmatter interface and its implementation.

xfmgalley.dtx    describes the galley interface which can be used on its
                 own. (this is a cut down version of xhj and galley2 ---
                 more stable less complex but not finished)

xfm-test-cls.dtx produces a pretty printing of the sample classes (but
                 not much docu)

Files included:
  source: xfm.dtx, xfmgalley.dtx, xfm-test-cls.dtx, xfrontm.ins
  test:   xfm-test.tex, arno.ps, bernd.ps, burkhard.ps, christel.ps,
          frank.ps, gisela.ps, holger.ps


xhead
-----

The xhead package is a prototype implementation of different
page styles using templates.

Files included:
  source: xhead.dtx, xhead.ins
  test:   tryxhead.tex


xinitials
---------

The xinitials package implements and interface for producing initial
characters.

Files included:
  source: xinitials.dtx, xinitials.ins
  test:   xinitials-test.tex

Additional requirements: galley





xtheorem
--------

The xtheorem package is a prototype reimplementation of the AMS-LaTeX
theorem environments by Achim Blumensath.

Files included:
  source: xtheorem.dtx, xtheorem.ins
  test:   xtheorem-test.tex



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
