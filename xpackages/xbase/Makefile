
all:	getl3 unpack

# a very temporary goal

getl3:
	(cd ../../../latex2e/l3in2e ; latex l3.ins )
	cp ../../../latex2e/l3in2e/*.sty .

unpack:
	latex xbase.ins

clean:
	rm -f template.sty ldcsetup.sty xparse.sty xtools.sty
	rm -f *.dvi *.aux *.log *.toc *~

docu:
	latex template.dtx
	latex xparse.dtx


