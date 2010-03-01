#!/bin/bash

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
	make 
	make runAll
	cd -
}

#runConvolveBennchmark
#runFastLM
#runFunctionCallback
#runRcppInline

runRInsideExamples