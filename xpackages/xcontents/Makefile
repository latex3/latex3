
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .
	cd ../galley; latex galley2.ins
	mv ../galley/*.sty .

unpack:
	latex xcontents.ins

check:  all
	pdflatex -draftmode xcontents-test.tex
	pdflatex xcontents-test.tex
	make clean

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *~ *.glo *.hd *.cmds *.idx *.out *.synctex*
	rm -f xcontents.sig
