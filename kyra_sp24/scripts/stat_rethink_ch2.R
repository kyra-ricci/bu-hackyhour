sample <- c("W", "L", "W", "W", "W", "L", "W", "L", "W") #define sample from tossing the globe where W = water and L = land
W <- sum(sample == "W") # how many times we saw water (W)
L <- sum(sample == "L") # how many times we saw land (L)
p <- c(0, 0.25, 0.5, 0.75, 1) # possible proportions of water on a 4-sided planet
ways <- sapply(p, function(i)
  (i*4)^W * ((1-i)*4)^L) # number of possible ways that you could get your sample
prob <- ways/sum(ways) # probability of each possibility given the sample
cbind(p, ways, prob) # reproduce table in slide 9 of ppt
barplot(prob, names.arg = p, xlab = "proportion of water", ylab = "probability") # recreate bar chart in slide 9 of ppt

sim_globe <- function(p = 0.7, N = 9){ #giving default values to p and N
  sample(c("W","L"), size = N, prob = c(p, 1-p), replace = T)
  # sample = possible observations, size = number of tosses, prob = probability of each possible observation
  }
sim_globe()
replicate(sim_globe(p = 0.5, N = 9), n = 10) # use this process to debug your code - because we set p = 0.5, we should get about 50 W/50 L
sim_globe(p = 1, N = 11) # you can also set to extremes to check the code
sum(sim_globe(p = 0.5, N = 1e4) == "W")/1e4 # can also sample from large replications and check proportion
