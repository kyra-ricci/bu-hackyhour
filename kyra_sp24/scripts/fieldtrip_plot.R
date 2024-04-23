data <- read.csv("C:/Users/kyrad/Desktop/hacky_hour/data/fieldtrip_dataset.csv")
View(data)
head(data)

library(ggplot2)

# make sure diff12 is a factor 
data$diff12 <- as.factor(data$diff12)
data$treatment <- as.factor(data$treatment)

# Vector of colors
cols <- c("black", "grey")

ggplot(data = data,
       mapping = aes (x = diff12,
                      y = quiz,
                      color = treatment)) +
  geom_point(color='black', shape=21, size=2, aes(fill=factor(treatment))) + 
  
  scale_fill_manual(values=c("black", "white")) +
  
  # scale_color_manual(values = cols) +
  
  geom_abline(intercept = 0.799, slope = 0.00004,
              color = "black") +
  
  geom_abline(intercept = 0.759, slope = -0.00193,
              color = "black",
              linetype = "dotted") +

  labs(title = "Quiz scores vs. number of days between measurements",
       x = "Days between pretest and posttest",
       y = "Quiz scores at posttest and follow-up (% correct)")
