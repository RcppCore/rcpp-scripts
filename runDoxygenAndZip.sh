#!/bin/sh

set -e 

if [ ! -d Rcpp ]; then
    echo "Not above Rcpp/"
    exit -1
fi

cwd=$(pwd)

version=$(r -e'cat(as.character(read.dcf("Rcpp/DESCRIPTION")[,"Version"]))')
echo "Working on version $version"


if [ -x /usr/bin/doxygen ]; then 
    cd Rcpp/inst/doc
    rm -rf html/ latex/ man/
    cd ${cwd}
    cd Rcpp
    cd src && ln -s ../inst/examples . && ln -s ../inst/include . && cd -

    ## see FAQ 17 for doxygen
    ( cat doxyfile ; echo PROJECT_NAME="\"Rcpp Version ${version}\"" ) | doxygen -

    rm src/examples src/include
    cd ${cwd}
    pwd

    cd Rcpp/inst/doc
    zip -9r rcpp-doc-html.zip html/
    zip -9r rcpp-doc-man.zip man
    zip -9r rcpp-doc-latex.zip latex
    if [ -d ~/www/code/rcpp/ ]; then
	mv -v rcpp-doc-*.zip ~/www/code/rcpp/
	rsync --delete -avu html ~/www/code/rcpp/
    fi
    cd ${cwd}

    cd Rcpp/inst/doc/latex
    pdflatex refman
    pdflatex refman
    if [ -d ~/www/code/rcpp/ ]; then
	cp -vax refman.pdf ~/www/code/rcpp/Rcpp_refman.pdf
    fi
    cd ${cwd}

    if [ -d ~/www/code/rcpp/ ]; then
	cp -vax Rcpp/inst/doc/Rcpp-*.pdf ~/www/code/rcpp
    fi
    cd ${cwd}

fi