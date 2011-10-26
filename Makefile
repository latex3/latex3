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
	@echo ""

##############################################################
# Directories to process                                     #
##############################################################

INCLUDE = l3kernel l3packages l3experimental

##############################################################
# Directory structure for test system                        #
##############################################################

L3TESTDIR  := /tmp/l3test
	
################################################################
# User make options                                            #
################################################################

.PHONY = \
	check        \
	clean        \
	cleanall     \
	ctan         \
	localinstall
	
check:
	for I in $(INCLUDE) ; do \
	  pushd $$I ; \
	  make check ; \
	  popd ; \
	done

clean:
	echo "Cleaning up"
	rm -rf $(L3TESTDIR)/*

cleanall: clean
	for I in $(INCLUDE) ; do \
	  pushd $$I ; \
	  make cleanall ; \
	  popd ; \
	done
	rm -f *.zip
	
ctan: clean localinstall
	for I in $(INCLUDE) ; do \
	  pushd $$I ; \
	  make ctan ; \
	  popd ; \
	  cp $$I/$$I.zip ./ ; \
	done
	
localinstall:
	for I in $(INCLUDE) ; do \
	  pushd $$I ; \
	  make localinstall ; \
	  popd ; \
	done