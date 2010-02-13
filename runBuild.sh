#!/bin/sh

version=$(r -e'cat(as.character(read.dcf("pkg/DESCRIPTION")[,"Version"]))')
echo "Working on version $version"

export RCPP_CXX0X="yes"
R CMD build --force pkg

test -d tarballs   && cp -vax Rcpp_${version}.tar.gz tarballs/rcpp_${version}.orig.tar.gz
test -d build-area && cp -vax Rcpp_${version}.tar.gz build-area/rcpp_${version}.orig.tar.gz

