# Medium problems --------------------------------------------------------------

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

# Simulation of black card medium problems ------------------------------------
p <- c()
for(i in 1:100){
  b_sides <- c(0,1,2) # three cards, one with 0 black sides, one with 1, one with 2
  card <- sample(b_sides,1e4,replace=T)
  b_up <- rbinom(1e4,1,card/2)
  b_down <- rbinom(1e4,1,ifelse(card==0,0,ifelse(card==1 & b_up==1,0,1)))
  prob <- sum(b_up==1 & b_down==1)/sum(b_up==1)
  p[i] <- prob
  }

hist(p)
abline(v = 2/3, col="red", lwd = 3)

# Hard problems ----------------------------------------------------------------

# 2H1

Pr_Twins_A <- 0.1
Pr_Twins_B <- 0.2
Pr_A <- 0.5
Pr_B <- 0.5

# Pr(Twins) = Pr(Twins|A)Pr(A) + Pr(Twins|B)Pr(B)
Pr_Twins <- Pr_Twins_A*Pr_A + Pr_Twins_B*Pr_B
Pr_Twins # = 0.15

# Pr(A|Twins) = (Pr(Twins|A)*Pr(A))/Pr(Twins)
Pr_A_Twins <- (Pr_Twins_A*Pr_A)/Pr_Twins
Pr_A_Twins # = 0.333 = 1/3

# Pr(B|Twins) = (Pr(Twins|B)*Pr(B))/Pr(Twins)
Pr_B_Twins <- (Pr_Twins_B*Pr_B)/Pr_Twins
Pr_B_Twins # = 0.666 = 2/3

# Update Pr_B and Pr_A to be equal to Pr_A_Twins and Pr_B_Twins, since we know that the first birth was twins. We need to use this information to update the probability that the mother is one or the other species.

Pr_A2 <- Pr_A_Twins
Pr_B2 <- Pr_B_Twins

# Pr(Twins2) = Pr(Twins|A)Pr(A2)+Pr(Twins|B)Pr(B2)
Pr_Twins2 <- Pr_Twins_A*Pr_A2 + Pr_Twins_B*Pr_B2
Pr_Twins2 # = 0.166 = 1/6

# 2H2

Pr_A_Twins # = 1/3

# 2H3

Pr_Twins1_A <- Pr_Twins_A
Pr_Infant1_A <- 1-Pr_Twins_A
Pr_A_Twins1 <- 1/3
Pr_Twins1 <- 0.15
Pr_Twins2 <- 0.167
Pr_Infant2 <- 1-Pr_Twins2
Pr_A2 <- Pr_A_Twins1
Pr_B2 <- 0.667

Pr_Twins1_A # = 0.1
Pr_Infant1_A # = 0.9
Pr_A2 # = 0.333
Pr_B2 # = 0.667
Pr_Twins1 # = 0.15
Pr_Twins2 # = 0.167
Pr_Infant2 # = 0.833
# Pr_Infant2_A2 = ?
# Pr_A_Infant2 = ?

# Pr(Infant2) = 1-(Pr(Twins|A)Pr(A2)+Pr(Twins|B)Pr(B2))

#Pr(A2|Infant2) = (Pr(Infant1|A2)*Pr(A2)/(Pr(Infant1))

Pr_A2_Infant2 <- (Pr_Infant1_A*Pr_A2)/0.9
Pr_A2_Infant2


