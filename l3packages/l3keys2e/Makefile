################################################################
################################################################
# Makefile for LaTeX3 "l3keys2e" files                         #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make clean        - clean out test directory"
	@echo " make cleanall     - clean out test and current directory"
	@echo " make doc          - typeset documentation"
	@echo " make localinstall - install files in local texmf tree"
	@echo " make unpack       - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = l3packages/l3keys2e

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ../..
EXPL3DIR    := $(BASEDIR)/l3kernel

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
TESTDIR    := $(shell test -d $(L3TESTDIR)/test/$(PACKAGE) || mkdir -p $(L3TESTDIR)/test/$(PACKAGE) ; cd $(L3TESTDIR)/test/$(PACKAGE) ; pwd)

##############################################################
# Data for local installation and TDS construction           #
##############################################################

PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

DTX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
DTXFILES  = $(subst .dtx,,$(notdir $(wildcard $(SOURCEDIR)/*.dtx)))
TEX       = $(subst ,,$(notdir $(wildcard $(SOURCEDIR)/*.tex)))
UNPACK    = l3keys2e.ins

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

$(TESTDIR)/%.dtx: $(SOURCEDIR)/%.dtx
	@cp -fp $< $@

$(TESTDIR)/%.ins: $(SOURCEDIR)/%.ins
	@cp -fp $< $@

$(TESTDIR)/%.tex: $(SOURCEDIR)/%.tex
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
	expl3

expl3:
	cd $(EXPL3DIR) ; \
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
	unpack

check:

clean:
	echo "Cleaning up"
	rm -rf $(TESTDIR)/*.*

cleanall: clean
	for I in $(AUXFILES) $(CLEAN) ; do \
	  rm -f *.$$I ; \
	done

doc: $(foreach FILE,$(DTXFILES),$(TESTDIR)/$(FILE).pdf)

localinstall: unpack
	@echo "Installing $(PACKAGE)"
	TEXMFHOME=`kpsewhich --var-value=TEXMFHOME` ; \
	mkdir -p $$TEXMFHOME/tex/$(PACKAGEROOT)/ ; \
	rm -rf $$TEXMFHOME/tex/$(PACKAGEROOT)/* ; \
	cd $(TESTDIR) ; \
	cp *.sty $$TEXMFHOME/tex/$(PACKAGEROOT)/

unpack: $(foreach FILE,$(DTX) $(TEX) $(UNPACK),$(TESTDIR)/$(FILE))
	echo "Unpacking files"
	cd $(TESTDIR) ; \
	for I in $(UNPACK) ; do \
	  tex $$I > /dev/null ; \
	done
