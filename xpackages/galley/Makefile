################################################################
################################################################
# Makefile for LaTeX3 "galley" files                           #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make check            - runs automated test suite"
	@echo " make clean            - clean out test directory"
	@echo " make cleanall         - clean out test and current directory"
	@echo " make doc              - typeset documentation"
	@echo " make localinstall     - install files in local texmf tree"
	@echo " make test             - typeset test files"
	@echo " make unpack           - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = xpackages/galley

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ../..
EXPL3DIR    := $(BASEDIR)/l3in2e
SUPPORTDIR  := $(BASEDIR)/support
TESTFILEDIR := $(SOURCEDIR)/testfiles
VALIDATEDIR := $(BASEDIR)/validate
XBASEDIR    := $(BASEDIR)/xpackages/xbase

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
TESTDIR    := $(shell test -d $(L3TESTDIR)/test/$(PACKAGE) || mkdir -p $(L3TESTDIR)/test/$(PACKAGE) ; cd $(L3TESTDIR)/test/$(PACKAGE) ; pwd)
TESTAUXDIR := $(shell test -d $(TESTDIR)/testfiles || mkdir -p $(TESTDIR)/testfiles ; cd $(TESTDIR)/testfiles ; pwd)

##############################################################
# Data for local installation and TDS construction           #
##############################################################

PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

DTX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
DTXFILES  = $(subst .dtx,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
TESTFILES = xhj-test
TEX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.tex)))
UNPACK    = galley2.ins

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
# File copying: default actions                                #
################################################################

$(TESTDIR)/%.dtx: $(SOURCEDIR)/%.dtx
	@cp -fp $< $@

$(TESTDIR)/%.ins: $(SOURCEDIR)/%.ins
	@cp -fp $< $@

$(TESTDIR)/%.tex: $(SOURCEDIR)/%.tex
	@cp -fp $< $@	

$(TESTDIR)/%.txt: $(SOURCEDIR)/%.txt
	@cp -fp $< $@	

################################################################
# File building: default actions                                #
################################################################

$(TESTDIR)/%.pdf: $(TESTDIR)/%.dtx
	NAME=`basename $< .dtx` ; \
	echo "Typesetting $$NAME" ; \
	cd $(TESTDIR) ; \
	pdflatex -draftmode -interaction=nonstopmode "$(PDFSETTINGS) \input $<" > /dev/null ; \
	if [ $$? = 0 ] ; then  \
	  makeindex -s l3doc.ist -o $$NAME.ind $$NAME.idx > /dev/null ; \
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
	expl3   \
	support \
	xbase

expl3:
	cd $(EXPL3DIR) ; \
	make localinstall

support: \
	$(foreach FILE,$(SCRIPTS),$(SCRIPTDIR)/$(FILE))  \
	$(foreach FILE,$(VALIDATE),$(TESTDIR)/$(FILE))

xbase:
	cd $(XBASEDIR) ; \
	make localinstall

################################################################
# User make options                                            #
################################################################

.PHONY = \
	check        \
	clean        \
	cleanall     \
	doc          \
	localinstall \
	test         \
	unpack

clean:
	echo "Cleaning up"
	rm -rf $(TESTDIR)/*.*

cleanall: clean
	for I in $(AUXFILES) $(CLEAN) ; do \
	  rm -f *.$$I ; \
	done

doc: $(foreach FILE,$(DTXFILES),$(TESTDIR)/$(FILE).pdf)

localinstall: unpack
	echo "Installing files"
	TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	cd $(TESTDIR) ; \
	cp *.sty $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	texhash > /dev/null

test: \
	$(foreach FILE,$(TESTFILES),$(TESTDIR)/$(FILE).tex) \
	expl3 unpack
	echo "Testing files"
	cd $(TESTDIR) ;\
	for I in $(TESTFILES) ; do \
	  echo " $$I" ; \
	  pdflatex  $$I ; \
	done

unpack: $(foreach FILE,$(DTX) $(TEX) $(UNPACK),$(TESTDIR)/$(FILE))
	echo "Unpacking files"
	cd $(TESTDIR) ; \
	for I in $(UNPACK) ; do \
	  tex $$I > /dev/null ; \
	done
