
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
	latex xfrontm.ins

clean:
	rm -f xfmgalley-sample.tex xfm-*.cls
	rm -f *.sty *.dvi *.aux *.log *.toc *~

test:
	latex "\def\userinput{1}\input{xfm-test.tex}"
	latex "\def\userinput{2}\input{xfm-test.tex}"
	# latex "\def\userinput{3}\input{xfm-test.tex}" ## halts
	latex "\def\userinput{4}\input{xfm-test.tex}"
	latex "\def\userinput{5}\input{xfm-test.tex}"

check: xbase xor getl3 unpack test clean
