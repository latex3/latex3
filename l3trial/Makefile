################################################################
################################################################
# Makefile for LaTeX3 "l3trial" files                          #
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
	@echo " make doc          - typeset documentation"
	@echo " make localinstall - install files in local texmf tree"
	@echo " make unpack       - extract packages"
	@echo ""

##############################################################
# Master package name                                        #
##############################################################

PACKAGE = l3trial

##############################################################
# Directory structure for source files                       #
##############################################################

SOURCEDIR   := .
BASEDIR     := ..

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test

##############################################################
# Data for local installation and TDS construction           #
##############################################################

PACKAGEROOT := latex/$(PACKAGE)

##############################################################
# Details of source files                                    #
##############################################################

PACKAGES = l3benchmark l3bigint l3check l3fp-extras l3hooks l3kernel-extras l3ldb l3rand l3trace l3tree xbox xfont xmetadata

##############################################################
# Clean-up information                                       #
##############################################################

CLEAN = zip

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
	for I in $(PACKAGES) ; do \
	  cd $$I ; \
	  make check ; \
	  cd .. ; \
	done

clean:
	echo "Cleaning up"
	rm -rf $(L3TESTDIR)/*

cleanall: clean
	for I in $(PACKAGES) ; do \
	  cd $$I ; \
	  make cleanall ; \
	  cd .. ; \
	done
	for I in $(CLEAN) ; do \
	  rm -f *.$$I ;\
	done

ctan:

doc:
	for I in $(PACKAGES) ; do \
	  cd $$I ; \
	  make doc ; \
	  cd .. ; \
	done

localinstall:
	for I in $(PACKAGES) ; do \
	  cd $$I ; \
	  make localinstall ; \
	  cd .. ; \
	done

tds:

unpack:
	for I in $(PACKAGES) ; do \
	  cd $$I ; \
	  make unpack ; \
	  cd .. ; \
	done
