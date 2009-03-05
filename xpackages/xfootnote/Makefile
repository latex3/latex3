
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xfootnote.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

test:
	latex xfootnote-test

check: xbase unpack test clean