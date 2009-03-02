
   The EXPL3 bundle for LaTeX3 Programming
   =======================================

GETTING STARTED for developers
------------------------------

Welcome!
This is a short guide to how the expl3 bundle is set up,
and how you can get started programming with and
contributing to it.

First, some signposts:
Email discussion list     <http://news.gmane.org/gmane.comp.tex.latex.latex3>
SVN repository     <http://www.latex-project.org/svnroot/experimental/trunk/>
SVN repository RRS feed          <http://www.latex-project.org/latex3svn.rss>

Those interested in receiving emails containing the diff
of every commit to the repository should ask on the discussion list.

For more information, please look in the official README 
and in the documentation expl3.pdf.


INSTALLATION
------------

When you pull down the SVN repository, you'll generally
want two things: the actual packages files so you can
use the `expl3` bundle, and the documentation.

## Obtaining the code in the SVN repository

Execute something like this:

    mkdir l3svn
    svn checkout http://www.latex-project.org/svnroot/experimental/trunk/ l3svn

This will give you both the xpackages and the expl3 bundle 
contained within the `l3in2e/` directory, plus a few extras. 
This readme only concerns the expl3 bundle.


## Package files

Install `expl3` in your local texmf directory with

   make localinstall

The installation directory is detected automatically,
and in a normal TeXLive distribution will be used
in preference to any existing `expl3` code directory.
(I.e., after the above command your regular documents
will use the new versions of the modules.)


## Documentation

For an individual module, generate the documentation with

    make doc F=<module>
    
For example, `make doc F=l3quark`. This will produce 
`l3quark.pdf`, which includes the documentation for that 
module and its implementation source code.

To generate the complete reference documentation for
the `expl3` bundle, source3.pdf:

    make sourcedoc
  
Note that source3.pdf does not include the modules'
implementation source code; therefore, source3.pdf is a
rough subset (plus index) of the complete set of typeset 
module PDFs.

To generate `source3.pdf` and the documentation for 
each module, run

    make alldoc


HACKING
-------

There are two main things you need to know when making
changes to the expl3 bundle.

1. We have a regression test suite
2. Don't break it

To make sure things are working, run

    make check
    
If you change something, run that again. All working? Great!
Please send your diffs to the discussion list and we can talk
about adding your code.

You can find more information about the test suite in
  
    l3in2e/testfiles/README.txt

On a less critical level, we also have a method to check
that our documentation is somewhat self-consistent. Run

    make checkdoc
  
and each module will be compiled and verified that what
is defined in the module is also documented.

Note that it only checks what we *claim* we are defining
in the documentation; it does not literally check the code. 
It will also check that each module's documentation 
still compiles without errors.


--- Copyright 1998 -- 2009
    The LaTeX3 Project.  All rights reserved ---

