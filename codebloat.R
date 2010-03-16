
#
# to change the maximum number of arguments to 20
# move to the root directory of Rcpp and do : 
# Rscript ../../scripts/codebloat.R 20
#

target <- commandArgs(TRUE)[1]

typenames <- function( n = 1, txt){
	paste( sprintf( "typename T%d", 1:n ), collapse = ", " )
}

arguments <- function( n = 1, txt){
	paste( sprintf( "const T%d& t%d", 1:n, 1:n ), collapse = ", " )	
}

parameters <- function( n = 1, txt ){
	paste( sprintf( "t%d", 1:n ), collapse = ", " )	
}

grow <- function( n = 1, txt ){
	grow__ <- function( n, m){
		if( m > n ){
			"R_NilValue"
		} else{
			sprintf( "grow( t%d, %s )", m, grow__( n , m+1) )	
		}
	}
	grow__( n, 1 ) ;
}

for_each <- function(n = 1, txt ){
	
	rx <- "^.*[{][{](.*)[}][}].*$"
	line <- grep( rx, txt )
	expr <- sub( rx , "\\1", txt[line] )
	res <- sapply( 1:n, function(index){
		out <- gsub( "___I___", index - 1, expr )
		out <- gsub( "___X___", sprintf( "t%d", index ), out )
		out
	} )
	c( txt[ 1:(line-1) ], res, txt[ (line+1) : length(txt) ] )
}

modify <- function(txt, token, n, fun){
	if( any( grepl( token, txt ) ) ){
		gsub( token, fun(n, txt), txt )
	} else {
		txt
	}
}                        

path <- file.path( "src", "Rcpp" )
for( f in list.files(path, full.names = TRUE) ){
#	f <- "src/Rcpp/make_list.h"
	content <- readLines( f )
	if( any( grepl( "code-bloat", content ) ) ){
		first <- grep( "<code-bloat>", content )
		last <- grep( "</code-bloat>", content )
		code.end <- grep( "^[*]/", content[first:last] )[1] - 2
		code <- content[ first + (2:code.end) ]
		
		result <- lapply( 1:target, function(n){
			txt <- code
			txt <- modify( txt, "TYPENAMES" , n, typenames  )
			txt <- modify( txt, "ARGUMENTS" , n, arguments  )
			txt <- modify( txt, "PARAMETERS", n, parameters )
			txt <- modify( txt, "GROW"      , n, grow )
			txt <- modify( txt, "___N___"   , n, function(n,txt){ as.character(n) }  )
			if( any( grepl( "__FOR_EACH__[{][{].*[}][}]", txt ) ) ){
				txt <- for_each( n, txt )	
			}
			txt
		} )
		
		output <- unlist( result )
		
		new.content <- c( 
			content[1:(first+code.end+1)], 
			output, 
			content[last:length(content)] )
		
		cat( new.content, file = f , sep = "\n" )
			
	}
}

