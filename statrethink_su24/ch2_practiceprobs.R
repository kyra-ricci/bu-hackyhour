# 2M1: Grid approximation

# (1) WWW

# define grid of 20
# length.out describes how precise/granular your distribution is going to be
p_grid <- seq(from=0, to=1, length.out=20)

# define prior
prior <- rep(1,20)

# compute likelihood at each value in grid
likelihood <- dbinom(3, size=3, prob=p_grid)

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

# Display posterior distribution
plot(p_grid, posterior, type="b",
     xlab="probability of water", ylab="posterior probability")

# (2) WWWL

# define grid of 20
# use posterior as new prior
p_grid2 <- seq(from=0, to=1, length.out=20)

# define prior
prior2 <- posterior

# compute likelihood at each value in grid
likelihood2 <- dbinom(3, size=4, prob=p_grid2)

# compute product of likelihood and prior
unstd.posterior2 <- likelihood2 * prior2

# standardize the posterior, so it sums to 1
posterior2 <- unstd.posterior2 / sum(unstd.posterior2)

# Display posterior distribution
plot(p_grid2, posterior2, type="b",
     xlab="probability of water", ylab="posterior probability")

# (3) LWWLWWW

# define grid of 20
# use posterior2 as new prior
p_grid3 <- seq(from=0, to=1, length.out=20)

# define prior
prior3 <- posterior2

# compute likelihood at each value in grid
likelihood3 <- dbinom(5, size=7, prob=p_grid3)

# compute product of likelihood and prior
unstd.posterior3 <- likelihood3 * prior3

# standardize the posterior, so it sums to 1
posterior3 <- unstd.posterior3 / sum(unstd.posterior3)

# Display posterior distribution
plot(p_grid3, posterior3, type="b",
     xlab="probability of water", ylab="posterior probability")

# 2M2
# Adjust your prior to account for the fact that you know the earth is at least 50% water (p<0.5 = 0, p>0.5 =1)

# (1) WWW

# define grid
p_grid <- seq(from=0, to=1, length.out=20)

# define prior
prior <- ifelse(p_grid<0.5,0,1)

# compute likelihood at each value in grid
likelihood <- dbinom(3, size=3, prob=p_grid)

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

# Display posterior distribution
plot(p_grid, posterior, type="b",
     xlab="probability of water", ylab="posterior probability")

# (2) WWWL

# define grid
p_grid <- seq(from=0, to=1, length.out=20)

# define prior
prior <- ifelse(p_grid<0.5,0,1)

# compute likelihood at each value in grid
likelihood <- dbinom(3, size=4, prob=p_grid)

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

# Display posterior distribution
plot(p_grid, posterior, type="b",
     xlab="probability of water", ylab="posterior probability")

# (3) LWWLWWW

# define grid
p_grid <- seq(from=0, to=1, length.out=20)

# define prior
prior <- ifelse(p_grid<0.5,0,1)

# compute likelihood at each value in grid
likelihood <- dbinom(5, size=7, prob=p_grid)

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

# Display posterior distribution
plot(p_grid, posterior, type="b",
     xlab="probability of water", ylab="posterior probability")

# 2M3
# Earth is 70% water, Mars is 100% land
# Toss one (you don't know which) and get a land
# What is the posterior probability that the tossed globe is Earth? 
# Pr(Earth|land)

# Bayes theorem
# Pr(p|w) = (Pr(w|p)Pr(p))/Pr(w)
# Applied to this problem:
# Pr(Earth|land) = (Pr(land|Earth)Pr(Earth))/Pr(land)
# Solve for Pr(Earth|land)

# Pr(land|Earth) = 0.3
# Pr(land|Mars) = 1
# Pr(Earth) = 0.5

# Pr(land) = Pr(land|Earth)P(Earth) + P(land|Mars)P(Mars)
# Pr(land) = 
0.3 * 0.5 + 1 * 0.5 # = 0.65

# Pr(Earth|land) =
(0.3 * 0.5)/0.65 # = 0.23

#2M4
