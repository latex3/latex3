
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	cp ../xbase/*.sty .

unpack:
	latex xtheorem.ins

clean:
	rm -f xtheorem.sty 
	rm -f template.sty ldcsetup.sty xparse.sty xtools.sty
	rm -f *.dvi *.aux *.log *.toc *~

test:
	latex xtheorem-test
