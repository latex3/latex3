$Id$


Package reimplementation
========================

I'm currently reorganizing all code to finally fully use the expl3
syntax. However, pace is slow and depends on my interest in one or the
other package ... as a result xbase as the core is done to a large
extent and i'm currently (end of 2004) focus on xor ie the new output
routine.

Unfortunately, this unification also means that expl3 is changing by
a) adding functionality that wasn't put on the web before and b) by
fixing some of the mistake in naming conventions in there.

So all in all the stuff is somewhat in a flux and what needs what
(below) is most likely not accurate (eg expl3 is going to be required
soon)

Frank Mittelbach  2004/11/21





Test versions for LaTeX2e stuff
===============================

I'm going to misuse that directory and particular this readme file to
put some packages on the web that are intended (after suitable further
testing comments and updates) to be included in the next 2e release.

Right now these are:

 - inpmath.dtx		support for inputenc chars in math 

frank 2003/05/26





Some notes on the experimental packages in this directory
=========================================================


The packages in this directory are proto-type implementations of new
concepts for a LaTeX Designer Interface, see also

   http://www.latex-project.org/papers/tug99.pdf
and
   http://www.latex-project.org/papers/xo-pfloat.pdf
and
   http://www.latex-project.org/papers/template-notes.pdf


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


xfontm-pics
-----------

	A few postscript files used in one of the examples in
	xfrontm. As they are somewhat big and one doesn't need them
	really, they are in a separate package.


xor
---
	The new output routine  (proto-type version)
	Needs files from xbase. 


xfootnote
---------

	Some experiments to produce a footnote interface.
	Needs files from xbase. 

	One of the early tries to use the template interface (1999).
	Hopefully interesting in its own right but needs integration
	with xor.


galley
------

	First prototype of a new galley mechanism. The xhj package
	therein is the higher-level interface. An application of this
	is the xinitials package below.

	Needs files from xbase. 

	This implementation is not really stable yet and for this
	reason a simpler version of xhj was written for xfrontm above
	(under the name of xfmgalley.dtx) both with the same
	interfaces. However, galley here has low-level feature not
	available in this simple rewrite, ie couldn't do the initial
	handling.


xinitials
---------

	Implements customisable Initials as an application of the
	galley mechanism above.

	Needs files from xbase and galley.


xcontents
---------

	An extended datastructure and interface for table of contents
	data.

xtheorem
--------

	Contributed package by Achim Blumensath implementing theorems
	using the template mechanism.

	Needs files from xbase. 


xhead
-----

	Contributed package by Peter Wilson implementing page-styles
	using the template mechanism.

	Needs files from xbase. 






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

