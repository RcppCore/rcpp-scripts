# 
# run this from the directory that contains Rcpp
#
# Rscript ../scripts/preprocessor.R
#

rcpp_function <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_FUNCTION_%d(__OUT__,__NAME__%s)  \\
__OUT__ RCPP_DECORATE(__NAME__)(%s) ;     \\
extern "C" SEXP __NAME__(%s){          \\
SEXP res = R_NilValue ;                 \\
try{                                    \\
	res = ::Rcpp::wrap( RCPP_DECORATE(__NAME__)(%s) ) ; \\
} catch( std::exception& __ex__ ){      \\
	forward_exception_to_r( __ex__ ) ;  \\
}                                       \\
return res ;                            \\
}                                       \\
__OUT__ RCPP_DECORATE(__NAME__)(%s)', 
	i,
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( sprintf( "___%d", 0:(i-1)), collapse=", "),
	if( i == 0 ) "" else paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ), 
	if( i == 0 ) "" else paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1) ), collapse = ", " ), 
	if( i == 0 ) "" else paste( sprintf( "___%d", 0:(i-1)), collapse=", ")
	)
})


rcpp_function_nodecl <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_FUNCTION_NODECL_%d(__OUT__,__NAME__%s)  \\
extern "C" SEXP __NAME__(%s){          \\
SEXP res = R_NilValue ;                 \\
try{                                    \\
	res = ::Rcpp::wrap( RCPP_DECORATE(__NAME__)(%s) ) ; \\
} catch( std::exception& __ex__ ){      \\
	forward_exception_to_r( __ex__ ) ;  \\
}                                       \\
return res ;                            \\
}                                       \\
__OUT__ RCPP_DECORATE(__NAME__)(%s)', 
	i,
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ), 
	if( i == 0 ) "" else paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1) ), collapse = ", " ), 
	if( i == 0 ) "" else paste( sprintf( "___%d", 0:(i-1)), collapse=", ")
	)
})


res <- c( 
"// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; tab-width: 8 -*-
//
// preprocessor_generated.h: Rcpp R/C++ interface class library -- pre processor help
//
// Copyright (C) 2010 Dirk Eddelbuettel and Romain Francois
//
// This file is part of Rcpp.
//
// Rcpp is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// Rcpp is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Rcpp.  If not, see <http://www.gnu.org/licenses/>.

#ifndef RCPP__PREPROCESSOR_GENERATED_H
#define RCPP__PREPROCESSOR_GENERATED_H

// {{{ RCPP_FUNCTION 
", rcpp_function, "
// }}}

// {{{ RCPP_FUNCTION_NODECL
", rcpp_function_nodecl, 
"
// }}}
#endif
" )

writeLines( res, "Rcpp/inst/include/Rcpp/preprocessor_generated.h" )

