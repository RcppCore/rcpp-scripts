#!/bin/sh

set -e 

if [ ! -d Rcpp ]; then
    echo "Not above Rcpp/"
    exit -1
fi

version=$(r -e'cat(as.character(read.dcf("Rcpp/DESCRIPTION")[,"Version"]))')
echo "Working on version $version"

#export RCPP_CXX0X="yes"
export RCPP_CXX0X="no"
R CMD build --force Rcpp

test -d tarballs   && cp -vax Rcpp_${version}.tar.gz tarballs/rcpp_${version}.orig.tar.gz
test -d build-area && cp -vax Rcpp_${version}.tar.gz build-area/rcpp_${version}.orig.tar.gz
test -d ~/www/code/rcpp && cp -vax Rcpp_${version}.tar.gz ~/www/code/rcpp

