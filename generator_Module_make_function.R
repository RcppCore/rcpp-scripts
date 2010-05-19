
fun <- function( i ){
	
	index <- (1:i)-1
	collapse <- function(x) paste( x, collapse = ", " )

txt <- sprintf( '
template <typename OUT, %s>
CppFunction* make_function( OUT (*fun)(%s) ){
	return new CppFunction%d<OUT,%s>( fun ) ;
}

', 
collapse( sprintf( "typename U%d", index ) ), 
collapse( sprintf( "U%d u%d", index, index ) ), 
i,
collapse( sprintf( "U%d", index ) ) 

)


}

file <- sprintf( 
'// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; tab-width: 8 -*-
//
// Module_generated_make_function.h: Rcpp R/C++ interface class library -- Rcpp modules
//
// Copyright (C) 2010	Dirk Eddelbuettel and Romain Francois
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

#ifndef Rcpp_Module_generated_make_function_h
#define Rcpp_Module_generated_make_function_h

template <typename OUT>
CppFunction* make_function( OUT (*fun)(void) ){
	return new CppFunction0<OUT>( fun ) ;
}

%s

#endif
', paste( sapply( 1:65, fun), collapse = "\n" ) 
)

writeLines( file, "Rcpp/inst/include/Rcpp/module/Module_generated_make_function.h" )



