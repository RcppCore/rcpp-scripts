# 
# run this from the directory that contains Rcpp
#
# Rscript ../scripts/preprocessor.R
#

rcpp_function <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_FUNCTION_%d(__OUT__,__NAME__%s)        \\
__OUT__ RCPP_DECORATE(__NAME__)(%s) ;               \\
extern "C" SEXP __NAME__(%s){                       \\
SEXP res = R_NilValue ;                             \\
BEGIN_RCPP                                          \\
res = ::Rcpp::wrap( RCPP_DECORATE(__NAME__)(%s) ) ; \\
END_RCPP                                            \\
return res ;                                        \\
}                                                   \\
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
#define RCPP_FUNCTION_NODECL_%d(__OUT__,__NAME__%s)     \\
extern "C" SEXP __NAME__(%s){                           \\
SEXP res = R_NilValue ;                                 \\
BEGIN_RCPP                                              \\
	res = ::Rcpp::wrap( RCPP_DECORATE(__NAME__)(%s) ) ; \\
END_RCPP                                                \\
return res ;                                            \\
}                                                       \\
__OUT__ RCPP_DECORATE(__NAME__)(%s)', 
	i,
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ),            
	if( i == 0 ) "" else paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1) ), collapse = ", " ), 
	if( i == 0 ) "" else paste( sprintf( "___%d", 0:(i-1)), collapse=", ")
	)
})


rcpp_xp_method <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_XP_METHOD_%d(__NAME__,__CLASS__,__METHOD__%s)   \\
extern "C" SEXP __NAME__( SEXP xp %s ){                      \\
SEXP res = R_NilValue ;                                      \\
BEGIN_RCPP                                                   \\
	::Rcpp::XPtr<__CLASS__> ptr(xp) ;                        \\
	res = ::Rcpp::wrap( ptr->__METHOD__( %s ) ) ;            \\
END_RCPP                                                     \\
return res ;                                                 \\
}
', 
	i, 
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ) ), 
	if( i == 0 ) "" else paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1)), collapse=", ")
)

})

rcpp_xp_method_void <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_XP_METHOD_VOID_%d(__NAME__,__CLASS__,__METHOD__%s)    \\
extern "C" SEXP __NAME__( SEXP xp %s ){                            \\
BEGIN_RCPP                                                         \\
::Rcpp::XPtr<__CLASS__> ptr(xp) ;                                  \\
ptr->__METHOD__( %s ) ;                                            \\
END_RCPP                                                           \\
	return R_NilValue ;                                            \\
}
', 
	i, 
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ) ), 
	if( i == 0 ) "" else paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1)), collapse=", ")
)

})

rcpp_xp_macro <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_XP_MACRO_%d(__NAME__,__CLASS__,__MACRO__%s)    \\
extern "C" SEXP __NAME__( SEXP xp %s ){                     \\
	SEXP res = R_NilValue ;                                 \\
BEGIN_RCPP                                                  \\
		::Rcpp::XPtr<__CLASS__> ptr(xp) ;                   \\
		res = ::Rcpp::wrap( __MACRO__( ptr %s ) ) ;         \\
END_RCPP                                                    \\
	return res ;                                            \\
}
', 
	i, 
	if( i == 0 ) "" else paste( "," , paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ) ), 
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1)), collapse=", ") )
)

})

rcpp_xp_macro_void <- sapply( 0:65, function(i){
	txt <- sprintf( '
#define RCPP_XP_MACRO_VOID_%d(__NAME__,__CLASS__,__MACRO__%s) \\
extern "C" SEXP __NAME__( SEXP xp %s ){                       \\
	try{                                                      \\
		::Rcpp::XPtr<__CLASS__> ptr(xp) ;                     \\
		__MACRO__( ptr %s ) ;                                 \\
	} catch( std::exception& __ex__ ){                        \\
		forward_exception_to_r( __ex__ ) ;	                    \\
	}                                                         \\
	return R_NilValue ;                                       \\
}
', 
	i, 
	if( i == 0 ) "" else paste( ",", paste( sprintf( "___%d", 0:(i-1)), collapse=", ") ),
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "SEXP x%d", 0:(i-1) ), collapse = ", " ) ), 
	if( i == 0 ) "" else paste( ", ", paste( sprintf( "::Rcpp::internal::converter( x%d )", 0:(i-1)), collapse=", ") )
)

})

res <- c( 
"// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; tab-width: 8 -*-
// :tabSize=4:indentSize=4:noTabs=true:folding=explicit:collapseFolds=1:
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
", rcpp_function_nodecl, "
// }}}

// {{{ RCPP_XP_METHOD
", rcpp_xp_method, "
// }}}

// {{{ RCPP_XP_METHOD_VOID
", rcpp_xp_method_void, "
// }}}

// {{{ RCPP_XP_MACRO
", rcpp_xp_macro, "
// }}}

// {{{ RCPP_XP_MACRO_VOID
", rcpp_xp_macro_void, "
// }}}

#endif
" )

writeLines( res, "Rcpp/inst/include/Rcpp/preprocessor_generated.h" )

