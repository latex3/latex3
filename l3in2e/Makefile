
help:
	@echo ""
	@echo "  make clean              - clean out test dirs"
	@echo ""
	@echo "  make check              - set up and run all tests"
	@echo "  make checklvt F=<name>  - run <name>.lvt only"
	@echo "  make savetlg  F=<name>  - save <name>.tlg as new certified test"
	@echo ""
	@echo "  make checkcmd F=<name>  - check all functions are defined in module"
	@echo "  make checkcmds          - check all functions are defined in all modules"
	@echo ""
	@echo "  make doc F=<name>       - typeset <name>.dtx"
	@echo "  make checkdoc           - typeset all expl3 modules once"
	@echo "  make sourcedoc          - typeset source3.tex"
	@echo "  make alldoc             - typeset all documentation"
	@echo ""
	@echo "  make /OR/ make help     - show this help text"
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

CHKMODULES = \
	expl3 \
	l3basics \
	l3box \
	l3calc \
	l3chk \
	l3clist \
	l3expan \
	l3int \
	l3io \
	l3keyval \
	l3messages \
	l3names \
	l3num \
	l3precom \
	l3prg \
	l3prop \
	l3quark \
	l3seq \
	l3skip \
	l3tlp \
	l3token \
	l3toks \
	l3xref

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

unpacksilent:	$(foreach file,$(MODULES) $(INSTALLS),$(TESTDIR)/$(file))
	cd $(TESTDIR) ; \
	for i in  $(INSTALLS); \
	do \
	  latex $$i &> /dev/null ; \
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
	if [ `ls | grep '.diff' | wc -l` = 0 ] ; then \
	  echo ; \
	  echo All tests passed successfully. ; \
	  echo ; \
	else \
	  echo ; \
	  echo List of diffs produced during check: ; \
	  echo ==================================== ; \
	  echo ; \
	  ls -1 `pwd`/*.diff ; \
	  echo ; \
	fi ;


checklvt:	$(TESTDIR)/$(F).lvt scripts unpacksilent \
                $(foreach file,$(CFS) $(CLS) $(CFextra),$(TESTDIR)/$(file)) \
                $(TESTDIR)/regression-test.tex $(TESTDIR)/ascii.tcx
	cd $(TESTDIR) ; \
	rm -f *tmp* *.log *.diff *.gls *.ind ; \
	$(SCRIPTDIR)/checktlg latex $(F).lvt $(TESTDIR)/ascii.tcx ; \
	if [ `ls | grep *.diff | wc -l` -ne 0 ] ; then \
	  echo '\n* Diff between the expected and actual results: *' ; \
	  ls -1 `pwd`/$(F).*.diff ; \
	fi ;

savetlg:	$(TESTDIR)/$(F).tmp.tlg
	@cp -fp $< $(TESTFILEDIR)/$(F).tlg



checkcmd:  unpacksilent $(TESTDIR)/l3doc.cls $(TESTDIR)/commands-check.tex
	echo "Checking definitions of functions in $(F)" ; \
	cd $(TESTDIR) ; \
	latex -interaction=batchmode $(F).dtx &> /dev/null ; \
	latex -draftmode -interaction=nonstopmode \
	  "\def\PKG{$(F)}\input commands-check" &> $(L3TESTDIR)/cmdlog.txt ; \
	if [ $$? -ne 0 ] ; then \
	  echo "Missing definitions:" ; \
	  cat $(L3TESTDIR)/cmdlog.txt | grep '!> ' ; \
	fi ; \

checkcmds: unpacksilent $(TESTDIR)/l3doc.cls $(TESTDIR)/commands-check.tex	
	cd $(TESTDIR) ; \
	for i in  $(CHKMODULES) ; do \
	  latex -interaction=batchmode $$i.dtx &> /dev/null ; \
	  latex -draftmode -interaction=nonstopmode \
	    "\def\PKG{$$i}\input commands-check" &> $(L3TESTDIR)/cmdlog.txt ; \
	  if [ $$? -ne 0 ] ; then \
	    echo "\n$$i missing definition(s):" ; \
	    cat $(L3TESTDIR)/cmdlog.txt | grep '!> ' ; \
	    echo "" ; \
	  else \
	    echo "$$i checked." ; \
	  fi ; \
	done ; \

doc: l3doc.cls
	echo ; \
	FAIL=0 ; \
	echo "Typesetting $(F).dtx" ; \
	pdflatex -draftmode $(F).dtx ; \
	if [ $$? = 0 ] ; then \
	  pdflatex -interaction=nonstopmode -draftmode $(F).dtx &> /dev/null ; \
	  makeindex -s l3doc.ist -o $(F).ind $(F).idx ; \
	  echo "\nRe-typesetting $(F).dtx for cross-references" ; \
	  pdflatex -interaction=nonstopmode $(F).dtx &> $(L3TESTDIR)/doclog.txt ; \
	  if [ $$? -ne 0 ] ; then FAIL=1 ; fi ; \
	  if [ `grep 'defined but not documented' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	    echo '! Warning: some functions defined but not documented' ; \
	  fi ; \
	  if [ `grep 'documented but not defined' $(L3TESTDIR)/doclog.txt | wc -l` -ne 0 ] ; then \
	    echo '! Warning: some functions documented but not defined' ; \
	  fi ; \
	else \
	  FAIL=1 ; \
	fi ; \
	if [ $$FAIL = 1 ] ; then \
	  echo "\n!! $(F).dtx compilation failed." ; \
	fi ; \
	for j in $(AUXFILES) ; do rm -f $(F)$$j ; done ; \
	rm l3doc.cls l3doc.ist ;

checkdoc: l3doc.cls
	echo ; \
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
	    echo "\n!! $$i compilation failed.\n" ; \
	  fi ; \
	  for j in $(AUXFILES) ; do rm -f $$MODNAME$$j ; done ; \
	done ; \
	rm l3doc.cls l3doc.ist ;

alldoc: l3doc.cls
	echo ; \
	ALLPASSED=0 ; \
	for i in  $(MODULES) ; do \
	  FAIL=0 ; \
	  MODNAME=`basename $$i .dtx` ; \
	  echo "Typesetting $$i" ; \
	  pdflatex -interaction=batchmode -draftmode $$i &> /dev/null ; \
	  if [ $$? = 0 ] ; then \
	    makeindex -s l3doc.ist -o $$MODNAME.ind $$MODNAME.idx &> /dev/null ; \
	    pdflatex -interaction=batchmode -draftmode $$i &> /dev/null ; \
	    pdflatex -interaction=batchmode $$i &> /dev/null ; \
	    if [ $$? -ne 0 ] ; then FAIL=1 ; fi ; \
	  else \
	    FAIL=1 ; \
	  fi ; \
	  if [ $$FAIL = 1 ] ; then \
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

sourcedoc: l3doc.cls
	FAIL=0 ; \
	echo "\nTypesetting source3.tex" ; \
	pdflatex -interaction=batchmode -draftmode source3.tex &> /dev/null ; \
	if [ $$? = 0 ] ; then \
	  echo "Re-typesetting for index generation" ; \
	  makeindex -s l3doc.ist -o source3.ind source3.idx &> /dev/null ; \
	  pdflatex -interaction=nonstopmode -draftmode source3.tex &> /dev/null ; \
	  echo "Re-typesetting to resolve cross-references" ; \
	  pdflatex -interaction=batchmode source3.tex &> /dev/null ; \
	  if [ $$? -ne 0 ] ; then FAIL=1 ; fi ; \
	else \
	  FAIL=1 ; \
	fi ; \
	if [ $$FAIL = 1 ] ; then \
	  echo "!! source3.tex compilation failed." ; \
	fi ; \
	for j in $(AUXFILES) ; do rm -f source3$$j ; done ; \
	rm l3doc.cls l3doc.ist ;


localinstall:
	LTEXMF=`kpsewhich --var-value=TEXMFHOME`/tex/latex/ltx3; \
	echo "\nInstallation directory: \n   $$LTEXMF" ; \
	mkdir -p $$LTEXMF/l3in2e/ ; \
	mkdir -p $$LTEXMF/validate/ ; \
	echo "\nDeleting any old files: \n" ; \
	rm -fv $$LTEXMF/l3in2e/* ; \
	rm -fv $$LTEXMF/validate/* ; \
	echo "\nExtracting and installing: \n" ; \
	tex l3.ins &> /dev/null ; \
	rm l3.log ; \
	tex l3doc.dtx &> /dev/null ; \
	ls *.sty | xargs -I {} mv -v ./{} $$LTEXMF/l3in2e/{} ; \
	ls *.cls | xargs -I {} mv -v ./{} $$LTEXMF/l3in2e/{} ; \
	cp -v l3vers.dtx $$LTEXMF/l3in2e/ ; \
	cp -v ../validate/regression-test.tex $$LTEXMF/validate/ ;


$(TESTDIR)/regression-test.tex: $(VALIDATEDIR)/regression-test.tex
	@cp -fp $< $@

$(TESTDIR)/commands-check.tex: $(VALIDATEDIR)/commands-check.tex
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

####

$(TESTDIR)/l3doc.cls: $(TESTDIR)/l3doc.dtx
	cd $(TESTDIR); tex l3doc.dtx &> /dev/null
