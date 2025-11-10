################################################################################
# MID DOMAIN EFFECT IN 1 DIMENSION
################################################################################


N.spec <- 100
domain.size <- 100

# make matrix full of zeroes
domain <- matrix(0, ncol = N.spec, nrow=domain.size)

# SOLUTION 1 -  every range size is identical ----------------------------------
range.size <- 20
for(i in 1:N.spec)
{
  upper <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower <- upper + range.size - 1
  domain[upper:lower, i] <- 1
}
domain
image(t(domain))

# count species and plot the latitudinal gradient
plot(rowSums(domain), 
     xlab="Latitude",
     ylab="Number of species")

# SOLUTION 2 - range size varies -----------------------------------------------

for(i in 1:N.spec)
{
  range.size <- round(runif(n=1, 1, domain.size))
 
  upper <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower <- upper + range.size - 1
  domain[upper:lower, i] <- 1
}
domain
image(t(domain))

# count species and plot the latitudinal gradient
plot(rowSums(domain), 
     xlab="Latitude",
     ylab="Number of species")


################################################################################
# MID DOMAIN EFFECT IN 2 DIMENSIONS
################################################################################

N.spec <- 1000
domain.size <- 100

# make matrix full of zeroes
domain <- matrix(0, ncol = domain.size, nrow=domain.size)
image(domain)

# SOLUTION 1 - constant range size ---------------------------------------------
range.size <- 20


for(i in 1:N.spec)
{
  upper.row <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower.row <- upper.row + range.size - 1
  
  upper.col <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower.col <- upper.col + range.size - 1
  
  S <- domain[upper.row:lower.row, upper.col:lower.col]
  domain[upper.row:lower.row, upper.col:lower.col] <- S + 1
}
domain
image(t(domain))

# SOLUTION 2 - varying range size ----------------------------------------------

for(i in 1:N.spec)
{
  range.size <- round(runif(n=1, 1, domain.size))
  
  upper.row <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower.row <- upper.row + range.size - 1
  
  upper.col <- sample(x = 1:(domain.size-range.size+1), size = 1)
  lower.col <- upper.col + range.size - 1
  
  S <- domain[upper.row:lower.row, upper.col:lower.col]
  domain[upper.row:lower.row, upper.col:lower.col] <- S + 1
}
domain
image(t(domain))









