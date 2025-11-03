# GAME OF LIFE 
# Petr Keil, 11/14/2022, keil@fzp.czu.cz


library(raster)
library(caTools)


side <- 50
steps <- 30
M <- array(0, c(side, side, steps))


M[,,1] <- rbinom(side^2, 1, 0.4)
plot(raster(M[,,1]))


window <- function(x)
{
  is.alive <- x[2,2] == 1
  is.dead  <- x[2,2] == 0
  x[2,2] <- 0
  
  # the rules of the game of life
  if(is.alive & sum(x)<2) return(0)
  if(is.alive & sum(x)==2)return(1)
  if(is.alive & sum(x)==3)return(1)
  if(is.alive & sum(x)>3) return(0)
  if(is.dead & sum(x)==3) return(1)
  else(return(0))
}


x <- matrix(c(0,0,1,0,1,0,0,0,0), 3, 3)
x
window(x)


for(t in 2:steps)
{
  for(i in 2:(side-1))
  {
    for(j in 2:(side-1))
    {
      x <- M[(i-1):(i+1), (j-1):(j+1), t-1]
      M[i, j, t] <- window(x)
    }
  }  
}


write.gif(M, filename = "conway.gif", col="jet", delay=15)