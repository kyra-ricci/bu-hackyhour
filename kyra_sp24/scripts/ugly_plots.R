# Load in iris dataset

iris # look at data in console
data <- iris # save iris dataset as new object data

# Practice with objects

a <- 1:10 # try creating a vector of multiple numbers - 1-10
b <- c("orange", "bannana", "strawberry") # create a vector of multiple characters
c <- seq(from = -1, to = 1, l = 100) # create a vector 100 length from -1 to 1

class(data) # check what kind of objects we created. "data" is "data.frame"
class(a) # "a" is "integer"
class(b) # "b" is "character"
class(c) # "c" is "numeric"

# Practice with basic functions

data
petal_length <- data$Petal.Length # Create new vector of just petal length
avg_pl <- mean(petal_length) # average of petal_length is 3.758
sd_pl <- sd(petal_length) # standard deviation is 1.765
var_pl <- var(petal_length) # variance is 3.12

petal_width <- data$Petal.Width # something
cov(petal_length,petal_width) # covariance between variables is 1.296
cor(petal_length,petal_width) # correlation between variables is 0.963

# Practice with plots

# Make the same plot two ways
plot(petal_length ~ petal_width) # y ~ x format
plot(x = petal_width, y=petal_length) # x = and y = format

plot(petal_length ~ petal_width,
     col = c("red","blue","green")[data$Species], pch = 19,
     cex = 1)
abline(h = avg_pl, col = "orange", lwd = 3)
abline(v = mean(petal_width), col = "black", lwd = 3)
abline(a = 0, b = 1, col = "purple", lwd = 3) # a=intercept and b=slope
# pch = type of point on the plot (19 = filled in circle)
# cex = size of point on the plot (1 = default)
# abline = create lines

pairs(data) # creates plots for every combinatinon of variables in the dataset
