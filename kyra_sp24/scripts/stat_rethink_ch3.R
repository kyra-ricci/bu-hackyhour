library(devtools)
install_github("stan-dev/cmdstanr", dependencies = TRUE)
install_github("rmcelreath/rethinking", dependencies = TRUE)
library(rethinking)

# Probability of being positive and of being a vampire (test efficacy)
PrPV <- 0.95
# Probability positive mortal (false positive rate)
PrPM <- 0.01
# Probability of being a vampire (known % of vamps in population)
PrV <- 0.001
# Probability of positive 
PrP <- PrPV * PrV + PrPM*(1-PrV)
# Probability of being a vampire and positive
(PrVP <- PrPV*PrV/PrP) # 0.087

# Globe example from last week
# P = proportion of water, W = water observations, L = land observations, N=no. obs

# define the grid
p_grid <- seq(from = 0, to = 1, length.out = 1000)
# define prioir
prior <- rep(1,1000)
# compute likelihood value at each grid
likelihood <- dbinom(6, size = 9, prob = p_grid) # 6/9 observations are water
# compute posterior
posterior <- likelihood * prior
# standardize posterior
posterior <- posterior/sum(posterior)


# draw 10,000 samples from posterior
samples <- sample(p_grid, prob = posterior, size = 1e4, replace = T)
plot(samples)
dens(samples)

sum(posterior[p_grid <0.5])
sum(samples <0.5)/1e4

# how much posterior probability lies between 0.5 and 0.75
sum(samples > 0.5 & samples < 0.75)/1e4 # ~60%

# 80 percent of our probability is between p=0 and p=0.76
quantile(samples, 0.8)

# find the middle 80% interval

# Percentile intervals from ppt
# use grid approximation
p_grid <- seq(from = 0, to = 1, length.out = 1000)
prior <- rep(1,1000)
likelihood <- dbinom(3, size = 3, prob = p_grid)
posterior <- likelihood*prior
posterior <- posterior/sum(posterior)
samples <- sample(p_grid, size = 1e4, replace = T, prob = posterior)

dens(samples)
PI(samples, prob = 0.5)
HPDI(samples, prob = 0.5)


# compute MAP value
p_grid[which.max(posterior)]
chainmode(samples, adj = 0.01)
mean(samples)
median(samples)

loss <- sapply(p_grid, function(d) sum(posterior*abs(d-p_grid)))
p_grid[which.min(loss)]
plot(loss~p_grid)


# Creating a fake sample/dummy data from our model to test if our model accurately represents the data
dbinom(0:2, size = 2, prob = 0.7) 

rbinom(1, size = 2, prob = 0.7)
rbinom(10, size = 2, prob = 0.7)

dummy <- rbinom(1e5, size = 2, prob =0.7)
table(dummy)/1e5

dummy <- rbinom(1e5, size = 9, prob =0.7)
simplehist(dummy, xlab = "Dummy water count")
table(dummy)/1e5


