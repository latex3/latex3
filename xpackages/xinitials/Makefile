
all:	xbase galley unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	cp ../xbase/*.sty .

galley:
	(cd ../galley; latex galley2.ins)
	cp ../galley/*.sty .

unpack:
	latex xinitials.ins

clean:
	rm -f *.sty *.sig
	rm -f template.sty ldcsetup.sty xparse.sty xtools.sty
	rm -f *.dvi *.aux *.log *.toc *~

test:
	latex xinitials-test
