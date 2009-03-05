
all:	getl3 unpack

# a very temporary goal

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

unpack:
	latex xbase.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

docu:
	latex template.dtx
	latex xparse.dtx


test:
	latex template-test
	latex template-test2
	latex tprestrict-test
	latex xparse-test

check:	getl3 unpack test clean

