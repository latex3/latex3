
help:
	@echo all:
	@echo clean:
	@echo cleanupdist:
	@echo cleanuptest:
	@echo cleanuptmp:
	@echo distrib:
	@echo release:
	@echo check:

CO = co
COFLAGS = -M

RELEASE_DATE = 2002/06/01

ifdef LTOPDIR

L2DIR := $(LTOPDIR)/latex2e
SCRIPTDIR := $(L2DIR)/scripts

else

SMAINDIR = ..
L2DIR := $(SMAINDIR)/..
LTOPDIR := $(shell cd $(SMAINDIR)/../.. ; pwd)
SCRIPTDIR := $(shell test -d $(L2DIR)/scripts || mkdir -p $(L2DIR)/scripts ; cd $(L2DIR)/scripts ; pwd)

endif

DISTDIR := $(L2DIR)/distrib/l3in2e
SRCDIR := $(L2DIR)/latex2e
L3DIR := $(SRCDIR)/l3in2e
SUPPORTDIR := $(SRCDIR)/support
export TTMPDIR := $(L2DIR)/tmp/l3in2e
TESTDIR := $(L2DIR)/test/l3in2e
LTESTDIR := $(L2DIR)/test/latex2e
TEXDIR := $(L2DIR)/texinputs/latex2e
LATEXDIR := $(L2DIR)/base
LUDISTDIR := $(L2DIR)/distrib/latex2e/unpacked

FORMAT := $(LTESTDIR)/latex.fmt
FORMAT_AUTOLOAD := $(LTESTDIR)/latexa.fmt

commav = ,v

export TEXINPUTS:=.:$(shell test -d $(DISTDIR) || mkdir -p $(DISTDIR) ; echo $(DISTDIR)):$(shell test -d $(LUDISTDIR) || mkdir -p $(LUDISTDIR) ; echo $(LUDISTDIR)):$(shell test -d $(LTESTDIR) || mkdir -p $(LTESTDIR); echo $(LTESTDIR)):\$(shell test -d $(TEXDIR) || mkdir -p $(TEXDIR) ; echo $(TEXDIR))//
export INDEXSTYLE:=.:$(shell test -d $(DISTDIR) || mkdir -p $(DISTDIR) ; echo $(DISTDIR)):$(shell test -d $(LUDISTDIR) || mkdir -p $(LUDISTDIR) ; echo $(LUDISTDIR)):$(shell test -d $(TEXDIR) || mkdir -p $(TEXDIR) ; cd $(TEXDIR) ; pwd)


STATE = Exp


#
# scripts used in this make
#


SCRIPTS = \
	checktlg \
	cleartex \
	cleartexdir \
	copywithheader \
	find-long-lines \
	generate-ltvers \
	generatefromwith \
	generateinstall2e \
	generatemanifest2e \
	generateunpack2e \
	log2tlg \
	maketlg \
	merge-changelogs \
	run-tex

#
# default pattern rules for scripts
#

$(SCRIPTDIR)/%:	$(SUPPORTDIR)/%
	cp $< $@
	chmod +x $@

scripts:	$(foreach file,$(SCRIPTS),$(SCRIPTDIR)/$(file))


DTX = \
	l3basics.dtx \
	l3chk.dtx \
	l3expan.dtx \
	l3int.dtx \
	l3io.dtx \
	l3names.dtx \
	l3precom.dtx \
	l3prop.dtx \
	l3quark.dtx \
	l3seq.dtx \
	l3tlp.dtx \
	l3toks.dtx 


INS = l3.ins

TEST = \
	test1.tex \
	test2.tex \
	test3.tex

README = readme.txt

DOCS = \
	expl3.tex

CLASS = \
	l3doc.cls

CHANGELOGS = \
	ChangeLog.dpc \
	ChangeLog.fmi \
	ChangeLog.jlb \
	ChangeLog.rms


FILES = $(DTX) $(INS) $(TEST) $(README) $(DOCS) $(CLASS)

# driver files

DRIVERS = $(filter %.dtx,$(FILES))

# distribution files:

SRC = $(FILES)
DF = $(foreach file,$(SRC),$(DISTDIR)/$(file))

# test files
# Naming convention: all start with "tt"
#	  3rd letter: c - compatibility mode
#		      x - 2e mode
#	  two digit sequence number
#	  a/b/l/p/r/s for main document style/class

BUGCHECK = $(subst .tlg,,$(notdir $(wildcard $(TESTFILEDIR)/tlb*.tlg)))

CFS = $(foreach file,$(BUGCHECK),$(file).lvt)
CLS = $(foreach file,$(BUGCHECK),$(TLG_PREFIX)$(file).tlg)

REQUIRED_DIRS := $(TTMPDIR) $(DISTDIR) $(LUDISTDIR) $(TESTDIR) $(LTESTDIR) $(TEXDIR)

dirs:	$(REQUIRED_DIRS)

$(REQUIRED_DIRS):
	mkdir -p $@


$(TTMPDIR)/%:	$(L3DIR)/%
	@cp -p $< $@

#
# default pattern rules for test files in test directory
#

ifdef AL

export TLG_PREFIX=auto-
#export EXTRA_SED_SCRIPTS=-e /(auto/s/(auto[a-z0-9]*\.sty.*$$// -e s/^)$$//
export BEFORE_SED_SCRIPTS=-e /^(auto\(err\|fss1\|out1\|pict\|tabg\)\.sty/,/^)/d

$(TESTDIR)/$(TLG_PREFIX)%:   $(TESTDIR)/%
	rm -f $@
	ln -s $(<F) $@

endif

$(TESTDIR)/%:	$(DISTDIR)/%
	rm -f $@
	ln -s $< $@

#$(TESTDIR)/%:	$(RCSDIR)/%$(commav)
#	@$(CO) $(COFLAGS) -r`rlog -s$(STATE) $< |grep "^revision"|sed -e "s/revision //" -e "s/ *locked by:.*$$//"|sort -t . +0nr -1 +1nr -2 +2nr -3 +3nr -4 |head -1` $< $@

#
# default pattern rule for distribution files
#

$(DISTDIR)/%:	$(TTMPDIR)/%
	rm -f $@
	expand $< >$@
	touch -r $< $@

$(DISTDIR)/changes.txt:	$(foreach file,$(CHANGELOGS),$(TTMPDIR)/$(file))
	 perl $(SCRIPTDIR)/merge-changelogs $@ $^

$(DISTDIR)/l3.ins:	$(TTMPDIR)/l3.ins
	rm -f $@
	expand $< >$@
	touch -r $< $@


# goals

all:	distrib styles

clean:	cleanupdist cleanuptest cleanuptmp

cleanuptmp:
	rm -f $(TTMPDIR)/*

cleanuptest:
	rm -f $(TESTDIR)/*

cleanupdist:
	rm -f $(DISTDIR)/*

#
# texinputs files
#

texinputs:	$(TEXDIR)/Makefile
	cd $(TEXDIR); $(MAKE)

$(TEXDIR)/Makefile:	$(SUPPORTDIR)/Makefile.texinputs
	cp -p $< $@

distrib:	dirs scripts $(DF)
	-perl  $(SCRIPTDIR)/find-long-lines -l 80 $(DISTDIR)/*


tardist:	distrib
	cd $(DISTDIR)/../.. ; tar czf l3in2e.tar.gz l3in2e

zipdist:	distrib
	cd $(DISTDIR)/../.. ; zip -r l3in2e.zip l3in2e


release:
	$(MAKE) distrib STATE=Rel


styles:	distrib
	cd $(TEXDIR) ; \
	echo_answer -n 50 y | latex l3.ins ; rm l3.log


drivers:	$(foreach file,$(DRIVERS),$(TESTDIR)/$(file))

rundrivers:	$(foreach file,$(DRIVERS),$(TESTDIR)/$(file))
	cd $(TESTDIR) ; \
	for f in $^ ; do $(SCRIPTDIR)/run-tex $(LTESTDIR)/latex $$f || break ; done

run-one-driver:	$(TESTDIR)/$(DRIVER_TO_CHECK).dtx
	cd $(TESTDIR) ; $(SCRIPTDIR)/run-tex $(LTESTDIR)/latex $<

checkdrivers:	$(foreach file,$(DRIVERS),$(TESTDIR)/$(file))
	FAILED_DRIVERS="" ; \
	cd $(TESTDIR) ; \
	for f in $^ ; \
	do \
	  $(SCRIPTDIR)/run-tex $(LTESTDIR)/latex $$f scrollmode || FAILED_DRIVERS="$$FAILED_DRIVERS $$f" ; \
	done ; \
	echo ; \
	echo List of drivers that could not be run successfully: ; \
	echo =================================================== ; \
	echo ; \
	for f in $$FAILED_DRIVERS ;\
	  do \
	    b=`basename $$f | sed -e 's/\..*$$//'` ; \
            if grep "Checksum not passed" $$b.log >/dev/null ; \
              then error="checksum wrong" ; \
            elif test -f $$b.ilg && grep "error" $$b.ilg >/dev/null ; \
              then error="makeindex error" ; \
            else error="other tex error" ; \
            fi ; \
	  echo $$f "---" $$error ;\
	done ; \
	echo ; \
	echo


make-tlg-file:	scripts texinputs $(TESTDIR)/$(FILE_TO_CHECK).lvt
	cd $(TESTDIR) ; \
	$(SCRIPTDIR)/maketlg $(TESTDIR)/latex$(AL) $(FILE_TO_CHECK)

check-one-file:	scripts texinputs $(TESTDIR)/$(FILE_TO_CHECK).lvt $(TESTDIR)/$(TLG_PREFIX)$(FILE_TO_CHECK).tlg
	cd $(TESTDIR) ; \
	$(SCRIPTDIR)/checktlg $(LTESTDIR)/latex$(AL) $(FILE_TO_CHECK)

check-one-file-autoload:
	$(MAKE) check-one-file AL=a

checkonly:	scripts texinputs $(foreach file,$(CFS) $(CLS),$(TESTDIR)/$(file)) $(TEXDIR)/test2e.tex
	cd $(TESTDIR) ; \
	rm -f *tmp* *.log *.diff *.gls *.ind ; \
	for i in  $(CFS); \
	do \
	  $(SCRIPTDIR)/checktlg $(LTESTDIR)/latex$(AL) $$i ; \
	done ; \
	echo ; \
	echo List of diffs produced during check: ; \
	echo ==================================== ; \
	echo ; \
	ls -al *.diff ; \
	echo ; \
	echo


checkonly-autoload:
	$(MAKE) checkonly AL=a

check:	checkonly

check-autoload:	checkonly-autoload
