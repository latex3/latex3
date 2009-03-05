
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xcontents.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~
	rm -f xcontents.sig
	rm -f l3in2e.err
