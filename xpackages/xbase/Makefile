
DTX = template.dtx xparse.dtx
PDF = xparse.pdf template.pdf

all:	getl3 unpack

# a very temporary goal

getl3:
	(cd ../../l3in2e ; latex l3.ins ; tex l3doc.dtx)
	cp ../../l3in2e/l3vers.dtx .
	mv ../../l3in2e/*.sty .
	mv ../../l3in2e/l3doc.cls .
	mv ../../l3in2e/l3doc.ist .

unpack:
	latex xbase.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~
	rm -f l3in2e.err

docu:  $(PDF)
	make clean



test:
	latex template-test
	latex template-test2
	latex tprestrict-test
	latex xparse-test

check:	getl3 unpack test clean

%.pdf: all %.dtx
	pdflatex -draftmode $*.dtx
	makeindex -s l3doc.ist -o $*.ind $*.idx
	pdflatex -draftmode $*.dtx
	pdflatex $*.dtx

