dat_url <- "https://github.com/BinghamtonBioHackyHours/R-Crash-Course-2024/blob/main/data/observations-465928.csv?raw=true"
dat <- read.csv(dat_url)
head(dat)

# Pull out latitude and longitude
df <- dat[ , c(2, 7:9)]
str(df)

# Look at unique species in the new dataset
unique(df$scientific_name)

# Filter only diplacus species
dip_dat <- df[grepl(pattern = "Diplacus", df$scientific_name), ]
str(dip_dat)
unique(dip_dat$scientific_name)

# Observations for latitude
a <- c(1,1,3,2)
duplicated(a)
duplicated(dip_dat$latitude)
sum(duplicated(dip_dat$latitude))
sum(duplicated(dip_dat[ , c("latitude", "longitude")])) # there are 17 duplicates

# create new dataframe that removes duplicates
dip_df <- dip_dat[!duplicated(dip_dat[,c("latitude","longitude")]),]

obs_on <- as.Date(dip_df$observed_on)
class(obs_on)
julian <- format(obs_on, "%j")
class(julian) # it's a character vector
julian <- as.numeric(julian)
class(julian) # it's a numeric vector now

# replace observed_on column with julian
dip_df$observed_on <- julian
str(dip_df)
dip_df$scientific_name <- as.factor(dip_df$scientific_name)
str(dip_df)
dip_df$scientific_name

# Transform variables to z-scores
# Start by creating function
make_z <- function(data){
  (data - mean(data))/sd(data)
}

dip_df$observed_on <- make_z(dip_df$observed_on)
hist(dip_df$observed_on)

lm(observed_on ~ scientific_name - 1, data = dip_df)
lm(observed_on ~ latitude, data = dip_df)
str(dip_df)

# Rob graphing

my.chickens <- chickwts
head(my.chickens)
table(my.chickens$feed)
n <- nrow(my.chickens)
percent_feed <- table(my.chickens$feed)/n*100
barplot_title <- "Percentage of feed per chicken"

barplot(percent_feed, 
        main=barplot_title, 
        ylab="Percent feed (%)",
        las = 2,
        col=rgb(1,0,0.5,0.25))
hist(my.chickens$weight,breaks=20,
     col="green",
     xlab="weight (g)",
     main="Chicken weights",
     ylim=c(0,13),
     xlim=c(0,500))

casein <- subset(my.chickens, my.chickens$feed == "casein")
soybean <- my.chickens[grepl(pattern="soybean", my.chickens$feed),]

hist(casein$weight, 
     breaks = 10,
     ylim=c(0,8), 
     xlim=c(0,500),
     col=rgb(1,0,0,0.25))
hist(soybean$weight, 
     breaks = 10,
     ylim=c(0,8), 
     xlim=c(0,500),
     col=rgb(0,0,1,0.25),
     add=T)
legend("topright",legend=c("casein","soybean"),col=c("red","blue",lwd=5))

boxplot.colors <- c("darkslategrey","firebrick","hotpink","orange","turquoise","forestgreen")

boxplot(weight ~ feed, 
        data = my.chickens,
        col=boxplot.colors)

library(ggplot2)
p <- ggplot(data=my.chickens, aes(weight)) + geom_histogram(color="black",fill="red")
p
