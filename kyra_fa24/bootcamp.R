# General pattern of a vector
a <- c()

# Add values to a
a <- c(0,1,1,2,3,5,8,13)
class(a)
?class
?c

# Make a character vector
flowers <- c("sunflower","rose","orchid","tulip")

# Matrix
max <- matrix(1:9, nrow = 3, ncol = 3)
testmat <- matrix(1:100, nrow=2, ncol=50)
testmat
table(max)

test <- matrix(1:100, nrow=50, ncol=2, byrow=T)
test

colnames(max) <- c("A","B","C")
rownames(max) <- c("a", "b", "c")
max

# Lists
stuff <- list(1, "beetle", TRUE, 1+4i)
str(stuff)

# Dataset: Iris
dat <- iris
head(dat) # Default is 6 rows
head(dat, n=10)

# Bracket notation
dat[1:6, ]
tail(dat)
str(dat)
dim(dat)
