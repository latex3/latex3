
# README for l3in2e/testfiles/


This directory contains the regression test suite for the expl3 modules.
Please see the validate/ directory of the SVN repository for more info
(and proper documentation) on this system.

Changes to the repository should NEVER result in errors in this test suite.


# Adding an additional test file

Here is the procedure to add additional tests for l3in2e. New tests should
be added for all new features added to the expl3 modules and for all bugs
fixed.

   * Decide on a name for your test file, e.g., "m3quark001.lvt"
     (a simple template is in template.lvt) and create it in 
     l3in2e/testfiles.

   * Add an empty file with the same name but extension .tlg into 
     l3in2e/testfiles as well. From that point on the regression 
     test suite will run your file as well (and will throw a diff 
     for it)

   * Execute `make check` to run the test suite.
     If you cannot run the makefile then run your test with
       `pdflatex m3quark001.lvt`

   * Look at the diff produced for your test file or the output 
     of the compilation process

   * If you are satisfied that the output is as it should be,
     "freeze" the results by creating the .tlg file. You can do 
     this by running  
       `make savetlg F=m3quark001`

   * Don't forget to add both the .lvt and .tlg files to the SVN 
     repository

Note that only tests with a generated .tlg file are included when the 
regression testing occurs; .lvt files that are under development can 
be still be added to the svn repository "in place" without affecting the 
test suite results until they're ready (at which stage you create the .tlg 
file as described above and the test is now included when the test suite 
is run).



# Coverage of the test suite

This is the list of relevant expl3 modules 
starred as having partial or completed testfiles.

     l3basics
     l3box
     l3calc
     l3chk
     l3clist
  *  l3expan
  *  l3int
     l3io
     l3keyval
     l3names
  *  l3num
  *  l3prg
     l3prop
  *  l3quark
     l3seq
  *  l3skip
  *  l3tlp
     l3token
  *  l3toks
     l3xref

These modules either do not require a testsuite 
or their status is tentative

     l3alloc
     l3doc
     l3final
     l3messages
     l3precom
     l3vers



# Todo

Some of the older test files begin with \usepackage{expl3} instead of 
loading only the module they're trying to test. (E.g., m3tlp00x.lvt)

These need to be replaced with their specific module so that we can test
module loading dependencies.

