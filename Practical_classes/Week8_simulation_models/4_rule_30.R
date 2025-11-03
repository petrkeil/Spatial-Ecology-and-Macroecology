# RULE 30 CELLULAR AUTOMATON 
# Petr Keil, 11/14/2022, keil@fzp.czu.cz


library(raster)


M <- matrix(nrow = 100, ncol = 201)
M[] <- 0
M[1,101] <- 1
M


plot(raster(M))


window <- function(x)
{
  if(identical(x, c(1,1,1))) return(0)
  if(identical(x, c(1,1,0))) return(0)
  if(identical(x, c(1,0,1))) return(0)
  if(identical(x, c(1,0,0))) return(1)
  if(identical(x, c(0,1,1))) return(1)
  if(identical(x, c(0,1,0))) return(1)
  if(identical(x, c(0,0,1))) return(1)
  if(identical(x, c(0,0,0))) return(0)
} 


for(t in 2:nrow(M))
{
  for(i in 2:(ncol(M)-1))
  {
    x <- M[t-1, (i-1):(i+1)]
    M[t,i] <- window(x)
  }  
}


plot(raster(M))