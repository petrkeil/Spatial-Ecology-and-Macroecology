# SIMPLE RANDOM WALK 
# Petr Keil, 20 November 2023, keil@fzp.czu.cz

steps <- 1000
y <- rep(0, times = steps)

for(i in 2:steps)
{
  y[i] <- y[i-1] + sample(c(-1, 1), size = 1)  
}

plot(y, type = "l")


# ------------------------------------------------------------------------------
# RANDOM WALK IN 2D

M <- matrix(0, nrow = 200, ncol = 200)

steps <- 10000

x <- y <- 100

for(i in 1:steps)
{
  drctn <- sample(c("up","down","left","right"), 1)
  if(drctn =="up") y <- y + 1
  if(drctn =="down") y <- y - 1
  if(drctn =="left") x <- x - 1
  if(drctn =="right") x <- x + 1
  if (x == 1 | x == ncol(M)) {break}
  if (y == 1 | y == nrow(M)) {break}
  M[x, y] <- M[x, y] + 1
}

image(M)
  