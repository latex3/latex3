
all:	xbase getl3 unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

unpack:
	latex xhead.ins

clean:
	rm -f *.sty *.sig *.dvi *.aux *.log *.toc *.lot *~
	rm -f l3in2e.err

test:
	latex tryxhead

check: xbase getl3 unpack test clean
