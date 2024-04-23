library(R2jags)
library(readxl)
library(tidyverse)


# Load and prep data -----------
df <- read_xlsx("data/liz_data_hacky_hours.xlsx")

# clean data
liz <- df %>%
  mutate(water_vel = as.numeric(water_vel)) %>% 
  drop_na(water_vel) %>% 
  filter(Sex !="juvie") %>% 
  mutate(presence = ifelse(treatment == "control", 0,1),
         sex = as.integer(factor(Sex)),
         flow = water_vel / max(water_vel)) %>% 
  select(presence, flow, sex)

# range of flow rates to estimate the posterior at
x_pred <- seq(0,1,l=100)

# JAGS needs data as a list
jags_dat <- list(
  N = nrow(liz),
  presence = liz$presence,
  flow = liz$flow,
  sex = liz$sex,
  x_pred = x_pred,
  K = length(x_pred)
)

mod <- 
 'model{
  # likelihood
  for(i in 1:N){
    logit(p[i]) <- a + b * flow[i]
    presence[i] ~ dbern(p[i])
    # posterior predictors
    y_rep[i] ~ dbern(p[i])
  }
  # priors
  a ~ dnorm(0, 1.25^-2)
  b ~ dnorm(0, 2^-2)
  # posterior stats
  mu_rep <- mean(y_rep)
  sd_rep <- sd(y_rep)
}'

fit <- jags(
  data = jags_dat,
  parameters.to.save = c("a", "b", "mu_rep", "sd_rep"),
  model.file = textConnection(mod)
)
fit

traceplot(fit) # looking for fuzzy caterpillar

# didn't finish plots for this piece

# Prior specification for Flow-Only model -------

# number of simulations
n <- 50

# relative flow rates to simulate over
# we have scaled the flow values to be between 0-1
flow <- seq(0,1, l=50)

# start by setting a wide prior for our alpha
a <- rnorm(n, 0, 1.25)

# set wide prior for our beta
b <- rnorm(n, 0, 2)

# build the bookshelf - empry matrix to fill in with for loop
log_odds <- matrix(ncol = n, nrow = 50) # nrow = 50 because l=50 in the specification of flow object

# simulate prior for each set of priors
for(i in 1:n){
  log_odds[,i] <- a[i] + b[i] * flow
} # each column is what you would predict the log offs of seeing a lizard at each flow rate for all values of a and b; each row is a different flow rate

# take the inverse logit to get the probability of presence
p_liz <- plogis(log_odds)

# simulate the prior predictive and plot the first simulation
obs_liz <- rbinom(n, 1, prob = p_liz[,1]) # simulating data from the first set of a and b
plot(obs_liz~flow)

plot(NULL, xlim = c(0,1), ylim = c(0,1), xlab = "Flow", ylab = "Prob Lizard")
for(i in 1:n) lines
