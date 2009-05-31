
# README for `l3in2e/testfiles/`


This directory contains the regression test suite for the `expl3` modules.
Please see the `validate/` directory of the SVN repository for more info
(and proper documentation) on this system.

Changes to the repository should __never__ result in errors in this test suite.


# Adding an additional test file

Here is the procedure to add additional tests for `l3in2e`. New tests should
be added for all new features added to the `expl3` modules and for all bugs
fixed.

   * Decide on a name for your test file, e.g., `m3quark001.lvt`
     (a simple template is in `template.lvt`) and create it in 
     `l3in2e/testfiles/`.

   * Add an empty file with the same name but extension `.tlg` 
     into `l3in2e/testfiles` as well. From that point on the 
     regression test suite will run your file as well (and will 
     throw a diff for it).

   * Execute `make check` to run the test suite.
     If you cannot run the makefile then run your test with

       `pdflatex m3quark001.lvt`

   * Look at the diff produced for your test file or (if run 
     manually) the output of the compilation process.
     
   * The validation of a single test file can be executed with

       `make checklvt F=m3quark001` (Unix or MacOS X)
       `make checklvt m3quark001`   (Windows)

   * If you are satisfied that the output of the test file
     is as it should be, "freeze" the results by creating 
     the complete `.tlg` file. You can do this with  

       `make savetlg F=m3quark001` (Unix or MacOS X) 
       `make savetlg m3quark001`   (Windows)

   * Don't forget to add both the `.lvt` and `.tlg` files to 
     the SVN repository.

Note that only tests with a generated `.tlg` file are included when the 
regression testing occurs; `.lvt` files that are under development can 
be still be added to the svn repository "in place" without affecting the 
test suite results until they're ready (at which stage you create the 
`.tlg` file as described above and the test is now included when the 
test suite is run).


# Coverage of the test suite

These are the `expl3` modules with _complete_ test files:

 -  `l3clist`  
 -  `l3int`
 -  `l3io`      
 -  `l3keyval`
 -  `l3msg` 
 -  `l3num`    
 -  `l3prg`    
 -  `l3prop`   
 -  `l3quark`  
 -  `l3seq`    
 -  `l3skip`   
 -  `l3tl`    
 -  `l3token`  
 -  `l3toks`   
 -  `l3xref`   

This module has _incomplete_ test files:

 -  `l3expan` 

These modules are lacking test files:

 -  `l3basics` 
 -  `l3box`    
 -  `l3calc`   


## Modules without tests

The following modules either do not require a testsuite 
or their status is tentative.

 -   `l3alloc`
 -   `l3chk`        (see note below)
 -   `l3doc`
 -   `l3final`
 -   `l3names`
 -   `l3precom`
 -   `l3vers`

The reason that I've put `l3chk` in this list is that, as far as I know,
no-one's actually testing the code against it at the moment (the idea being
that we're able to conditionally extract "checking" versions of the modules
that are slower but much more strict).

As soon as we start using it (however that happens to be) we'll create a test
suite for it. (In fact, we'll probably need an entire *branch* of the test
suite for it with all the changes in the other modules this will imply.)


# Function variants

Not every possible combination of argument specs are always tested. This is
sometimes unfortunate because mistakes do happen. E.g.,  

    \cs_new:Npn \seq_map_variable:cNn { \exp_args:Nc \seq_map_variable:Nn }

Where possible, I should stop being lazy and literally test every defined
variant.


-----

Copyright 2009 LaTeX3 Project  
This readme is written in the "Markdown" markup language.
