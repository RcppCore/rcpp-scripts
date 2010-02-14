#!/bin/sh

cwd=$(pwd)

version=$(r -e'cat(as.character(read.dcf("pkg/DESCRIPTION")[,"Version"]))')
echo "Working on version $version"


if [ -x /usr/bin/doxygen ]; then 
    cd pkg/inst/doc
    rm -rf html/ latex/ man/
    cd ${cwd}
    cd pkg
    cd src && ln -s ../inst/examples . && cd -

    ## see FAQ 17 for doxygen
    ( cat doxyfile ; echo PROJECT_NAME="\"Rcpp Version ${version}\"" ) | doxygen -

    rm src/examples
    cd ${cwd}
    pwd

    cd pkg/inst/doc
    zip -9r rcpp-doc-html.zip html/
    zip -9r rcpp-doc-man.zip man
    zip -9r rcpp-doc-latex.zip latex
    if [ -d ~/www/code/rcpp/ ]; then
	mv -v rcpp-doc-*.zip ~/www/code/rcpp/
	rsync --delete -avu html ~/www/code/rcpp/
    fi
    cd ${cwd}
fi