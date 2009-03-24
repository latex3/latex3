
all:	xbase.tgz xfrontm.tgz xfrontm-pics.tgz

clean:
	rm -f *.tgz
	rm -f *~

check:
	make check-pkg X=galley
	# make check-pkg X=xbase
	make check-pkg X=xfootnote
	make check-pkg X=xfrontm
	make check-pkg X=xhead
	make check-pkg X=xinitials
	# make check-pkg X=xlang
	# make check-pkg X=xor
	make check-pkg X=xtheorem

check-pkg: $(X)/
	cd $(X) ; make check

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

install-pkg:	$(X)/
	LTEXMF=`kpsewhich --var-value=TEXMFHOME`/tex/latex/ltx3     ; \
	cd $(X)     ; \
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
	make install-pkg X=galley
	make install-pkg X=xbase
	make install-pkg X=xcontents
	make install-pkg X=xfootnote
	make install-pkg X=xfrontm
	make install-pkg X=xhead
	make install-pkg X=xinitials
	make install-pkg X=xlang
	make install-pkg X=xor
	make install-pkg X=xtheorem