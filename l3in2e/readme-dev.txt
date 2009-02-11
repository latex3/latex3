
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
of every commit to the repository should ask on LaTeX-L.

For more information, please look in the official README 
and in the documentation expl3.pdf.


INSTALLATION
------------

When you pull down the SVN repository, you'll generally
want two things: the actual packages files so you can
use the expl3 bundle, and the documentation.


## Package files

We don't have an automatic way to do this yet, sorry.
Run `tex l3.ins` to generate the .sty files for the expl3
modules. Then move them somewhere that TeX will find them.


## Documentation

This is handled most easily by the makefile. For an
individual module, you can run
  make doc F=<module>
For example
  make doc F=l3quark
This will produce l3quark.pdf, including the documentation
for that module and its implementation source code.

To generate the complete documentation, source3.pdf,
run
  make sourcedoc
  
Note that source3.pdf does not include the modules'
implementation source code; therefore, source3.pdf is a
rough subset (plus index) of the complete set of typeset 
module PDFs.

To generate source3.pdf and each module documentation, run
  make alldoc


HACKING
-------

There are two main things you need to know when making
changes to the expl3 bundle.
1. We have a regression test suite
2. Don't break it

To make sure things are working, run
  make check
And if you ever change anything, run that again. 
All working? Great!

You can find more information about the test suite in
  l3in2e/testfiles/README.txt

---

On a less critical level, we also have a method to check
that our documentation is somewhat self-consistent. Run
  make checkdoc
and each module will be compiled and verified that what
is defined in the module is also documented.

Note that it only check what we *claim* we are defining
in the documentation; it does not literally check in 
the code. It will also check that the module's documentation 
still compiles without errors.


--- Copyright 1998 -- 2009
    The LaTeX3 Project.  All rights reserved ---

