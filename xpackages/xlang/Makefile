
all:	xbase unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

unpack:
	latex xlang.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *.idx *~
	rm -f german.xld

test:
	latex xlang-test

check: xbase unpack test clean