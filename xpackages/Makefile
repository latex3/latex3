
all:	xbase.tgz xfrontm.tgz xfrontm-pics.tgz

clean:
	rm -f *.tgz
	rm -f *~

check:
	make check-galley
	# make check-xbase
	make check-xfootnote
	make check-xfrontm
	make check-xhead
	make check-xinitials
	# make check-xlang
	make check-xor
	make check-xtheorem

check-%:
	echo '   '
	cd $* ; make check
	echo '$* check passed.\n' ; \

xbase.tgz: xbase
	tar cvzf xbase.tgz xbase/ldcsetup.dtx \
			   xbase/template.dtx \
			   xbase/xbase.ins \
			   xbase/xparse.dtx \
			   xbase/xtools.dtx

xfrontm.tgz: xfrontm
	tar cvzf xfrontm.tgz xfrontm/xfm-test.tex \
			     xfrontm/xfm-test-cls.dtx \
			     xfrontm/xfm.dtx \
			     xfrontm/xfmgalley.dtx \
			     xfrontm/xfrontm.ins \
			     xfrontm/README-xfrontm.txt


xfrontm-pics.tgz: xfrontm
	tar cvzf xfrontm-pics.tgz xfrontm/*.ps


xhead.tgz: xhead
	tar cvzf xhead.tgz xhead/xhead.dtx \
	                   xhead/xhead.ins \
	                   xhead/tryxhead.tex

install-%:
	LTEXMF=`kpsewhich --var-value=TEXMFHOME`/tex/latex/ltx3     ; \
	cd $*     ; \
	make unpack ; \
	ls *.sty | xargs -I {} cp -v {} $$LTEXMF/xpackages/{}       ; \
	make clean ; \

localinstall:
	LTEXMF=`kpsewhich --var-value=TEXMFHOME`/tex/latex/ltx3     ; \
	echo "\nInstallation directory: \n   $$LTEXMF"              ; \
	mkdir -p $$LTEXMF/xpackages/                                ; \
	echo "\nDeleting any old files: \n"                         ; \
	rm -fv $$LTEXMF/xpackages/*                                 ; \
	echo "\nExtracting and installing: \n"                      ; \
	make install-galley
	make install-xbase
	make install-xcontents
	make install-xfootnote
	make install-xfrontm
	make install-xhead
	make install-xinitials
	make install-xlang
	make install-xor
	make install-xtheorem