#!/bin/bash

pdflatex supplementary.tex
bibtex supplementary
pdflatex supplementary.tex
bibtex supplementary
pdflatex supplementary.tex
evince supplementary.pdf
