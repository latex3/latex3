
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xhead.ins

clean:
	rm -f *.sty *.sig *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

test:
	latex tryxhead

check: xbase unpack test clean
