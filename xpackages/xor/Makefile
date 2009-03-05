
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xotrace.ins

clean:
	mv template-doc.sty template-doc.keep
	rm -f *.sty *.dvi *.aux *.log *.out *.toc *~
	rm -f l3in2e.err
	mv template-doc.keep template-doc.sty

test:
	latex xo-pfloat

testb:
	latex xo-balance

check:	xbase unpack test testb clean
