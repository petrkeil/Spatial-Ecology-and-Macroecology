# SIMPLE RANDOM WALK 
# Petr Keil, 20 November 2023, keil@fzp.czu.cz

steps <- 1000
y <- rep(0, times = steps)

for(i in 2:steps)
{
  y[i] <- y[i-1] + sample(c(-1, 1), size = 1)  
}

plot(y, type = "l")
