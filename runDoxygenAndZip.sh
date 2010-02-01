#!/bin/sh

if [ -x /usr/bin/doxygen ]; then 
    cd pkg/inst/doc
    rm -rf html/ latex/ man/
    cd -
    cd pkg
    cd src && ln -s ../inst/examples . && cd -
    doxygen
    rm src/examples
    cd -

    cd pkg/inst/doc
    zip -9r rcpp-doc-html.zip html/
    zip -9r rcpp-doc-man.zip man
    zip -9r rcpp-doc-latex.zip latex
    if [ -d ~/www/code/rcpp/ ]; then
	mv -v rcpp-doc-*.zip ~/www/code/rcpp/
	rsync --delete -avu html ~/www/code/rcpp/
    fi
    cd -
fi