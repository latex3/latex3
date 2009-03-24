
all:	xbase xor getl3 unpack

xbase:
	(cd ../xbase; latex xbase.ins)
	mv ../xbase/*.sty .

getl3:
	(cd ../../l3in2e ; latex l3.ins )
	mv ../../l3in2e/*.sty .

xor:
	(cd ../xor; latex xo.ins)
	mv ../xor/xmarks.sty       .
	mv ../xor/xo-alloc.sty     .
	mv ../xor/xo-capt.sty      .
	mv ../xor/xo-final.sty     .
	mv ../xor/xo-float.sty     .
	mv ../xor/xo-grid.sty      .
	mv ../xor/xo-here.sty      .
	mv ../xor/xo-new.sty       .
	mv ../xor/xo-or.sty        .
	mv ../xor/xo-footnote.sty  .
	mv ../xor/xo-page.sty      .
	mv ../xor/xo-place.sty     .
	mv ../xor/xo-trace.sty     .
	mv ../xor/xo-pagestyle.sty .
	mv ../xor/xoutput.sty      .
	mv ../xor/l3stuff.sty      .

unpack:
	latex xlang.ins

clean:
	rm -f *.sty *.dvi *.aux *.log *.toc *.idx *~
	rm -f german.xld l3in2e.err

test:
	latex xlang-test

check: xbase getl3 xor unpack test clean
