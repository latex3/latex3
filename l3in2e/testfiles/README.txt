
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
     
   * The validation of a single test file can be executed with
       `make checklvt F=m3quark001`

   * If you are satisfied that the output is as it should be,
     "freeze" the results by creating the complete .tlg file. 
     You can do this with  
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
First star  = All major functions tested
Second star = All functions & variants checked for existence

             l3basics 
       *     l3box    
             l3calc   
     * *     l3clist  
       *     l3expan  
       *     l3int    
             l3io     
     * *     l3keyval 
       *     l3num    
     * *     l3prg    
     * *     l3prop   
     * *     l3quark  
     * *     l3seq    
       *     l3skip   
       *     l3tlp    
     * *     l3token  
     * *     l3toks   
       *     l3xref   

These modules either do not require a testsuite 
or their status is tentative.

     l3alloc
     l3chk        (see note below)
     l3doc
     l3final
     l3messages
     l3names
     l3precom
     l3vers

The reason that I've put l3chk in this list is that, as far as I know,
no-one's actually testing the code against it at the moment (the idea being
that we're able to conditionally extract `checking' versions of the modules
that are slower but much more strict).

As soon as we start using it (however that happens to be) we'll create test
suite for it. (In fact, we'll probably need an entire *branch* of the test
suite for it with all the changes in the other modules this will imply.)

# Todo

Some of the older test files begin with \usepackage{expl3} instead of 
loading only the module they're trying to test. (E.g., m3tlp00x.lvt)

These need to be replaced with their specific module so that we can test
module loading dependencies.


# Function variants

Not every possible combination of argument specs are generally tested. This is
sometimes unfortunate because mistakes do happen. E.g.,
  \def_new:Npn \seq_map_variable:cNn { \exp_args:Nc \seq_map_variable:Nn }

However, my feeling is that little things like this will be discovered quickly
and trivially fixed. So while all functions are tested in their base forms,
this won't guarantee later on that small errors don't creep in every now and
then. If this seriously becomes a problem, then we can start putting *every*
function variant into the test suite, at only a small cost to our sanity.


# Help from l3doc

We now have code in l3doc to report both the documented and defined macros in
the source for each module.

After the module has been fixed to remove inconsistencies, the full list of
commands can now be used in a test file to ensure, for a snapshot in time for
each module, that no functions have been removed accidentally.

Note that this is of absolutely no use whatsoever when we add new functions
to a module and forget to add them to the test suite.
