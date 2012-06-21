################################################################
################################################################
# Makefile for LaTeX3 "l3benchmark" files                      #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make check            - runs automated test suite"
	@echo " make checklvt F=<name> - runs automated test on <name>"
	@echo " make clean            - clean out test directory"
	@echo " make cleanall         - clean out test and current directory"
	@echo " make doc              - typeset documentation"
	@echo " make localinstall     - install files in local texmf tree"
	@echo " make savetlg F=<name> - save test log for <name>"
	@echo " make unpack           - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = l3benchmark
L3DIR   = l3trial

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ../..
EXPL3DIR    := $(BASEDIR)/l3kernel
SUPPORTDIR  := $(BASEDIR)/support
TESTFILEDIR := $(SOURCEDIR)/testfiles
VALIDATEDIR := $(BASEDIR)/validate

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
SCRIPTDIR  := $(shell test -d $(L3TESTDIR)/scripts || mkdir -p $(L3TESTDIR)/scripts ; cd $(L3TESTDIR)/scripts ; pwd)
TESTDIR    := $(shell test -d $(L3TESTDIR)/test/$(L3DIR)/$(PACKAGE) || mkdir -p $(L3TESTDIR)/test/$(L3DIR)/$(PACKAGE) ; cd $(L3TESTDIR)/test/$(L3DIR)/$(PACKAGE) ; pwd)
TESTAUXDIR := $(shell test -d $(TESTDIR)/testfiles || mkdir -p $(TESTDIR)/testfiles ; cd $(TESTDIR)/testfiles ; pwd)

##############################################################
# Data for local installation and TDS construction           #
##############################################################

PACKAGEROOT := latex/$(L3DIR)/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

DTX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
DTXFILES  = $(subst .dtx,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
TEX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.tex)))
UNPACK    = $(PACKAGE).ins

##############################################################
# Files for the check systems                                #
##############################################################

CHECKFILES = $(subst .tlg,,$(notdir $(wildcard $(TESTFILEDIR)/*.tlg)))
SCRIPTS    = log2tlg
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

################################################################
# File copying: specials                                       #
################################################################

$(TESTDIR)/commands-check.tex: $(VALIDATEDIR)/commands-check.tex
	@cp -fp $< $@	

$(TESTDIR)/regression-test.tex: $(VALIDATEDIR)/regression-test.tex
	@cp -fp $< $@	

################################################################
# File building: default actions                                #
################################################################

$(TESTDIR)/%.pdf: $(TESTDIR)/%.dtx
	@NAME=`basename $< .dtx` ; \
	echo "Typesetting $$NAME" ; \
	cd $(TESTDIR) ; \
	pdflatex -draftmode -interaction=nonstopmode "$(PDFSETTINGS) \input $<" > /dev/null ; \
	if [ $$? = 0 ] ; then  \
	  makeindex -q -s l3doc.ist -o $$NAME.ind $$NAME.idx > /dev/null ; \
	  pdflatex -interaction=nonstopmode "$(PDFSETTINGS) \input $<" > /dev/null ; \
	  pdflatex -interaction=nonstopmode "$(PDFSETTINGS) \input $<" > /dev/null ; \
	  if [ `grep 'defined but not documented' $$NAME.log | wc -l` -ne 0 ] ; then \
	    echo "! Warning: some functions defined but not documented" ; \
	  fi ; \
	  if [ `grep 'documented but not defined' $$NAME.log | wc -l` -ne 0 ]  ; then \
	    echo "! Warning: some functions documented but not defined" ; \
	  fi ; \
	else \
	  echo "  Compilation failed" ; \
	fi ; \
	for I in $(AUXFILES) ; do \
	  rm -f $$NAME.$$I ; \
	done

################################################################
# Internal make options                                        #
################################################################

.PHONY = \
	expl3 \
	support

expl3:
	cd $(EXPL3DIR) ; \
	make localinstall

support: \
	$(foreach FILE,$(SCRIPTS),$(SCRIPTDIR)/$(FILE))  \
	$(foreach FILE,$(VALIDATE),$(TESTDIR)/$(FILE))

################################################################
# User make options                                            #
################################################################

.PHONY = \
	check        \
	checklvt     \
	clean        \
	cleanall     \
	doc          \
	localinstall \
	savetlg      \
	test         \
	unpack

clean:
	@echo "Cleaning up"
	rm -rf $(TESTDIR)/*

cleanall: clean
	@for I in $(AUXFILES) $(CLEAN) ; do \
	  rm -f *.$$I ; \
	done

check: \
	$(foreach FILE,$(CHECKFILES),$(TESTDIR)/$(FILE).lvt) \
	$(foreach FILE,$(CHECKFILES),$(TESTDIR)/$(FILE).tlg) \
	expl3 support unpack
	@echo "Running checks on"
	@cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	for I in $(CHECKFILES) ; do \
	  echo "  $$I" ; \
	  pdflatex $$I.lvt > /dev/null ; \
	  pdflatex $$I.lvt > /dev/null ; \
	  perl $(SCRIPTDIR)/log2tlg $$I < $$I.log > $$I.new.log ; \
	  if !(cmp -s $$I.tlg $$I.new.log) ; then \
	    diff -c $$I.tlg $$I.new.log > $$I.diff ; \
	  fi ; \
	  for J in $(AUXFILES) lvt tlg ; do \
	    rm -f $$I.$$J ; \
	  done ; \
	done ; \
	if [ `ls -1 *.diff 2>/dev/null | wc -l` != 0 ] ; then \
	  echo "  Check failed with difference files" ; \
	  for I in *.diff ; do \
	    echo "  - " `pwd`"/$$I" ; \
	  done ; \
	else \
	  echo "  All checks passed" ; \
	fi

checklvt: $(TESTDIR)/$(F).lvt $(TESTDIR)/$(F).tlg support unpack
	@echo "Running checks on $(F)"
	@cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	pdflatex $(F).lvt ; \
	pdflatex $(F).lvt > /dev/null ; \
	perl $(SCRIPTDIR)/log2tlg $(F) < $(F).log > $(F).new.log ; \
	if !(cmp -s $(F).tlg $(F).new.log) ; then \
	  diff -c $(F).new.log $(F).tlg > $(F).diff ; \
	fi ; \
	for I in $(AUXFILES) lvt pdf tlg ; do \
	  rm -f $(F).$$I ; \
	done ; \
	if (test -f $(F).diff) ; then \
	  echo "  Check failed" ; \
	  more `pwd`/$(F).diff ; \
	else \
	  echo "  Check passed" ; \
	fi

doc: unpack $(foreach FILE,$(DTXFILES),$(TESTDIR)/$(FILE).pdf)

localinstall: unpack
	@echo "Installing $(PACKAGE)"
	@TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	cd $(TESTDIR) ; \
	cp *.sty $$TEXMFHOME/tex/$(PACKAGEROOT)/

savetlg: $(TESTDIR)/$(F).lvt support unpack
	@echo "Creating and copying $(F).tlg"
	@cd $(TESTDIR) ; \
	for I in $(AUXFILES) diff ; do \
	  rm -f *.$$I ; \
	done ; \
	pdflatex $(F).lvt > /dev/null ; \
	pdflatex $(F).lvt > /dev/null ; \
	rm -f $$I.pdf ; \
	perl $(SCRIPTDIR)/log2tlg $(F) < $(F).log > $(F).tlg
	cp -f $(TESTDIR)/$(F).tlg $(TESTFILEDIR)/$(F).tlg

unpack: $(foreach FILE,$(DTX) $(TEX) $(UNPACK),$(TESTDIR)/$(FILE))
	@echo "Unpacking files"
	@cd $(TESTDIR) ; \
	for I in $(UNPACK) ; do \
	  tex $$I > /dev/null ; \
	done
