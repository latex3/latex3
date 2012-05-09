################################################################
################################################################
# Makefile for LaTeX3                                          #
################################################################
################################################################

################################################################
# Default with no target is to give help                       #
################################################################

help:
	@echo ""
	@echo " make check        - runs automated test suite"
	@echo " make clean        - clean out test directory"
	@echo " make cleanall     - clean out current and test directory"
	@echo " make ctan         - create CTAN-ready archives"
	@echo " make localinstall - install files in local texmf tree"
	@echo " make unpack       - extract packages"
	@echo ""

##############################################################
# Directories to process                                     #
##############################################################

CTAN    = l3kernel l3packages l3experimental
INCLUDE = l3kernel l3packages l3experimental l3trial

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test

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
	localinstall \
	unpack
	
check:
	for I in $(INCLUDE) ; do \
	  cd $$I ; \
	  make check ; \
	  cd .. ; \
	done

clean:
	echo "Cleaning up"
	rm -rf $(L3TESTDIR)/*

cleanall: clean
	for I in $(INCLUDE) ; do \
	  cd $$I ; \
	  make cleanall ; \
	  cd .. ; \
	done
	for I in $(CLEAN) ; do \
	  rm -f *.$$I ;\
	done
	
ctan: cleanall localinstall
	for I in $(CTAN) ; do \
	  cd $$I ; \
	  make ctan ; \
	  cd .. ; \
	  cp $$I/$$I.zip ./ ; \
	done
	
localinstall:
	for I in $(INCLUDE) ; do \
	  cd $$I ; \
	  make localinstall ; \
	  cd .. ; \
	done
	
unpack:
	for I in $(INCLUDE) ; do \
	  cd $$I ; \
	  make unpack ; \
	  cd .. ; \
	  cp $$I/$$I.zip ./ ; \
	done
