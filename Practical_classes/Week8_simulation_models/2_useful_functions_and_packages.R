# SOME USEFUL R STUFF FOR PLAYING WITH SIMPLE CELLULAR AUTOMATA

## LIBRARIES --------------------------------------------------------------------

library(raster)  # for plotting rasters and grids
library(caTools) # for exporting arrays to animated .gif


## USEFUL FUNCTIONS AND OPERATORS FOR CELLULAR AUTOMATA -------------------------

c(data)                  # creates 1-dimensional vector
matrix(data, nrow, ncol) # creates a 2-dimensional array (matrix)
array(data, dim)         # creates an n-dimensional 

identical() # are two objects identical?
ncol()      # number of columns of a matrix
nrow()      # number of rows of a matrix

image(M) # plots matrix M
plot(raster(M)) # converts matrix M to raster, and plots it
write.gif(M, filename = "filename.gif", col="jet", delay=15) # array to .gif

== # is equivalent
=  # asignment operator
<- # asignment operator
&  # logical AND
x %in% y # which elements of y are in x?
which(x) # indices of elements of logical vector x that are true 
  
sample(x, size=N)   # randomly samples N elements from vector x
rbinom(N, 1, 0.5) # flips a coin N-times, with probability 0.5

## INDEXING ---------------------------------------------------------------------
  
x[-1]   # negative subscript; removes element 1
x[]     # empty subscript; return all elements of x
x[x>=5] # logical subscript; returns all elemants >= 5
M[3,1]  # returns element of matrix M at 3rd row and 1st column
M[ ,1]  # returns the entire 1st column of matrix M
A[,,1]  # return the first matrix in a three-dimensional array A

## LOOPS ------------------------------------------------------------------------

for (i in vector) # the vector can be e.g. 1:N, or 2:N, or 2:(N-1)
{
  # do something 
}

while (test expression)
{
  # do something  
}  

## WRITING FUNCTIONS ------------------------------------------------------------

function.name <- function(argument_1, argument_2, ...) 
{
  # some commands here 
  return(result)
}