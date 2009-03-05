
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xfrontm.ins

clean:
	rm -f xfmgalley-sample.tex xfm-*.cls
	rm -f *.sty *.dvi *.aux *.log *.toc *~

test:
	latex xfm-test

check: xbase unpack test clean
