
all:	xbase getl3 galley unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

galley:
	(cd ../galley; latex galley2.ins)
	mv ../galley/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

unpack:
	latex xinitials.ins

clean:
	rm -f *.sty *.sig *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

test:
	latex xinitials-test

check: xbase galley getl3 unpack test clean
