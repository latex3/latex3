%
% $Id$
%
%

INTRODUCTION
============

This directory contains the first prototype implementation of the new
front matter interface (xfm) for LaTeX2e*.

It is not a finished product, thus it is likely that using it will
result in errors or problems.

Especially error recovery is more or less nil, eg, there  are a lot of
places which simply say \ErrorFooBar (which is undefined). So if this
happens to you, you might have to search in the code to see why this
is supposed to be a user error.

Nevertheless, I hope that playing around with it will give you some
idea about how the finished product might look like and what it will
be able to do.

Suggestions, comments, ... are welcome, especially on the already
available functionality or on missing functionality.

enjoy
Frank

July 2001



INSTALLATION:
=============

Run

	latex xfrontm.ins

to unpack the distribution. 

You also need to get the packages from the xbase distribution, eg
template.sty. The older implementations of these packages _do not_ work!



TESTS:
======

Run

	latex xfm-test

and select one of the sample layouts 1-5. For layout 5 you need in
theory some ps graphics with pictures of my family but if you ignore
the error messages you can go on (if your internet connection is good
enough you can download them; they are in the package xfm-pics.tgz).

Run

	latex xfmgalley-test

to see how the galley interface works.


DOCUMENTATION:
==============

As usual code documentation is in the .dtx files.

xfm.dtx	         describes the frontmatter interface and its implementation.

xfmgalley.dtx    describes the galley interface which can be used on its
                 own. (this is a cut down version of xhj and galley2 ---
	         more stable less complex but not finished)

xfm-test-cls.dtx produces a pretty printing of the sample classes (but
                 not much docu)




FOUND A BUG?
============

If you think you have found a real bug (not just something that is
simply not yet implemented) I would be glad if you report it using

 latex latexbug

from the standard LaTeX distribution and select option 

 7) expl3:    Experimental packages for TeX programmers. (expl3)

or alternatively by discussing it on LATEX-L (see below)




DISCUSSION OF FEATURES (MISSING OR ELSE)
========================================

Discussion of features, either those implemented or those missing
should be directed to the discussion list

 LATEX-L

so that others can participate in the discussion. You can subscribe to
this list by sending a mail with the line

 SUBSCRIBE LATEX-L Your Name

to listserv@URZ.UNI-HEIDELBERG.DE
