#!/bin/bash

set -e 

function runConvolveBennchmark {
    cd Rcpp/inst/examples/ConvolveBenchmarks
    ./buildAndRun.sh
    cd -
}

function runFastLM {
    cd Rcpp/inst/examples/FastLM
    ./benchmark.r
    cd -
}

function runFunctionCallback {
    cd Rcpp/inst/examples/functionCallback
    ./buildAndRun.sh
    ./newApiExample.r
    cd -
}

function runRcppInline {
    cd Rcpp/inst/examples/RcppInline
    ./external_pointer.r
    ./RcppInlineExample.r
    ./RcppInlineWithLibsExamples.r
    ./RcppSimpleExample.r
    ./RcppSimpleTests.r
    ./RObject.r
    ./UncaughtExceptions.r
    cd -
}

function runRInsideExamples {
    cd ../../rinside/pkg/inst/examples/standard
    make clean
    make
    ./rinside_sample0
    ./rinside_sample1
    ./rinside_sample2
    ./rinside_sample3
    ./rinside_sample4
    ./rinside_sample5
    ./rinside_sample6
    ./rinside_sample7
    ./rinside_sample8
    cd -
}

runConvolveBennchmark
runFastLM
runFunctionCallback
runRcppInline
runRInsideExamples
