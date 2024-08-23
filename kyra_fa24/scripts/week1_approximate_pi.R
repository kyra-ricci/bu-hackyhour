# Approximate pi
# Simulate from uniform distribution from -0.5 to 0.5

hist(runif(1e4, min=0, max=1))

pi_sim <- function(){
  # Simulate a square
  x <- runif(1e4,-0.5,0.5)
  y <- runif(1e4,-0.5,0.5)
  # Simulate the circle within the square that is centered at 0 with a radius of 0.5
  in_circle <- ifelse(sqrt(x^2 + y^2) <= 0.5, 1, 0)
  
  sum(in_circle/1e4)*4
}

plot(y ~ x, pch=20)
plot(y ~ x, col = c("darkslategrey","turquoise")[in_circle+1], pch=20)

hist(replicate(1000, pi_sim()))
pi <- 3.14159
abline(v=pi, col="red", lwd=3)
