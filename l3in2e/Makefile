
help:
	@echo ""
	@echo "  make clean              - clean out test dirs"
	@echo "  make check              - set up and run all tests"
	@echo "  make checklvt F=<name>  - run <name>.lvt only (no set up done)"
	@echo "  make savetlg F=<name>   - save <name>.tlg as new certified test"
	@echo "  make doc F=<name>       - typeset <name>.dtx"
	@echo "  make checkdoc           - typeset all expl3 modules once"
	@echo "  make sourcedoc          - typeset source3.tex"
	@echo "  make alldoc             - typeset all documentation"
	@echo "  make help               - show this help text"
	@echo ""

#### FIX next one (should use environment is provided)

L3TESTDIR := /tmp/l3test




TESTDIR := $(shell test -d $(L3TESTDIR)/test/l3in2e || mkdir -p $(L3TESTDIR)/test/l3in2e ; cd $(L3TESTDIR)/test/l3in2e ; pwd)

SCRIPTDIR := $(shell test -d $(L3TESTDIR)/scripts || mkdir -p $(L3TESTDIR)/scripts ; cd $(L3TESTDIR)/scripts ; pwd)


SOURCEDIR := .
BASEDIR := ..
VALIDATEDIR := $(BASEDIR)/validate
TESTFILEDIR := $(SOURCEDIR)/testfiles
SUPPORTDIR  := $(BASEDIR)/support


MODULES = \
	expl3.dtx \
	l3alloc.dtx \
	l3basics.dtx \
	l3box.dtx \
	l3calc.dtx \
	l3chk.dtx \
	l3clist.dtx \
	l3expan.dtx \
	l3final.dtx \
	l3int.dtx \
	l3io.dtx \
	l3keyval.dtx \
	l3messages.dtx \
	l3names.dtx \
	l3num.dtx \
	l3precom.dtx \
	l3prg.dtx \
	l3prop.dtx \
	l3quark.dtx \
	l3seq.dtx \
	l3skip.dtx \
	l3tlp.dtx \
	l3token.dtx \
	l3toks.dtx \
	l3vers.dtx \
	l3xref.dtx 

INSTALLS = \
	l3format.ins \
	l3.ins 

AUXFILES = \
	.aux \
	.glo \
	.gls \
	.hd  \
	.idx \
	.ilg \
	.ind \
	.ist \
	.log \
	.out \
	.toc

#
# scripts used in this make
#

SCRIPTS = \
	checktlg \
	log2tlg \
	maketlg


#
# default pattern rules for scripts
#

$(SCRIPTDIR)/%:	$(SUPPORTDIR)/%
	cp $< $@
	chmod +x $@


scripts:	$(foreach file,$(SCRIPTS),$(SCRIPTDIR)/$(file))



############
# gloals
############

.PHONY:	clean cleanuptest bootstrap check checklvt savetlg scripts

clean:	cleanuptest 

cleanuptest:
	rm -f $(TESTDIR)/*


bootstrap:	
	@echo "dummy right now"

texinputs:
	@echo "dummy right now"


COMPATCHECK =

MODULECHECK = $(subst .tlg,,$(notdir $(wildcard $(TESTFILEDIR)/m3*.tlg)))

BUGCHECK = $(subst .tlg,,$(notdir $(wildcard $(TESTFILEDIR)/tlb*.tlg)))


CFS = $(foreach file,$(COMPATCHECK) $(MODULECHECK) $(BUGCHECK),$(file).lvt)
CLS = $(foreach file,$(COMPATCHECK) $(MODULECHECK) $(BUGCHECK),$(file).tlg)


unpack:	$(foreach file,$(MODULES) $(INSTALLS),$(TESTDIR)/$(file))
	cd $(TESTDIR) ; \
	for i in  $(INSTALLS); \
	do \
	  latex $$i ; \
	done
 

check:	bootstrap scripts texinputs unpack \
                $(foreach file,$(CFS) $(CLS) $(CFextra),$(TESTDIR)/$(file)) \
                $(TESTDIR)/regression-test.tex $(TESTDIR)/ascii.tcx
	cd $(TESTDIR) ; \
	rm -f *tmp* *.log *.diff *.gls *.ind ; \
	for i in  $(CFS); \
	do \
	  $(SCRIPTDIR)/checktlg latex $$i $(TESTDIR)/ascii.tcx ; \
	done ; \
	if [ `ls | grep *.diff | wc -l` = 0 ] ; then \
	  echo ; \
	  echo All tests passed successfully. ; \
	  echo ; \
	else \
	  echo ; \
	  echo List of diffs produced during check: ; \
	  echo ==================================== ; \
	  echo ; \
	  ls -al `pwd`/*.diff ; \
	  echo ; \
	fi ;


checklvt:	$(TESTDIR)/$(F).lvt 
	cd $(TESTDIR) ; \
	rm -f *tmp* *.log *.diff *.gls *.ind ; \
	$(SCRIPTDIR)/checktlg latex $(F).lvt $(TESTDIR)/ascii.tcx ; \
	if [ `ls | grep *.diff | wc -l` -ne 0 ] ; then \
	  echo ; \
	  echo List of diffs produced during check: ; \
	  echo ==================================== ; \
	  echo ; \
	  ls -al `pwd`/$(F).*.diff ; \
	  echo ; \
	fi ;

savetlg:	$(TESTDIR)/$(F).tmp.tlg
	@cp -fp $< $(TESTFILEDIR)/$(F).tlg

doc:
	echo ; \
	echo "Typesetting $(F).dtx" ; \
	tex l3doc.dtx &> /dev/null ; \
	pdflatex -draftmode $(F).dtx ; \
	if [ $$? = 0 ] ; then \
	  pdflatex -interaction=nonstopmode -draftmode $(F).dtx &> /dev/null ; \
	  makeindex -s l3doc.ist -o $(F).ind $(F).idx ; \
	  echo "\nRe-typesetting $(F).dtx for cross-references" ; \
	  pdflatex -interaction=nonstopmode $(F).dtx &> $(L3TESTDIR)/doclog.txt ; \
	  if [ `grep 'defined but not documented' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	    echo '! Warning: some functions defined but not documented' ; \
	  fi ; \
	  if [ `grep 'documented but not defined' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	    echo '! Warning: some functions documented but not defined' ; \
	  fi ; \
	else \
	  echo "\n!! $(F).dtx compilation failed." ; \
	fi ; \
	for j in $(AUXFILES) ; do rm -f $(F)$$j ; done ; \
	rm l3doc.cls l3doc.ist ;

checkdoc:	
	echo ; \
	tex l3doc.dtx &> /dev/null ; \
	for i in  $(MODULES) ; do \
	  MODNAME=`basename $$i .dtx` ; \
	  echo "Typesetting $$i" ; \
	  pdflatex -interaction=nonstopmode -draftmode $$i &> $(L3TESTDIR)/doclog.txt ; \
	  if [ $$? = 0 ] ; then \
	    if [ `grep 'defined but not documented' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	      echo '! Warning: some functions defined but not documented' ; \
	    fi ; \
	    if [ `grep 'documented but not defined' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	      echo '! Warning: some functions documented but not defined' ; \
	    fi ; \
	  else \
	    echo "!! $$i compilation failed." ; \
	  fi ; \
	  for j in $(AUXFILES) ; do rm -f $$MODNAME$$j ; done ; \
	done ; \
	rm l3doc.cls l3doc.ist ;

alldoc:	
	echo ; \
	ALLPASSED=0 ; \
	tex l3doc.dtx &> /dev/null ; \
	for i in  $(MODULES) ; do \
	  MODNAME=`basename $$i .dtx` ; \
	  echo "Typesetting $$i" ; \
	  pdflatex -interaction=batchmode -draftmode $$i &> /dev/null ; \
	  if [ $$? = 0 ] ; then \
	    makeindex -s l3doc.ist -o $$MODNAME.ind $$MODNAME.idx &> /dev/null ; \
	    pdflatex -interaction=batchmode -draftmode $$i &> /dev/null ; \
	    pdflatex -interaction=batchmode $$i &> /dev/null ; \
	  else \
	    ALLPASSED=1 ; \
	    echo "!! $$i compilation failed." ; \
	  fi ; \
	  for j in $(AUXFILES) ; do rm -f $$MODNAME$$j ; done ; \
	done ; \
	rm l3doc.cls l3doc.ist ; \
	if [ $$ALLPASSED = 0 ] ; then \
	  echo ; \
	  make sourcedoc ; \
	fi ; \

sourcedoc:	
	tex l3doc.dtx &> /dev/null ; \
	echo "\nTypesetting source3.tex" ; \
	rm  -f source3.gls source3.ind source3.toc source3.out \
	       source3.aux source3.hd source3.ist source3.log; \
	pdflatex -interaction=batchmode -draftmode source3.tex &> /dev/null ; \
	if [ $$? = 0 ] ; then \
	  echo "Re-typesetting for index generation" ; \
	  makeindex -s l3doc.ist -o source3.ind source3.idx &> /dev/null ; \
	  pdflatex -interaction=batchmode -draftmode source3.tex &> /dev/null ; \
	  echo "Re-typesetting to resolve cross-references" ; \
	  pdflatex -interaction=batchmode source3.tex &> /dev/null ; \
	  rm  -f source3.gls source3.ind source3.toc source3.out \
	       source3.aux source3.hd source3.ist source3.log; \
	else \
	  echo "!! source3.tex compilation failed." ; \
	fi ; \
	rm l3doc.cls l3doc.ist ;



$(TESTDIR)/regression-test.tex: $(VALIDATEDIR)/regression-test.tex
	@cp -fp $< $@


################################
# default pattern rules for test files in test directory
################################

$(TESTDIR)/%.lvt:	$(TESTFILEDIR)/%.lvt
	@cp -fp $< $@

$(TESTDIR)/%.tlg:	$(TESTFILEDIR)/%.tlg
	@cp -fp $< $@


$(TESTDIR)/%.dtx:	$(SOURCEDIR)/%.dtx
	@cp -fp $< $@

$(TESTDIR)/%.ins:	$(SOURCEDIR)/%.ins
	@cp -fp $< $@



################################
# rules for support files
################################

$(TESTDIR)/ascii.tcx:		$(SUPPORTDIR)/ascii.tcx
	@cp -fp $< $@

