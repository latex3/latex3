
all:	xbase getl3 unpack

xbase:
	(cd ../xbase; latex xbase.ins &> /dev/null);
	mv ../xbase/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins &> /dev/null);
	mv ../../l3in2e/*.sty .

unpack:
	latex galley2.ins &> /dev/null

clean:
	rm -f *.sty *.sig *.dvi *.aux *.log *.toc *~ l3in2e.err

test:
	latex --interaction=batchmode xhj-test &> /dev/null

check:	xbase getl3 unpack test clean
