%
% $Id$
%
%

INTRODUCTION
============

This directory contains the first prototype implementation of the new
output routine (OR) for LaTeX2e*.

It is not a finished product, thus it is very likely that using it
will result in errors or problems.

Especially error recovery is more or less nil, eg, there  are a lot of
places which simply say \ErrorFooBar (which is undefined). So if this
happens to you, you might have to search in the code to see why this
is supposed to be a user error.

Nevertheless, I hope that playing around with it will give you some
idea about how the finished OR might look like and what it will be
able to do.

Suggestions, comments, ... are welcome, especially on the already
available functionality or on missing functionality.

enjoy
Frank

August 2000





INSTALLATION
============

This set of packages builds on the basic packages

 templates.sty
 ldcsetup.sty
 xparse.sty

so you need to pick those up from the project web site as well.

To unpack the distribution use one of the three distributed .ins
files:

 xo.ins		% unpacks without any tracing code whatsoever
 xoprogress.ins % unpacks with progress information code (recommended)
 xotrace.ins    % unpacks with tracing code (for those who like to see
                % what the algorithm really does)


DOCUMENTATION
=============

The sequence

 pdflatex xoutput.drv
 makeindex -s gind.ist xoutput
 pdflatex xoutput.drv

will produce a pdf file of roughly 150 pages with the (somewhat)
documented code --- there is still a lot to do there.

To produce some overview article on the OR run

 latex xo-pfloat

three times.

There will be a question asked which you can answer with either

 0    % run with normal latex
 1    % run using the new OR


There is also a sample file for you to play with:

 xo-sample.tex

but is is more or less a template file.

There is also the file I used for the examples for my talk at Oxford:

 oxford-trial.tex

This file asks for a "trial" number:

 0-8 shows how the algorithm adds float after float to the page
 9   same as 8 but uses grid layout
 10  manual float control using an .fpc file



IMPLEMENTED FEATURES
====================

Plenty I hope, for important ones see xo-pfloat and of course the
documented code :-)


MISSING FEATURES
================

Plenty I fear. Here are a few important ones.

 - Interface for specifying spanning floats is missing

 - Interface for specifying which areas are allowed for a float

 - Interface for specifying the look and setup of a float page

 - Most of the page layout things like folio, running headers, etc

 - More float placement control (what is wanted, needed)

 - Balancing of columns, what are the appropriate concepts with
   respect to floats?

 - page style concepts: how are page styles changed, how are they
   specified?



KNOWN BUGS
==========

Plenty I fear. Here are a few important ones.

 - There are many footnotes in the code that say CHECK! or FIX! or
   ... they are all places where further work is most likely
   necessary, or known bugs are already documented.

 - Because of the unfinished work in xo-final/xo-new there are two
   hardwired lists \bot@areas and \top@areas. Top areas are mounted
   first on the page, thus entries for list of figures etc, will be
   sort of strangely ordered :-)

 - If a special penalty such as the flush point penalty ends up at the
   top of a column any glue after it isn't properly removed. This
   needs fixing and while the way to proceed is clear it is not yet
   implemented.

 - If we have to relax the float placement conditions due to a flush
   point the current code reverts to tight conditions the moment the
   last affected float has been placed (the idea was to ensure that we
   don't place too many floats on such a page since the relaxed
   conditions do not have a restriction there). But the problem with
   that approach is that in fact in most cases this will result in no
   further floats being allowed at all since typically the already
   placed floats make any further trials fail now. So this needs some
   change, eg only to check columns after the flush point with the
   tight conditions or ... for the moment it has only be partially
   resolved by enabling basically only the restrictions on number of
   floats per column or space available in columns (which are only
   checked for areas under trial)

 - If the design allows strange placements in various areas, then ".lot"
   files etc will as a result always be ordered strangely. There is
   not much you can do about that on this stage (even if the above
   problem is fixed) other than ensuring that at some later stage such
   files get sorted automatically.

 - Float pages are at best strange. what are good concepts to
   construct them in multi-column layouts? Are there any?

 - Size of a here float is not properly calculated when it get
   initialized

 - Grid layout requires that \topskip=\baselineskip (or so it seems
   --- it shouldn't but there is somewhere a bug lurking)

 - Definition of grid layout point commands need one more indirection
   to allow turning them off for a single page setup. Right now, the
   moment they are disabled they are gone.

 - Initialization of the various data structures is not yet properly
   done --- this needs further sorting out. As a result it is likely
   that some setups run into undefined variables.

 - If \readfloatplacements is used (ie float are manually placed) then
   the positioning of the float areas is done incorrectly because I
   forgot to add the necessary code to that part of the processing
   (just found out while finishing the examples for the Oxford talk)


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
