################################################################
################################################################
# Makefile for LaTeX3 "expl3" files                            #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make check               - runs automated test suite"
	@echo " make checkcmd F=<module> - checks all functions are defined for <module>"
	@echo " make checkcmds           - checks all functions are defined for all modules"
	@echo " make checkdoc            - checks all module documentation compiles correctly"
	@echo " make checktest           - checks all functions have test file coverage"
	@echo " make clean               - clean out test directory"
	@echo " make cleanall            - clean out test and current directory"
	@echo " make ctan                - create a CTAN-ready archive"
	@echo " make checklvt F=<name>   - runs automated test on <name>"
	@echo " make doc F=<module>      - typeset documentation for <module>"
	@echo " make format              - create LaTeX3 format file"
	@echo " make localinstall        - install files in local texmf tree"
	@echo " make savetlg F=<name>    - save test log for <name>"  
	@echo " make sourcedoc           - typeset expl3 and source3"
	@echo " make tds                 - create a TDS-ready archive"
	@echo " make unpack              - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = expl3

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ..
VALIDATEDIR := $(BASEDIR)/validate
TESTFILEDIR := $(SOURCEDIR)/testfiles
SUPPORTDIR  := $(BASEDIR)/support
XPACKAGEDIR := $(BASEDIR)/xpackages

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
SCRIPTDIR  := $(shell test -d $(L3TESTDIR)/scripts || mkdir -p $(L3TESTDIR)/scripts ; cd $(L3TESTDIR)/scripts ; pwd)
TESTDIR    := $(shell test -d $(L3TESTDIR)/test/l3in2e || mkdir -p $(L3TESTDIR)/test/l3in2e ; cd $(L3TESTDIR)/test/l3in2e ; pwd)
TESTAUXDIR := $(shell test -d $(TESTDIR)/testfiles || mkdir -p $(TESTDIR)/testfiles ; cd $(TESTDIR)/testfiles ; pwd)

##############################################################
# Directory structure for making zip files                   #
##############################################################

CTANROOT := $(TESTDIR)/ctan
CTANDIR  := $(TESTDIR)/ctan/$(PACKAGE)
TDSDIR   := $(TESTDIR)/tds

##############################################################
# Data for local installation and TDS construction           #
##############################################################

INCLUDEPDF  := $(PACKAGE) source3 l3calc
INCLUDETEX  := interface3 source3 source3body
INCLUDETXT  := README
PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

DTX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
DTXFILES  = $(subst .dtx,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
FORMAT    = l3format.ins
UNPACK    = l3.ins l3doc.dtx
XPACKAGES = xbase

##############################################################
# Files for the check systems                                #
##############################################################

CHECKFILES = $(subst .tlg,,$(notdir $(wildcard $(TESTFILEDIR)/m3*.tlg)))
SCRIPTS    = log2tlg
TESTAUX    = filetest.txt
VALIDATE   = commands-check.tex regression-test.tex

##############################################################
# Clean-up information                                       #
##############################################################

AUXFILES = \
	aux  \
	cmds \
	glo  \
	gls  \
	hd   \
	idx  \
	ilg  \
	ind  \
	log  \
	out  \
	tmp  \
	toc  \
	xref

CLEAN = \
	cls  \
	diff \
	fmt  \
	gz   \
	ist  \
	ltx  \
	pdf  \
	sty  \
	zip 

################################################################
# Document settings                                            #
################################################################

PDFSETTINGS=\pdfminorversion=5  \pdfobjcompresslevel=2

################################################################
# File copying: default actions                                #
################################################################

$(SCRIPTDIR)/%: $(SUPPORTDIR)/%
	@cp -fp $< $@
	@chmod +x $@

$(TESTDIR)/%.dtx: $(SOURCEDIR)/%.dtx
	@cp -fp $< $@

$(TESTDIR)/%.ins: $(SOURCEDIR)/%.ins
	@cp -fp $< $@

$(TESTDIR)/%.lvt: $(TESTFILEDIR)/%.lvt
	@cp -fp $< $@

$(TESTDIR)/%.tex: $(SOURCEDIR)/%.tex
	@cp -fp $< $@	

$(TESTDIR)/%.tlg: $(TESTFILEDIR)/%.tlg
	@cp -fp $< $@	

$(TESTDIR)/%.txt: $(SOURCEDIR)/%.txt
	@cp -fp $< $@	

$(TESTAUXDIR)/%.txt: $(TESTFILEDIR)/%.txt
	@cp -fp $< $@	

################################################################
# File copying: specials                                       #
################################################################

$(TESTDIR)/commands-check.tex: $(VALIDATEDIR)/commands-check.tex
	@cp -fp $< $@	

$(TESTDIR)/regression-test.tex: $(VALIDATEDIR)/regression-test.tex
	@cp -fp $< $@	

################################################################
# File building: default actions                               #
################################################################

$(TESTDIR)/%.pdf: $(TESTDIR)/%.dtx
	NAME=`basename $< .dtx` ; \
	echo "Typesetting $$NAME" ; \
	pdflatex -draftmode -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \input $<" &> /dev/null ; \
	if [ $$? = 0 ] ; then  \
	  makeindex -s l3doc.ist -o $(TESTDIR)/$$NAME.ind $(TESTDIR)/$$NAME.idx &> /dev/null ; \
	  pdflatex -draftmode -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \input $<" &> /dev/null ; \
	  pdflatex -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \PassOptionsToClass{check}{l3doc}\input{$<}" &> /dev/null ; \
	  if [ `grep 'defined but not documented' $(TESTDIR)/$$NAME.log | wc -l` -ne 0 ] ; then \
	    echo "! Warning: some functions defined but not documented" ; \
	  fi ; \
	  if [ `grep 'documented but not defined' $(TESTDIR)/$$NAME.log | wc -l` -ne 0 ]  ; then \
	    echo "! Warning: some functions documented but not defined" ; \
	  fi ; \
	else \
	  echo "  Compilation failed" ; \
	fi ; \
	for I in $(AUXFILES) ; do \
	  rm -f $$NAME.$$I ; \
	done

################################################################
# File building: specials                                      #
################################################################

$(TESTDIR)/source3.pdf: $(TESTDIR)/source3.tex $(TESTDIR)/source3body.tex $(TESTDIR)/interface3.tex 
	echo "Typesetting source3" ; \
	pdflatex -draftmode -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \input $<" &> /dev/null ; \
	if [ $$? = 0 ] ; then  \
	  makeindex -s l3doc.ist -o $(TESTDIR)/source3.ind $(TESTDIR)/source3.idx &> /dev/null ; \
	  echo "  Re-typesetting for index generation" ; \
	  pdflatex -draftmode -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \input $<" &> /dev/null ; \
	  echo "  Re-typesetting to resolve cross-references" ; \
	  pdflatex -interaction=nonstopmode -output-directory=$(TESTDIR) "$(PDFSETTINGS) \input $<" &> /dev/null ; \
	else \
	  echo "  Compilation failed" ; \
	fi ; \
	for I in $(AUXFILES) ; do \
	  rm -f source3.$$I ; \
	done

################################################################
# Internal make options                                        #
################################################################

.PHONY = \
	support 

support: \
	$(foreach FILE,$(SCRIPTS),$(SCRIPTDIR)/$(FILE))  \
	$(foreach FILE,$(TESTAUX),$(TESTAUXDIR)/$(FILE)) \
	$(foreach FILE,$(VALIDATE),$(TESTDIR)/$(FILE))

################################################################
# User make options                                            #
################################################################

.PHONY = \
	alldoc       \
	check        \
	checkcmd     \
	checkcmds    \
	checkdoc     \
	checklvt     \
	clean        \
	cleanall     \
	ctan         \
	doc          \
	format       \
	localinstall \
	savetlg      \
	sourcedoc    \
	tds          \
	unpack

alldoc: $(foreach FILE,$(DTXFILES),$(TESTDIR)/$(FILE).pdf) source3.pdf

check: \
	$(foreach FILE,$(CHECKFILES),$(TESTDIR)/$(FILE).lvt) \
	$(foreach FILE,$(CHECKFILES),$(TESTDIR)/$(FILE).tlg) \
	support unpack
	echo "Running checks on"
	cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	for I in $(CHECKFILES) ; do \
	  echo "  $$I" ; \
	  pdflatex $$I.lvt &> /dev/null ; \
	  pdflatex $$I.lvt &> /dev/null ; \
	  perl $(SCRIPTDIR)/log2tlg $$I < $$I.log > $$I.new.log ; \
	  if !(cmp -s $$I.tlg $$I.new.log) ; then \
	    diff -c $$I.tlg $$I.new.log &> $$I.diff ; \
	  fi ; \
	  for J in $(AUXFILES) lvt pdf tlg ; do \
	    rm -f $$I.$$J ; \
	  done ; \
	done ; \
	if (test `ls *.diff |wc -l` -gt 0) ; then \
	  echo "  Check failed with difference files" ; \
	  for I in *.diff ; do \
	    echo "  - " `pwd`"/$$I" ; \
	  done ; \
	else \
	  echo "  All checks passed" ; \
	fi

checkcmd: support unpack
	echo "Checking commands in $(F)" ; \
	cd $(TESTDIR) ; \
	pdflatex -interaction=nonstopmode $(F).dtx &> /dev/null ; \
	pdflatex -interaction=nonstopmode "\def\CMDS{$(F).cmds}\input commands-check" &> cmds.log ; \
	if [ $$? -ne 0 ] ; then \
	  echo "  Missing definitions:" ; \
	  cat $(TESTDIR)/cmds.log| grep '!> ' ; \
	fi ; \
	for I in $(AUXFILES) ; do \
	  rm -f $(F).$$I ; \
	done

checkcmds: support unpack
	echo "Checking commands" ; \
	cd $(TESTDIR) ; \
	for I in $(DTXFILES) ; do \
	  echo "  $$I" ; \
	  pdflatex -interaction=nonstopmode "\PassOptionsToClass{check}{l3doc} \input $$I.dtx" &> /dev/null ; \
	  pdflatex -interaction=nonstopmode "\def\CMDS{$$I.cmds}\input commands-check" &> cmds.log ; \
	  if [ $$? -ne 0 ] ; then \
	    echo "  Missing definitions:" ; \
	    cat $(TESTDIR)/cmds.log| grep '!> ' ; \
	  fi ; \
	  for J in $(AUXFILES) ; do \
	    rm -f $$I.$$J ; \
	  done ; \
	done

checktest: support unpack
	@echo "Checking functions have tests" ; \
	cd $(TESTDIR) ; \
	for I in $(DTXFILES) ; do \
	  echo "  $$I" ; \
	  pdflatex --interaction=batchmode "\PassOptionsToClass{checktest}{l3doc} \input $$I.dtx" ; \
	done

checkdoc: unpack
	echo "Checking compilation"
	cd $(TESTDIR) ; \
	for I in $(DTXFILES) ; do \
	  echo "  $$I" ; \
	  pdflatex -draftmode -interaction=nonstopmode "\PassOptionsToClass{check}{l3doc} \input $$I.dtx" &> /dev/null  ; \
	  if [ $$? = 0 ] ; then \
	    if [ `grep 'defined but not documented' $$I.log | wc -l` -ne 0 ] ; then \
	      echo '! Warning: some functions defined but not documented' ; \
	    fi ; \
	    if [ `grep 'documented but not defined' $$I.log | wc -l` -ne 0 ] ; then \
	      echo '! Warning: some functions documented but not defined' ; \
	    fi ; \
	  else \
	    echo "! Compilation failed" ; \
	  fi ; \
	  for J in $(AUXFILES) ; do \
	    rm -f $$I.$$J ; \
	  done ; \
	done 

checklvt: $(TESTDIR)/$(F).lvt $(TESTDIR)/$(F).tlg support unpack
	echo "Running checks on $(F)"
	cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	pdflatex $(F).lvt ;\
	pdflatex $(F).lvt &> /dev/null ; \
	perl $(SCRIPTDIR)/log2tlg $(F) < $(F).log > $(F).new.log ; \
	if !(cmp -s $(F).tlg $(F).new.log) ; then \
	  diff -c $(F).tlg $(F).new.log  &> $(F).diff ; \
	fi ; \
	for I in $(AUXFILES) lvt pdf tlg ; do \
	  rm -f $(F).$$I ; \
	done ; \
	if (test -f $(F).diff) ; then \
	  echo "  Check failed" ; \
	  echo "  - " `pwd`"/$(F).diff" ; \
	else \
	  echo "  Check passed" ; \
	fi

clean:
	echo "Cleaning up"
	rm -rf $(L3TESTDIR)/*

cleanall: clean
	for I in $(AUXFILES) $(CLEAN) ; do \
	  rm -f *.$$I ; \
	done

ctan: tds
	echo "Creating CTAN archive"
	mkdir -p $(CTANDIR)/
	rm -rf $(CTANDIR)/*
	cd $(TESTDIR) ; \
	cp -f *.dtx $(CTANDIR)/ ; \
	for I in $(INCLUDEPDF) ; do \
	  cp -f $$I.pdf $(CTANDIR)/ ; \
	done ; \
	for I in $(INCLUDETEX); do \
	  cp -f $$I.tex $(CTANDIR)/ ; \
	done ; \
	for I in $(INCLUDETXT); do \
	  cp -f $$I.txt $(CTANDIR)/; \
	  mv $(CTANDIR)/$$I.txt $(CTANDIR)/$$I ; \
	done ; \
	for I in $(UNPACK); do \
	  cp -f $$I $(CTANDIR)/ ; \
	done ; \
	cp $(PACKAGE).tds.zip $(CTANROOT)/ 
	cd $(CTANROOT) ; \
	zip -ll -q -r -X $(PACKAGE).zip .
	cp $(CTANROOT)/$(PACKAGE).zip ./

doc: unpack $(TESTDIR)/$(F).pdf

format: \
	$(foreach FILE,$(DTXFILES),$(TESTDIR)/$(FILE).dtx) \
	$(foreach FILE,$(FORMAT),$(TESTDIR)/$(FILE)) 
	echo "Making format"
	for I in $(XPACKAGES) ; do \
	  cp $(XPACKAGEDIR)/$$I/*.dtx $(TESTDIR)/ ; \
	done
	cd $(TESTDIR) ; \
	for I in $(FORMAT) ; do \
	  tex $$I &> /dev/null ; \
	done ; \
	pdftex -etex -ini "*latex3.ltx" 

localinstall: unpack
	echo "Installing files"
	TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	mkdir -p $$TEXMFHOME/makeindex/$(PACKAGE)/ ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	rm -rf $$TEXMFHOME/makeindex/$(PACKAGE)/* ; \
	cp l3vers.dtx $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	cd $(TESTDIR) ; \
	cp *.cls $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	cp *.sty $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	cp l3doc.ist $$TEXMFHOME/makeindex/$(PACKAGE) 
	texhash &> /dev/null

savetlg: $(TESTDIR)/$(F).lvt support unpack
	echo "Creating and copying $(F).tlg"
	cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	pdflatex $(F).lvt &> /dev/null ; \
	pdflatex $(F).lvt &> /dev/null ; \
	rm -f $$I.pdf ; \
	perl $(SCRIPTDIR)/log2tlg $(F) < $(F).log > $(F).tlg
	cp -f $(TESTDIR)/$(F).tlg $(TESTFILEDIR)/$(F).tlg	

sourcedoc: unpack $(foreach FILE,$(INCLUDEPDF),$(TESTDIR)/$(FILE).pdf)

tds: $(foreach FILE,$(INCLUDETXT),$(TESTDIR)/$(FILE).txt) sourcedoc
	echo "Creating TDS archive"
	mkdir -p $(TDSDIR)/
	rm -rf $(TDSDIR)/*
	mkdir -p $(TDSDIR)/doc/$(PACKAGEROOT)/
	mkdir -p $(TDSDIR)/makeindex/$(PACKAGE)/
	mkdir -p $(TDSDIR)/source/$(PACKAGEROOT)/
	mkdir -p $(TDSDIR)/tex/$(PACKAGEROOT)/
	cd $(TESTDIR) ; \
	cp -f *.cls $(TDSDIR)/tex/$(PACKAGEROOT)/ ; \
	cp -f *.dtx $(TDSDIR)/source/$(PACKAGEROOT)/ ; \
	cp -f *.ist $(TDSDIR)/makeindex/$(PACKAGE)/ ; \
	for I in $(INCLUDEPDF) ; do \
	  cp -f $$I.pdf $(TDSDIR)/doc/$(PACKAGEROOT)/ ; \
	done ; \
	cp -f *.sty $(TDSDIR)/tex/$(PACKAGEROOT)/ ; \
	for I in $(INCLUDETEX); do \
	  cp -f $$I.tex $(TDSDIR)/doc/$(PACKAGEROOT)/ ; \
	done ; \
	for I in $(INCLUDETXT); do \
	  cp -f $$I.txt $(TDSDIR)/doc/$(PACKAGEROOT)/ ; \
	  mv $(TDSDIR)/doc/$(PACKAGEROOT)/$$I.txt $(TDSDIR)/doc/$(PACKAGEROOT)/$$I ; \
	done 
	cd $(TDSDIR) ; \
	zip -ll -q -r -X $(PACKAGE).tds.zip .
	cd $(TESTDIR) ; \
	cp $(TDSDIR)/$(PACKAGE).tds.zip ./

unpack: $(foreach FILE,$(DTX) $(UNPACK),$(TESTDIR)/$(FILE))
	echo "Unpacking files"
	cd $(TESTDIR) ; \
	for I in $(UNPACK) ; do \
	  tex $$I &> /dev/null ; \
	done
