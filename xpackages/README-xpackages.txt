Some notes on the experimental packages in this directory
=========================================================


The packages in this directory are proto-type implementations of new
concepts for a LaTeX Designer Interface, see also

   http://www.latex-project.org/talks/tug99.pdf
and
   http://www.latex-project.org/talks/xo-pfloat.pdf


These concepts, as well as their implementation, are under discussion
on the list LATEX-L. You can join this list, which is intended solely
for discussing ideas and concepts for future versions of LaTeX, by
sending mail to

  listserv@@URZ.UNI-HEIDELBERG.DE

containing the line

    SUBSCRIBE LATEX-L     Your Name


These packages are experimental which means that their interfaces
and implementation might change drastically (see below). It is
therefore not sensible to use them in production environments unless
you are prepared to update your environment once in a while.



Package reimplementation
========================

I'm currently reorganizing some of the code and so right now the
stuff is somewhat in a flux. The main problem is that the core is now
starting to use _: syntax as introduced some time ago on CTAN.

The most noticable conflict crated by this is the LaTeX command \@for
(and friends) having a syntax like

 \@for\@tempa := #1\do

which dies when : has changed catcode.

To avoid this problem, old packages start their code with
\IgnoreWhiteSpace while the updated ones start with \InternalSyntaxOn
(which temorarily sets _ and : to catcode 11) This way (I hope:-) the
old and the new stuff will be able to live happily together.

happy experimenting

Frank Mittelbach              July 2001






Package description (by subdirectories)
=======================================

xbase
-----

	Basic code for the new designer interface, contains:

	template.dtx   template method needed for about everything
	xparse.dtx     how to produce user document commands
	xtools.dtx     tools for internal programming (this is a
		       cutdown version of the code presented as LaTeX3
		       internal programming language, but with a lot
		       missing --- more will be added and helpers are
		       welcome very much)


xfrontm
-------

	The new font matter interface (proto-type version).
	Needs files from xbase. 

	Most of that is converted to new syntax already.

xor
---
	The new output routine  (proto-type version)
	Needs files from xbase. 

	Is still using the old internal syntax.







Removed packages:
=================

template
--------
	Now in xbase.

trace
-----
	Has been added to the tools distribution of LaTeX2e.

xparse
------
	Now in xbase.

