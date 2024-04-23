## Part 1: Plant data ---------------------------------------------

# load in packages
library(tidyr)
library(dplyr)
library(ggplot2)

# add iris dataset
data <- iris

### Intro ----------------------------------------------------------
#### Pipe operator--------------------------------------------------

# pipe operator = %>%
# ctrl + shift + M is the shortcut
# logical operators ==, !=, >, <, >=, <=, %in%

#### Rows ----------------------------------------------------------
data %>% 
  filter(Species == "setosa") # look at setosa only
data %>% 
  filter(Species != "setosa")
data %>% 
  filter(Petal.Width > 1.5)
data %>% 
  filter(Petal.Width > 1.5 & Species == "virginica")

#### Columns -------------------------------------------------------
data %>% 
  select(Sepal.Length,Sepal.Width)
data %>%
  select(-Species)
data %>% 
  select(species = Species)

#### Mutate --------------------------------------------------------
data %>% 
  mutate(ratio = Sepal.Width/Petal.Width) # this creates a new column called "ratio"

### Data -----------------------------------------------------------

# load data
germ <- read.csv("data/germ_day.csv")
day_4 <- read.csv("data/day_4_size.csv")
day_17 <- read.csv("data/day_17_size.csv")

# peek at data
head(germ)
head(day_4)
head(day_17)

# make a standard error function for us to use below

se <- function(x){
  sd(x)/sqrt(length(x))
}

#### Join datasets -----------------------------------------------------------------

# we did each of these by adding one line at a time 
# checked head() each time to make sure it was doing what we wanted it to
# the pipe operator allows us to continue to add things with "germ" as the first argument

germ %>% # germ will be on the left, the next argument will be on the right
  # find tray ID #s in both dataframes and combine them
  left_join(day_4, by = "tray_id") %>% 
  # do the same to add day_17 data by six_pack IDs
  left_join(day_17, by = "six_pack") %>% 
  # get rid of any NAs
  drop_na(day_4) %>%  
  drop_na(day_17) %>% 
  # keep only rows that germinated on day 3
  filter(germ_day == 3) %>% 
  # pull out line, day_4, and day_17
  select(line, day_4, day_17) %>% 
  # create growth rate from the size of plants at both times
  mutate(rgr = (log(day_17) - log(day_4))/13) %>% 
  # group by line
  group_by(line) %>% 
  # calculate descriptive stats
  summarise(mu = mean(rgr),
            var = var(rgr),
            se = se(rgr)) %>% 
  # plot the means and 2 se
  ggplot(aes(x = line, y = mu)) +
  geom_point(color = "pink", size = 5) +
  geom_errorbar(aes(x = line, ymax = mu + 2*se,
                    ymin = mu - 2*se), color = "pink") +
  theme_light() +
  labs(title = "Great Data Wrangling Adventure",
       subtitle = "Hacky Hours",
       x = "Line",
       y = "Relative Growth Rate",
       color = "Line")

## Part 2: Human data ----------------------------------------------

# load in data
rx <- read.csv("data/rx_data.csv")

# take a look at data
View(rx)
head(rx)
str(rx)

# replace blank spaces with nas

rx <- read.csv("data/rx_data.csv", na.strings = '')
View(rx) # blanks have been replaced with nas from na.string function

rx <- rx %>% 
  rename(drugs = RXDDRUG) # we are going to focus just on this variable - rename to make it easier
str(rx)

rx_metformin <- rx %>% 
  filter(drugs == "METFORMIN")
View(rx_metformin)

# create new dataframe selecting only rows that use metformin as their drug
rx_metformin <- rx[grep("METFORMIN", rx$drugs),]
View(rx_metformin)

# create new dataframe including everyone else who don't use metformin
rx_notformin <- rx[-grep("METFORMIN", rx$drugs),]

# there are multiple people that are taking more than 1 drug
# so need to separate so each person is only represented once

rx_notformin_dist <- rx_notformin %>% 
  distinct(SEQN)

nrow(rx_notformin_dist) # 9220 people not taking metformin

rx_metformin_dist <- rx_metformin %>% 
  distinct(SEQN)

nrow(rx_metformin_dist) # 610 people taking metformin
