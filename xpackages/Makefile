################################################################
################################################################
# Makefile for LaTeX3 "xpackage" files                         #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make check        - runs automated test suite"
	@echo " make clean        - clean out test directory"
	@echo " make cleanall     - clean out test and current directory"
	@echo " make ctan         - create a CTAN-ready archive"
	@echo " make doc          - typeset documentation"
	@echo " make localinstall - install files in local texmf tree"
	@echo " make tds          - create a TDS-ready archive"
	@echo " make unpack       - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = xpackages

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ..

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
TESTDIR    := $(shell test -d $(L3TESTDIR)/test/$(PACKAGE) || mkdir -p $(L3TESTDIR)/test/$(PACKAGE) ; cd $(L3TESTDIR)/test/$(PACKAGE) ; pwd)

##############################################################
# Directory structure for making zip files                   #
##############################################################

CTANROOT := $(TESTDIR)/ctan
CTANDIR  := $(TESTDIR)/ctan/$(PACKAGE)
TDSDIR   := $(TESTDIR)/tds

##############################################################
# Data for local installation and TDS construction           #
##############################################################

PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

ALLPACKAGES = \
	galley    \
	xcontents \
	xfootnote \
	xfrontm   \
	xhead     \
	xinitials \
	xlang     \
	xor       \
	xtheorem
XPACKAGES   = xhead

################################################################
# File copying: default actions                                #
################################################################

$(TESTDIR)/%.txt: $(SOURCEDIR)/%.txt
	@cp -fp $< $@	

################################################################
# User make options                                            #
################################################################

.PHONY = \
	check        \
	clean        \
	cleanall     \
	ctan         \
	doc          \
	localinstall \
	tds          \
	unpack

check:
	for I in $(ALLPACKAGES) ; do \
	  cd $$I ; \
	  make check ; \
	  cd .. ; \
	done

clean:
	echo "Cleaning up"
	rm -rf $(L3TESTDIR)/*

cleanall: clean
	for I in $(XPACKAGES) ; do \
	  cd $$I ; \
	  make cleanall ; \
	  cd .. ; \
	done

ctan: tds
	echo "Creating CTAN archive"
	mkdir -p $(CTANDIR)/
	rm -rf $(CTANDIR)/*
	for I in $(XPACKAGES) ; do \
	  cd $(TESTDIR)/$$I/ ; \
	  cp -f *.dtx $(CTANDIR)/ ; \
	  cp -f *.ins $(CTANDIR)/ ; \
	  cp -f *.pdf $(CTANDIR)/ ; \
	  cp -f *.tex $(CTANDIR)/ ; \
	done
	cd $(TESTDIR) ; \
	cp $(PACKAGE).tds.zip $(CTANROOT)/ ; \
	cp -f readme-ctan.txt $(CTANDIR)/ ; \
	mv $(CTANDIR)/readme-ctan.txt $(CTANDIR)/README ; \
	cd $(CTANROOT) ; \
	zip -ll -q -r -X $(PACKAGE).zip .
	cp $(CTANROOT)/$(PACKAGE).zip ./

doc:
	for I in $(XPACKAGES) ; do \
	  cd $$I ; \
	  make doc ; \
	  cd .. ; \
	done

localinstall:
	for I in $(XPACKAGES) ; do \
	  cd $$I ; \
	  make localinstall ; \
	  cd .. ; \
	done

tds: $(TESTDIR)/readme-ctan.txt doc unpack
	echo "Creating TDS archive"
	mkdir -p $(TDSDIR)/
	rm -rf $(TDSDIR)/*
	mkdir -p $(TDSDIR)/doc/$(PACKAGEROOT)/
	mkdir -p $(TDSDIR)/source/$(PACKAGEROOT)/
	mkdir -p $(TDSDIR)/tex/$(PACKAGEROOT)/
	for I in $(XPACKAGES) ; do \
	  cd $(TDSDIR) ; \
	  mkdir -p doc/$(PACKAGEROOT)/$$I/ ; \
	  mkdir -p source/$(PACKAGEROOT)/$$I/ ; \
	  mkdir -p tex/$(PACKAGEROOT)/$$I/ ; \
	  cd $(TESTDIR)/$$I/ ; \
	  cp -f *.dtx $(TDSDIR)/source/$(PACKAGEROOT)/$$I/ ; \
	  cp -f *.ins $(TDSDIR)/source/$(PACKAGEROOT)/$$I/ ; \
	  cp -f *.pdf $(TDSDIR)/doc/$(PACKAGEROOT)/$$I/ ; \
	  cp -f *.sty $(TDSDIR)/tex/$(PACKAGEROOT)/$$I/ ; \
	  cp -f *.tex $(TDSDIR)/doc/$(PACKAGEROOT)/$$I/ ; \
	done
	cd $(TESTDIR) ; \
	cp -f readme-ctan.txt $(TDSDIR)/doc/$(PACKAGEROOT)/ ; \
	cd $(TDSDIR) ; \
	mv doc/$(PACKAGEROOT)/readme-ctan.txt doc/$(PACKAGEROOT)/README ; \
	zip -ll -q -r -X $(PACKAGE).tds.zip . ; \
	cd $(TESTDIR) ; \
	cp $(TDSDIR)/$(PACKAGE).tds.zip ./

unpack:
	for I in $(ALLPACKAGES) ; do \
	  cd $$I ; \
	  make unpack ; \
	  cd .. ; \
	done
