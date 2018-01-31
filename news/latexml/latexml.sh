#!/bin/bash

mkdir -p html

FILENAME=l3news01

latexml ../$FILENAME | latexmlpost - \
  --xsltparameter=SIMPLIFY_HTML:true \
  --format=html5 \
  --destination=html/$FILENAME.html

