#!/usr/bin/Rscript
#  this should really be /usr/bin/r but you-know-know on a Mac ...

ntests <- sapply( list.files(), function(.) sum( grepl( "^test[.]", readLines( . ) ) ) )
fast <- sapply( list.files(), function(.) any( grepl( "cxxfunction.*signatures", readLines( . ) ) ) )
print(head(subset( data.frame( ntests, fast )[ order(-ntests), ], !fast ),10))
