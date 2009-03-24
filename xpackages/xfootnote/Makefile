
all:	xbase getl3 unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

unpack:
	latex xfootnote.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

test:
	latex xfootnote-test

check: xbase getl3 unpack test clean
