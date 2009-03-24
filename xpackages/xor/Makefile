
all:	xbase getl3 unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

unpack:
	latex xotrace.ins

clean:
	mv template-doc.sty template-doc.keep
	rm -f *.sty *.dvi *.aux *.log *.out *.toc *~ *.fpl
	rm -f l3in2e.err
	mv template-doc.keep template-doc.sty

test:
	latex xo-pfloat

testb:
	latex xo-balance # halts

check:	xbase getl3 unpack test clean
