library(ggplot2)

# load in the dataset and convert . to NAs
liz <- read.csv("C:/Users/kyrad/Desktop/hacky_hour/data/Gangloffetal2019_PBZ_PrimaryData.csv",
                 na = ".")
head(liz)

# converts character data to factor
liz$Population <- as.factor(liz$Population)
liz$Treatment <- as.factor(liz$Treatment)
liz$Timepoint <- as.factor(liz$Timepoint)

# use this to see different unique entries in a column
levels(liz$Population)

# plotting in base R
plot(liz$Capture_Mass ~ liz$SVL_Capture,
     pch = 19)


# Basic graphing in ggplot ------------------------------------------------
## Using the parent layer --------------------------------------------------

# plotting in ggplot
ggplot(data = liz,
       # everything related to the dataset goes within the mapping argument
       mapping = aes(x = SVL_Capture,
                     y = Capture_Mass)) +
  # ggplot is build on layers. The above commands create a template that needs to be added to using +
  # geom_point() creates a scatterplot
  geom_point()


## Using the geom layer ----------------------------------------------------

# another way to graph in ggplot is to put the arguments into the geom layers
# a second way to make the sample plot as above - you can put the data in either set of ()
ggplot() +
  geom_point(data = liz,
             mapping = aes(x = SVL_Capture,
                           y = Capture_Mass)) +
  # you can also add to this
  geom_smooth(data = liz,
              mapping = aes(x = SVL_Capture,
                            y = Capture_Mass))

# Base format looks like this, where (data, x, y) goes into the parentheses
# ggplot() +
  # geom_point() +
  # geom_smooth()
# If you want all subsequent commands to inherit the same data, you can just enter it in the ggplot()
# If you want to use different data in different commands, enter them separately

# Splitting between the different layers
ggplot(data = liz) +
  geom_point(mapping = aes(x = SVL_Capture,
                           y = Capture_Mass,
                           color = "Capture")) +
  geom_point(mapping = aes(x = Experiment_SVL,
                            y = Experiment_Mass,
                           color = "Experimental"))


# Converting data to long form --------------------------------------------

# load in packages
library(dplyr)
library(tidyr)

# ctrl shift m to create a pipe operator
# recall - piping makes it so the argument is the first one in the subsequent functions
liz %>% 
  head()
# this is the same as head(liz)

# Syntax for converting to long form
longliz <- liz %>% 
  # Start with svl
  pivot_longer(
    # col = tells you the columns that you want to stack on top of each other
    col = c("SVL_Capture", "Experiment_SVL"),
    # creates the name of the new indexing variable
    names_to = "svl_type",
    # creates the name of the values
    values_to = "svl"
  ) %>% 
  # Do it again for mass
  pivot_longer(
    # you can alternatively do col = col#1:col#n to pivot multiple columns without typing their names
    col = 5:6,
    names_to = "mass_type",
    values_to = "mass"
  ) %>% 
  # because we did it twice, we need to filter so each row only contains either capture OR experimental data
  filter((svl_type == "SVL_Capture" 
         & mass_type == "Capture_Mass")
         | (svl_type == "Experiment_SVL" 
         & mass_type == "Experiment_Mass"))
  # views the new dataframe
  # View()
  # at this point you can either assign this to a new dataframe OR pipe this dataframe directly into ggplot 

longliz %>% 
  ggplot(mapping = aes (x = svl,
                        y = mass,
                        color = svl_type)) +
  geom_point()


# Other types of plots ----------------------------------------------------

# boxplot uses geom_boxplot()
longliz %>% 
  ggplot(aes(x = svl_type,
             y = svl)) +
  geom_boxplot()

# violin plot uses geom_violin
longliz %>% 
  ggplot(aes(x = svl_type,
             y = svl)) +
  geom_violin() +
  # you can overlay the points using geom_jitter()
  geom_jitter(width = 0.2, # width controls how spread out the points are
               # there is also a height argument if you are plotting horizontally
              alpha = 0.6, # alpha changes transparency
              color = "lightpink") # color changes point color


# Improving the scatterplot -----------------------------------------------

newlongliz <- longliz %>%
  filter((svl_type == "SVL_Capture" 
          & Timepoint == "T1")
         | svl_type == "Experiment_SVL") %>% 
  mutate(Timepoint = ifelse(svl_type == "SVL_Capture", "0", Timepoint))

newlongliz %>% 
  ggplot(mapping = aes(x = svl,
                       y = mass,
                       color = Timepoint)) +
  geom_point() +
  
  # add a best fit line
  geom_smooth(method = "lm",
              se = F) + # method = lm will create a straight best fit line
  # geom_abline() is another option for adding best fit line if you have a function that you've calculated independently
  
  # changing axis title
  labs(title = "Lizard mass vs. SVL",
       x = "Mass (g)",
       y = "SVL (cm)") +
  
  # change background and themes
  # you can select from preset themes or create your own
  theme_minimal() +
  
  # change colors on the legend - for this you can also use presets or create your own
  # scale_color_manual(values = # add palette color here)
  
  # Center the title
  theme(plot.title = element_text(hjust = 0.5,
                                  size = 16,
                                  face = "bold"),
        axis.text = element_text(size = 14))
  

