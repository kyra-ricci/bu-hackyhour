# Create dataframe from scratch
sppnames <- c("afarensis", "africanus", "habilis", "boisei", "rudolfensis", "ergaster", "sapiens")
brainvolcc <- c(438, 452, 612, 521, 752, 871,1350)
masskg <- c(37.0, 35.5, 34.5, 41.5, 55.5, 61.0, 53.5)
d <- data.frame(species = sppnames,
                brain = brainvolcc,
                mass = masskg)

# Model
# Average brain volume vi of species i is a linear function of its body mass mi
# vi ~ Normal(mui, sigma)
# mui = alpha + beta1 * mi

m6.1 <- lm(brain ~ mass, data = d)
summary(m6.1)
