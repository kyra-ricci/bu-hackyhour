set.seed(120414)

weight <- rnorm(20, 0, 10)
hist(weight)

# If we calclulate the mean and sd, we find that it is not the same as the known values that we created from the sample
mean(weight) # calculated mean is -1.7 although the set mean is 0
sd(weight) # calculated SD is 13.6 although the set sd is 10

# Model the frequentist assumption of the sampling distribution
set.seed(1)
mu <- s <- med <- c() # create empty vectors called mu, s, and med
# we will define these empty vectors in the following for loop:
for (i in 1:1e4){
  weight <- rnorm(20,0,10)
  mu[i] <- mean(weight)
  s[i] <- sd(weight)
  med[i] <- median(weight)
}

# plot the sampling distributions of the mean and variance
hist(mu) # the sd is the standard error of the sampling distribution mean
sd(mu)
sd(weight)/sqrt(length(weight))

sd(med)

# Bootstrapping assumes that the sample adequately represents the true population, and uses the sample to create a new estimated population.
# Next, you resample from the estimated population. This gives you a new bootstrapped sampling distribution instead of the imaginary sampling distribution assumed by the frequentist statistical tests alone

# ---- Mean Bootstrapping ----

set.seed(1)

length <- rnorm(50, 0, 5)
hist(length)

mu_length <- c()
# Sampling from a population created by our original sample (aka creating the bootstrapped dataset)
for(i in 1:1e4){
  samps <- sample(length, size = length(length),
                  replace = T)
  mu_length[i] <- mean(samps)
}

# plot the sampling dsitribution of mu for length
hist(mu_length)
# 95% confidence interval
abline(v = quantile(mu_length, c(0.025, 0.975)), col = "red", lwd = 3)
mean.test <- t.test(length)
mean.test # CI using original sample
quantile(mu_length, c(0.025, 0.975)) # CI using bootstrapping
# they are just about the same in this case, but if the distribution was non-normal, then the bootstrapping would get it right while the regular t-test would get it wrong


# ---- 2-sample t-test Bootstrapping ----

set.seed(1)

weight_a <- rnorm(30, 1, 5) # weight of population a
weight_b <- rnorm(50, 3, 5) # weight of population b

t_weight <- t.test(weight_a, weight_b) # regular t-test
t_weight

weight_diff <- c()
# bootstrapping by taking repeated samples from the simulated population
for(i in 1:1e4){
  samps_a <- sample(weight_a, length(weight_a),
                    replace = T)
  samps_b <- sample(weight_b, length(weight_b),
                    replace = T)
  weight_diff[i] <- mean(samps_a) - mean(samps_b)
}

hist(weight_diff)
abline(v = quantile(weight_diff, c(0.025, 0.975)),
       col = "red", lwd = 3)
t_weight$conf.int # regular t-test confidence interval
quantile(weight_diff, c(0.025, 0.975)) # confidence interval from bootstrapped data
# in this case, they are pretty close / nearly the same

# ---- Empirical / Case Resampling Bootstrapping ----

# Used to estimate regression parameters

n <- 100 # number of individuals
a <- -0.5 # intercept
b <- 0.5 # slope
x <- rnorm(n)
y <- a + x*b + rnorm(n)

lm(y~x) # regular regression

alpha <- beta <- c()
for(i in 1:1e4){
  samps <- sample(1:n, size = n, 
                  replace = T)
  mod <- lm(y[samps] ~ x[samps])
  alpha[i] <- as.numeric(mod$coefficients[1])
  beta[i] <- as.numeric(mod$coefficients[2])
}

hist(alpha)
abline(v = quantile(alpha, c(0.025, 0.975)),
       col = "red", lwd = 3)

hist(beta)
abline(v = quantile(beta, c(0.025, 0.975)),
       col = "red", lwd = 3)

# ---- Residual Bootstrapping ----

# This will take the residuals of the original model and assign them to random y values to get new y values (y + random residual)

mod_x <- lm(y~x) # for a given value x, this model will predict y
plot(y~x)
abline(a = mod$coefficients[1], b = mod$coefficients[2],
       col = "red", lwd = 3) 

# pull out the predicted values and the residuals in order to do the residual bootstrap
y_hat <- as.numeric(mod_x$fitted.values)
errors <- as.numeric(mod$residuals)

alpha_r <- beta_r <- c()
for(i in 1:1e4){
  samps <- sample(errors, size = n,
                  replace = T)
  y_rep <- y_hat + samps
  mod <- lm(y_rep ~ x)
  alpha_r[i] <- as.numeric(mod$coefficients[1])
  beta_r[i] <- as.numeric(mod$coefficients[2])
}

hist(alpha_r)
abline(v = quantile(alpha_r, c(0.025, 0.975)),
       col = "red", lwd = 3)
hist(beta_r)       
abline(v = quantile(beta_r, c(0.025, 0.975)),
       col = "red", lwd = 3)     
# compare se from model to the bootsreap estimates
summary(mod)
sd(alpha_r)
sd(beta_r)

# ---- WILD Bootstrapping ----

# WILD bootstrapping will add random error which will help to break up any major heteroschedasticity and nonindependent standard errors

# start using the same basic components from residual bootstrapping

alpha_w <- beta_w <- c()
for(i in 1:1e4){
  samps <- sample(errors, size = n,
                  replace = T)
  fudge <- rnorm(n, 0, 1) # this is the randomness factor - doesn't have to come from a normal distribution, will have to look this up if we want to use irl
  y_rep <- y_hat + samps*fudge # multiply by fudge factor to add randomness
  mod <- lm(y_rep ~ x)
  alpha_w[i] <- as.numeric(mod$coefficients[1])
  beta_w[i] <- as.numeric(mod$coefficients[2])
}

hist(alpha_w)
abline(v = quantile(alpha_w, c(0.025, 0.975)),
       col = "red", lwd = 3)
hist(beta_w)       
abline(v = quantile(beta_w, c(0.025, 0.975)),
       col = "red", lwd = 3)
summary(mod_x)
sd(alpha_w)

