The LaTeX3 Development Repository
=================================

OVERVIEW
--------

The repository contains development material for LaTeX3. This includes
not only code to be developed into the LaTeX3 kernel, but also a variety
of test, documentation and more experimental material. A great deal of
the experimental LaTeX3 code can be loaded within LaTeX2e to allow
development and testing to occur.

The following directories contain experimental LaTeX3 code:

 * `l3kernel`: code which is intended to eventually appear in a
   stand-alone LaTeX3 format. Most of this material is also
   usable on top of LaTeX2e when loading the `expl3` package.
 * `l3experimental`: code which is written to be used on top of
   LaTeX2e to experiment with LaTeX3 concepts. Parts of this code may
   eventually be migrated to `l3kernel`, while other parts are tied closely
   to LaTeX2e and are intended to support mixing LaTeX2e and LaTeX3 concepts.
 * `l3leftovers`: code which has been developed in the past by The
   LaTeX3 Project but is not suitable for use in its current form.
   Parts of this code may be used as the basis for new developments
   in `l3kernel` or `l3experimental` over time.
 
Support material for development is found in:

  * `support`, which contains a variety of scripts for running
    automated tests.
  * `validate`, which contains specially-designed TeX files for testing
    purposes.
    
Documentation is found in:

  * `articles`: discussion of LaTeX3 concepts by team members for
    publication in [_TUGBoat_](http://www.tug.org/tugboat) or elsewhere.
  * `examples`: demonstration documents showing how to use LaTeX3 concepts.
  * `news`: source for _LaTeX3 News_.
  
The repository also contains the directories `l3in2e` and `xpackages`. These
contain code which is being moved (broadly) to `l3kernel` and `l3experimental`,
respectively. Over time, both `l3in2e` and `xpackages` are expected to be
removed from the repository.
  

Discussion
----------

Discussion concerning the approach, suggestions for improvements, 
changes, additions, _etc._ should be addressed to the list
[LaTeX-L](http://news.gmane.org/group/gmane.comp.tex.latex.latex3). 

You can subscribe to this list by sending mail to

  listserv@urz.uni-heidelberg.de

with the body containing

  subscribe LATEX-L  <Your-First-Name> <Your-Second-Name>


Bugs
----

The issue tracker for LaTeX3 bugs is currently located at

  https://github.com/latex3/svn-mirror/issues
  
Please report specific issues with LaTeX3 code there. More general
discussion should be directed to the LaTeX-L lists.

--- Copyright 2011
    The LaTeX3 Project.  All rights reserved ---
