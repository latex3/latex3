
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	cp ../xbase/*.sty .

unpack:
	latex xfrontm.ins

clean:
	rm -f xfm.sty xfmgalley-sample.tex xfm-*.cls xfmgalley.sty
	rm -f template.sty ldcsetup.sty xparse.sty xtools.sty
	rm -f *.dvi *.aux *.log *.toc *~

test:
	latex xfm-test
