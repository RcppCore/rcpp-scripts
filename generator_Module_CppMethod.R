

fun <- function( i ){

	index <- (1:i)-1
	collapse <- function(x) paste( x, collapse = ", " )
	
	typenames <- collapse( sprintf( "typename U%d", index ) )
	u <- collapse( sprintf( "U%d u%d", index, index ) )
    as <- collapse( sprintf( "Rcpp::as< typename Rcpp::traits::remove_const_and_reference< U%d >::type >( args[%d] )", index, index ) )  
    U <- collapse( sprintf( "U%d", index ) )
       
txt <- sprintf( '

	template < typename Class, typename OUT, %s > class CppMethod%d : public CppMethod<Class> {
	public:
		typedef OUT (Class::*Method)(%s) ;
		typedef CppMethod<Class> method_class ;
		
		CppMethod%d(Method m) : method_class(), met(m) {} 
		SEXP operator()( Class* object, SEXP* args){
			return Rcpp::wrap( (object->*met)( %s ) ) ;
		}
		inline int nargs(){ return %d ; }
		inline bool is_void(){ return false ; }
		const char* signature(const char* name ){ return Rcpp::signature<OUT,%s>(name) ; }
	private:
		Method met ;
	} ;
	
	template < typename Class, %s > class CppMethod%d<Class,void,%s> : public CppMethod<Class> {
	public:
		typedef void (Class::*Method)(%s) ;
		typedef CppMethod<Class> method_class ;
		
		CppMethod%d( Method m) : method_class(), met(m){} 
		SEXP operator()( Class* object, SEXP* args){
			(object->*met)( %s ) ;
			return R_NilValue ;
		}
		inline int nargs(){ return %d ; }
		inline bool is_void(){ return true ; }
		const char* signature(const char* name ){ return Rcpp::signature<void_type,%s>(name) ; }
	private:
		Method met ;
	} ;



	template < typename Class, typename OUT, %s > class const_CppMethod%d : public CppMethod<Class> {
	public:
		typedef OUT (Class::*Method)(%s) const ;
		typedef CppMethod<Class> method_class ;
		
		const_CppMethod%d(Method m) : method_class(), met(m){} 
		SEXP operator()( Class* object, SEXP* args){
			return Rcpp::wrap( (object->*met)( %s ) ) ;
		}
		inline int nargs(){ return %d ; }
		inline bool is_void(){ return false ; }
		const char* signature(const char* name ){ return Rcpp::signature<OUT,%s>(name) ; }
		
	private:
		Method met ;
	} ;
	
	template < typename Class, %s > class const_CppMethod%d<Class,void,%s> : public CppMethod<Class> {
	public:
		typedef void (Class::*Method)(%s) const ;
		typedef CppMethod<Class> method_class ;
		
		const_CppMethod%d( Method m) : method_class(), met(m) {} 
		SEXP operator()( Class* object, SEXP* args){
			(object->*met)( %s ) ;
			return R_NilValue ;
		}
		inline int nargs(){ return %d ; }
		inline bool is_void(){ return true ; }
		const char* signature(const char* name ){ return Rcpp::signature<void_type,%s>(name) ; }
		
	private:
		Method met ;
	} ;
	
', 
typenames,  # typename U0, ...
i,           
u,          # U0 u0, ...
i, 
as,         # Rcpp::as<U0>( args[0] ) , ...
i, 
U,

typenames,  # typename U0, ...
i, 
U, 			# U0, ...
u,          # U0 u0, ...
i,
as, 
i, 
U,


typenames,  # typename U0, ...
i,           
u,          # U0 u0, ...
i, 
as,         # Rcpp::as<U0>( args[0] ) , ...
i, 
U, 

typenames,  # typename U0, ...
i, 
U, 			 # U0, ...
u,          # U0 u0, ...
i, 
as, 
i,
U 


)   

}

file <- sprintf( 
'// -*- mode: C++; c-indent-level: 4; c-basic-offset: 4; tab-width: 8 -*-
//
// Module_generated_CppMethod.h: Rcpp R/C++ interface class library -- Rcpp modules
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

#ifndef Rcpp_Module_generated_CppMethod_h
#define Rcpp_Module_generated_CppMethod_h

	template <typename Class, typename OUT> class CppMethod0 : public CppMethod<Class> {
	public:
		typedef OUT (Class::*Method)(void) ;
		typedef CppMethod<Class> method_class ;
		CppMethod0( Method m) : method_class(), met(m){} 
		SEXP operator()( Class* object, SEXP*){
			return Rcpp::wrap( (object->*met)( ) ) ;
		}
		inline int nargs(){ return 0 ; }
		inline bool is_void(){ return false ; }
		const char* signature(const char* name){ return Rcpp::signature<OUT>(name) ; }
		
	private:
		Method met ;
	} ;
	
	template <typename Class> class CppMethod0<Class,void> : public CppMethod<Class> {
	public:
		typedef void (Class::*Method)(void) ;
		typedef CppMethod<Class> method_class ;
		CppMethod0( Method m) : method_class(), met(m){} 
		SEXP operator()( Class* object, SEXP* ){
			(object->*met)( ) ;
			return R_NilValue ;
		}
		inline int nargs(){ return 0 ; }
		inline bool is_void(){ return true ; }
		const char* signature(const char* name){ return Rcpp::signature<void_type>(name) ; }
		
	private:
		Method met ;
	} ;

	template <typename Class, typename OUT> class const_CppMethod0 : public CppMethod<Class> {
	public:
		typedef OUT (Class::*Method)(void) const ;
		typedef CppMethod<Class> method_class ;
		const_CppMethod0( Method m) : method_class(), met(m){} 
		SEXP operator()( Class* object, SEXP* ){
			return Rcpp::wrap( (object->*met)( ) ) ;
		}
		inline int nargs(){ return 0 ; }
		inline bool is_void(){ return false ; }
		const char* signature(const char* name){ return Rcpp::signature<OUT>(name) ; }
		
	private:
		Method met ;
	} ;
	
	template <typename Class> class const_CppMethod0<Class,void> : public CppMethod<Class> {
	public:
		typedef void (Class::*Method)(void) const ;
		typedef CppMethod<Class> method_class ;
		const_CppMethod0( Method m) : method_class(), met(m) {} 
		SEXP operator()( Class* object, SEXP* ){
			(object->*met)( ) ;
			return R_NilValue ;
		}
		inline int nargs(){ return 0 ; }
		inline bool is_void(){ return true ; }
		const char* signature(const char* name){ return Rcpp::signature<void_type>(name) ; }
		
	private:
		Method met ;
	} ;

%s

#endif
', paste( sapply( 1:65 , fun), collapse = "\n" ) 
)

writeLines( file, "Rcpp/inst/include/Rcpp/module/Module_generated_CppMethod.h" )





