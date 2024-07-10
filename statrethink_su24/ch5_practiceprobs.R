# Easy -------------------------------------

## 5E1
# 2, 4

## 5E2

# Animal diversity is linearly related to latitude, but only after controlling for plant diversity

# Where 
# Lat = mean latitude
# AD = animal diversity
# PD = plant diversity

# ADi <- a + (bLat * Lat) + (bPD * PD)

## 5E3 

# Neither amount of funding nor size of laboratory by itself id a good predictor of time to PhD degree; but together these variables are both positively associated with time to degree

# Where
# Degree = Time to PhD degree
# Funding = Funding
# Size = Size of lab

# Degree = a + (bFunding * Funding) + (bSize * Size)
# bFunding and bSize should both be positive (???)

## 5E4

# 1, 3, 4, 5

# Medium ------------------------------------------------

library(rethinking)
library(ggplot2)
install.packages("GGally")
library(GGally)
install.packages("dagitty")
library(dagitty)

## 5M1

# Example: 
# Ti = mean Bd in tadpole
# W = amount of Bd present in water
# S = amount of Bd present in soil
# Ti = a + bW * W + bS * S
# Amount of Bd present in water and amount of Bd present in soil should be so highly correlated that they cancel each other out when trying to predict the amount of Bd present in the tadpole

# Test in code
N <- 1e2
W <- rnorm(n=N, mean=0, sd=1) # Amount of Bd in water is normally distributed
Ti <- rnorm(n=N, mean=W, sd=1) # Amount of Bd in tadpole is normally distributed with a mean of W because it is positively correlated with W
S <- rnorm(n=N, mean=W, sd=1) # Amount of Bd in water is normally distributed with a mean of W because it is positively correlated with W
d <- data.frame(W, Ti, S)
ggpairs(d) # All are positively correlated with one another

# Model with Ti and W only to show correlation
m5.1 <- map(
  alist(
    Ti ~ dnorm(mu, sigma),
    mu <- a + bW * W,
    a ~ dnorm(0, 1),
    bW ~ dnorm(0, 1),
    sigma ~ dunif(0,1)
  ),
  data = d
)
precis(m5.1)

# Model adding S
m5.2 <- map(
  alist(
    Ti ~ dnorm(mu, sigma),
    mu <- a + bS*S + bW * W,
    a ~ dnorm(0, 1),
    bS ~ dnorm(0, 1),
    bW ~ dnorm(0, 1),
    sigma ~ dunif(0,1)
  ),
  data = d
)
precis(m5.2)


# From online example
set.seed(42)
N <- 1e2
Elev <- rnorm(n = N, mean = 0, sd = 1) # Standardized elevation
VegHeight <- rnorm(n = 100, mean = -Elev, sd = 1) # Standardized vegetation height
AirTemp <- rnorm(n = N, mean = Elev, sd = 2) # Standardized air temp
d <- data.frame(Elev, VegHeight, AirTemp)
ggpairs(d)

# Model to show association between height and air temp
m5m1.1 <- quap(
  alist(
    VegHeight ~ dnorm(mu, sigma),
    mu <- a + bAT * AirTemp,
    a ~ dnorm(0, 1),
    bAT ~ dnorm(0, 1),
    sigma ~ dunif(0, 2)
  ),
  data = d
)
precis(m5m1.1)

# Model when adding elevation
m5m1.2 <- quap(
  alist(
    VegHeight ~ dnorm(mu, sigma),
    mu <- a + bAT * AirTemp + bEL * Elev,
    a ~ dnorm(0, 1),
    bAT ~ dnorm(0, 1),
    bEL ~ dnorm(0, 1),
    sigma ~ dunif(0, 2)
  ),
  data = d
)
precis(m5m1.2)


## 5M2

# Example: 

## 5M3

# High divorce rate may cause higher marriage rate if people are marrying more than once after divorce - i.e., for every divorce, there is a potential for an additional marriage. 
# When predicting marriage rate, what is the value of knowing number of marriages per person, once we already know the divorce rate?
# ui = marriage rate 
# N = number of marriages per person
# D = divorce rate
# ui = a + bN *N + bD *D

# 5M4

# Hard ---------------------------------------------------

library(rethinking)
# load dataframe
data(foxes)
d <- foxes 
head(d)

# 5H1

# Standardize predictors
d$area.s <- (d$area-mean(d$area))/sd(d$area)
d$groupsize.s <- (d$groupsize-mean(d$groupsize))/sd(d$groupsize)
head(d)

# Model 1: Body weight as a linear function of area
# weight ~ Normal(mu, sigma)
# mu = a + barea * area
# barea ~ Normal(0,1)
# sigma ~ Uniform(0,10)

mh1.1 <- map(
  alist(
    weight ~ dnorm(mu, sigma),
    mu <- a + barea * area.s,
    a ~ dnorm(0, 5),
    barea ~ dnorm(0, 5),
    sigma ~ dunif(0, 5)
  ),
  data = d
)
precis(mh1.1)

# Plot
plot(weight ~ area.s, data=d)
abline(mh1.1)

# barea = slope = 0.03 = no correlation

# Model 2: Body weight as a linear function of group size
# weight ~ Normal(mu, sigma)
# mu = a + bg * groupsize.s
# bg ~ Normal(0,1)
# sigma ~ Uniform(0,10)

mh1.2 <- map(
  alist(
    weight ~ dnorm(mu, sigma),
    mu <- a + bg * groupsize.s,
    a ~ dnorm(0, 5),
    bg ~ dnorm(0, 5),
    sigma ~ dunif(0, 5)
  ),
  data = d
)
precis(mh1.2)

plot(weight ~ groupsize.s, data=d)
abline(mh1.2)

# 5H2
# weight ~ Normal(mu, sigma)
# mu = a + barea * area.s + bg * groupsize.s
# barea ~ Normal(0,1)
# bg ~ Normal(0,1)
# sigma ~ Uniform(0,10)

mh2.1 <- map(
  alist(
    weight ~ dnorm(mu, sigma),
    mu <- a + bg * groupsize.s + barea * area.s,
    a ~ dnorm(0, 5),
    bg ~ dnorm(0, 5),
    barea ~ dnorm(0,5),
    sigma ~ dunif(0, 5)
  ),
  data = d
)
precis(mh2.1)

plot(weight ~ groupsize.s)
