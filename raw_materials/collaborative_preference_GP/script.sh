#!/bin/bash

pdflatex nips2012.tex
bibtex nips2012
pdflatex nips2012.tex
bibtex nips2012
pdflatex nips2012.tex
evince nips2012.pdf
