
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

