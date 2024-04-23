# 4/16/24 data prep for hacky hour dag

library(dplyr)

orig.data <- read.csv("2024_EcoBlitz_Data.csv")
View(orig.data)

dag.data <- orig.data %>% 
  # create new columns to make text entry into variables
  mutate(inat = ifelse(inat_exp %in% c("Yes"), 1, 0)) %>% 
  mutate(cs = ifelse(cs_exp %in% c("Yes"), 1, 0)) %>% 
  mutate(fut_cont = ifelse(future_contribution %in% c("Yes"), 1, 0)) %>% 
  mutate(change_int = post_part_int - pre_part_int) %>% 
  mutate(change_know = post_knowledge - pre_knowledge) %>% 
  mutate(change_care = post_care - pre_care) %>% 
  # remove extraneous variables, including those that have been converted to binary numeric above
  select(-ad, 
         -something_learned, 
         -most_enjoyed, 
         -anything_else, 
         -kyra_notes, 
         -ad_other,
         -affiliation,
         -identifier,
         -cs_exp,
         -inat_exp,
         -future_contribution) %>% 
  # remove individual with missing value (n=1)
  na.omit
 
View(dag.data)

# save as new csv
write.csv(dag.data, "dag_dataframe")

data <- dag_dataframe

View(data)

# number of simulations
n <- 50
know <- seq(-1, 1, l=50)

# start by setting a wide prior for our alpha
a <- rnorm(n, 0, 1.5)

# set wide prior for our beta
b <- rnorm(n, 0, 2)

# build the bookshelf - empry matrix to fill in with for loop
log_odds <- matrix(ncol = n, nrow = 50)

# simulate prior for each set of priors
for(i in 1:n){
  log_odds[,i] <- a[i] + b[i] * know
} # each column is what you would predict the log odds of continuing to contribute in the future at each value for change in knowledge for all values of a and b; each row is a different change in knowledge

# take the inverse logit to get the probability of presence
p_fut <- plogis(log_odds)

fut_cont <- rbinom(n, 1, prob = p_fut[,1]) # simulating data from the first set of a and b
plot(fut_cont~know)

plot(NULL, xlim = c(-1,1), ylim = c(0,1), xlab = "Change in knowledge", ylab = "Probability of future contribution")

for(i in 1:n){
  lines(x = know, y = p_fut[,i])
}

library(R2jags)

# range of change in knowledge values to estimate the posterior at
x_pred <- seq(-1,1,l=100)

# JAGS needs data as a list
jags_dat <- list(
  N = nrow(data),
  fut_cont = data$fut_cont,
  change_know = data$change_know,
  x_pred = x_pred,
  K = length(x_pred)
)

mod <- 
  'model{
  # likelihood
  for(i in 1:N){
    logit(p[i]) <- a + b * change_know[i]
    fut_cont[i] ~ dbern(p[i])
    # posterior predictors
    y_rep[i] ~ dbern(p[i])
  }
  # priors
  a ~ dnorm(0, 1.5^-2)
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


traceplot(fit) # looking for fuzzy caterpillar

hist(fit$BUGSoutput$sims.list$mu_rep, ylab = "Frequency", xlab  = "Future contribution")
abline(v=mean(data$fut_cont))

