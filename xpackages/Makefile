
all:	xbase.tgz xfrontm.tgz xfrontm-pics.tgz

clean:
	rm -f *.tgz
	rm -f *~


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


localinstall:
	LTEXMF=`kpsewhich --var-value=TEXMFHOME`/tex/latex/ltx3     ; \
	echo "\nInstallation directory: \n   $$LTEXMF"              ; \
	mkdir -p $$LTEXMF/xpackages/                                ; \
	echo "\nDeleting any old files: \n"                         ; \
	rm -fv $$LTEXMF/xpackages/*                                 ; \
	echo "\nExtracting and installing: \n"                      ; \
	cd galley/                                                  ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xbase/                                                ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xfootnote/                                            ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xfrontm/                                              ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xhead/                                                ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xinitials/                                            ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xlang/                                                ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xor/                                                  ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
	cd ../xtheorem/                                             ; \
	make unpack                                                 ; \
	ls *.sty | xargs -I {} cp -v ./{} $$LTEXMF/xpackages/{}     ; \
	make clean                                                  ; \
