
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	cp ../xbase/*.sty .

unpack:
	latex xfrontm.ins

clean:
	rm -f xfm.sty xtools.sty xfmgally.sty xfm-*.cls xfmgalley.sty
	rm -f template.sty ldcsetup.sty xparse.sty
	rm -f *.dvi *.aux *.log *.toc *~

