
fun <- function( i ){
	
	index <- (1:i)-1
	collapse <- function(x) paste( x, collapse = ", " )
	
txt <- sprintf( '
template <typename OUT, %s>
class CppFunction%d : public CppFunction {
	public:

		CppFunction%d(OUT (*fun)(%s) ) : CppFunction(), ptr_fun(fun){}
		
		SEXP operator()(SEXP* args) throw(std::exception){
			return Rcpp::wrap( ptr_fun( %s ) ) ;
		}
		
		inline int nargs(){ return %d; }
		
	private:
		OUT (*ptr_fun)(%s) ;	
} ;

template <%s>
class CppFunction%d<void,%s> : public CppFunction {
	public:
		CppFunction%d(void (*fun)(%s) ) : CppFunction(), ptr_fun(fun){}
		
		SEXP operator()(SEXP* args) throw(std::exception) {
			ptr_fun( %s ) ;
			return R_NilValue ;
		}
		
		inline int nargs(){ return %d; }
		inline bool is_void(){ return true; }
		
	private:
		void (*ptr_fun)(%s) ;	
} ;

',
collapse( sprintf( "typename U%d", index ) ), 
i,
i, 
collapse( sprintf( "U%d", index ) ),
collapse( sprintf( "Rcpp::as< typename Rcpp::traits::remove_const_and_reference< U%d >::type >( args[%d] )", index, index ) ),
i, 
collapse( sprintf( "U%d", index ) ), 
paste( sprintf( "typename U%d", index ), collapse = ", " ), 
i, 
collapse( sprintf( "U%d", index ) ), 
i, 
collapse( sprintf( "U%d", index ) ), 
collapse( sprintf( "Rcpp::as< typename Rcpp::traits::remove_const_and_reference< U%d>::type >( args[%d] )", index, index ) ),
i, 
collapse( sprintf( "U%d", index ) )
)
	
}

file <- sprintf( 
'// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; tab-width: 8 -*-
//
// Module_generated_function.h: Rcpp R/C++ interface class library -- Rcpp modules
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

#ifndef Rcpp_Module_generated_CppFunction_h
#define Rcpp_Module_generated_CppFunction_h
    
template <typename OUT>
class CppFunction0 : public CppFunction {
	public:
		CppFunction0(OUT (*fun)(void) ) : CppFunction(), ptr_fun(fun){}
		SEXP operator()(SEXP* args) throw(std::range_error) {
			return Rcpp::wrap( ptr_fun() ) ;
		}
		
		inline int nargs(){ return 0; }
		
	private:
		OUT (*ptr_fun)(void) ;	                    
} ;


template <>
class CppFunction0<void> : public CppFunction {
	public:
		CppFunction0(void (*fun)(void) ) : CppFunction(), ptr_fun(fun){} ;
		
		SEXP operator()(SEXP* args) throw(std::exception) {
			ptr_fun() ;
			return R_NilValue ;
		}
		
		inline int nargs(){ return 0; }
		inline bool is_void(){ return true; }
		
	private:
		void (*ptr_fun)(void) ;	
} ;

%s

#endif
', paste( sapply( 1:65, fun), collapse = "\n" ) 
)

writeLines( file, "Rcpp/inst/include/Rcpp/module/Module_generated_CppFunction.h" )



