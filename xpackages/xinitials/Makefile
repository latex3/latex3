
all:	xbase galley unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

galley:
	(cd ../galley; latex galley2.ins)
	mv ../galley/*.sty .

unpack:
	latex xinitials.ins

clean:
	rm -f *.sty *.sig *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

test:
	latex xinitials-test

check: xbase galley unpack test clean
