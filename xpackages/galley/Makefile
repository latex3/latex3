
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	cp ../xbase/*.sty .

unpack:
	latex galley2.ins

clean:
	rm -f *.sty *.sig
	rm -f template.sty ldcsetup.sty xparse.sty xtools.sty
	rm -f *.dvi *.aux *.log *.toc *~

test:
	latex xhj-test
