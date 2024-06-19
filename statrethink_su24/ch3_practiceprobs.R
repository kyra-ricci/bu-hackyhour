#Easy problems

p_grid <- seq(from=0, to=1, length.out=1000)
prior <- rep(1,1000)
likelihood <- dbinom(6, size=9, prob=p_grid)
posterior1 <- likelihood * prior
posterior <- posterior1 / sum(posterior1)
set.seed(100)
samples <- sample(p_grid, prob=posterior, size=1e4, replace=TRUE)

# Plot
library(rethinking)
dens(samples)

# 3E1 posterior prob below 0.2
sum(samples < 0.2) / 1e4 # 4e-04

# 3E2 posterior prob above 0.8
sum(samples > 0.8) / 1e4 # 0.1116

# 3E3 posterior prob between 0.2 and 0.8
sum(samples > 0.2 & samples < 0.8) / 1e4 # 0.888

# 3E4 20% of posterior prob lies below which value of p?
quantile(samples, 0.2) # 0.5185185

# 3E5 20% of posterior prob lies above which value of p?
quantile(samples, 0.8) # 0.7557558

# 3E6 Which values of p contain the narrowest interval equal to 66% of the posterior probability? 
PI(samples, prob=0.66) # p = 0.5025 and p = 0.7697

# 3E7 Which values of p contain 66% of the posterior probability, assuming equal posterior probability both below and above the interval?
HPDI(samples, prob=0.66) # p = 0.5085 and p = 0.7738

# Medium problems

# 3M1 8 water in 15 tosses. Construct posterior distribuiton using grid approximation

p_grid <- seq(from=0, to=1, length.out=1000)
prior <- rep(1,1000)
likelihood <- dbinom(8, size=15, prob=p_grid)
unstd.posterior <- likelihood * prior
posterior <- unstd.posterior / sum(unstd.posterior)

# plot posterior
plot(p_grid, posterior, type="b",
     xlab="probability of water", ylab="posterior probability")

# 3M2
sample <- sample(p_grid, prob=posterior, size=10000, replace=TRUE)
HPDI(sample, prob=0.9) # p=0.329 and p=0.716

# 3M3 Probability of observing 8 in 15 tosses?
dummy_w <- rbinom(1e5, size=15, prob=samples)
simplehist(dummy_w, xlab="dummy water count")

mean(dummy_w==8)# 0.11269

# 3M4 Using posterior dist calculated from new 8/15 data, calculate the probability of observing 6/9 tosses
p_grid <- seq(from=0, to=1, length.out=1000)
prior <- posterior
likelihood <- dbinom(6, size=9, prob=p_grid)
unstd.posterior <- likelihood * prior
new.posterior <- unstd.posterior / sum(unstd.posterior)

samples <- sample(p_grid, prob=new.posterior, size=1e4, replace=TRUE)
dens(samples)

dummy_w <- rbinom(1e5, size=9, prob=samples)
simplehist(dummy_w, xlab="dummy water count")

mean(dummy_w==6) # 0.214

# 3M5 
