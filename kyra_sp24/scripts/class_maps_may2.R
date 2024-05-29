#ggplot2 basic maps----
###install and load pacakges- these are standard map packages-----
install.packages(c("maps", "mapdata"))


devtools::install_github("dkahle/ggmap") #devtools makes package development easier by providing R functions that simplify and expedite common tasks
# ggmaps makes it easy to retrieve raster map tiles from popular online mapping services like Google Maps, Stadia Maps, and OpenStreetMap, and plot them using the ggplot2 framework.





library(tidyverse)
library(mapdata)#mapdata package extends the maps package with more geospatial datasets. ggplot2 operates on data frames. Therefore we need some way to translate the maps data into a data frame format the ggplot can use. This is done for us with the  map_data function in `ggplot2'
library(maps)#the maps package contains diff map outlines and points for cities 
library(stringr)#stringr package provides a cohesive set of functions designed to make working with strings as easy as possible
library(viridis)# viridis provides colorblind-friendly color maps for R
library(ggplot2) #plotting
library(dplyr) #data manipulation

#if you want to see what countries are available to make maps of
unique(map_data('')$)

###lets make map of USA  ----

#create your object
 <- map_data("")

dim() #if you assign the value to the dim() function, then it sets the dimension for that R Object

head()
tail()

#make object w2hr
<- map_data("")#world2Hires contains  million points representing the world coastlines and national boundaries

dim()

head()
tail()


#now plot map
ggplot() +
  geom_polygon(data = , aes(x = , y = , group = )) + coord_quickmap() 

#'geom_polygon()' drawn lines between points and “closes them up” (i.e. draws a line from the last point back to the first point)
#'group' This is very important! ggplot2’s functions can take a group argument which controls whether adjacent points should be connected by lines. If they are in the same group, then they get connected, but if they are in different groups then they don’t.
#'coord_quickmap()' is  important when drawing maps. It sets the relationship between one unit in the  y direction and one unit in the  x direction so that the aspect ratio is good for your map.
#Then, even if you change the outer dimensions of the plot the aspect ratio remains unchanged.
#remember that fixed values of aesthetics (those that are not being mapped to a variable in the data frame) go outside the aes function 

#this map will have a red line w/ no fill 
ggplot() +
  geom_polygon(data = , aes(x = , y = , group = ), fill = NA, color = "") + coord_quickmap()

#this map will have a violet fill with a blue line 
gg1 <- ggplot() + 
  geom_polygon(data = , aes(x = , y = , group = ), fill = "", color = "") + 
  coord_quickmap()
#view map


#now add points to the map - they will  black and yellow points at the NMFS lab in Santa Cruz and at the Northwest Fisheries Science Center lab in Seattle.

#create an object - this object the points that will be plotted to the map 
labs <- tibble(
  long = c(,),
  lat = c(,),
  names = c("", ""))  

#plot points to map; remember that 'gg1' is the map you already created so basically its gg1 (the map) + the points
gg1 + 
  geom_point(data = labs, aes(x = , y = ), shape = , color = "", fill = "", size = ) +
  geom_text(data = labs, aes(x = , y = , label = names), hjust = , nudge_x = )

#geom_point() adds points to the plot
#geom_text() adds only text to the plot. 
#geom_label() draws a rectangle behind the text, making it easier to read.
#nudge_x = In units of the x axis, nudge the text label left or right. * nudge_y = In units of the y axis, nudge the text label up or down.
#Aesthetic parameters hjust and vjust are used for text layers (geom_text, geom_label) and defines horizontal and vertical justification. Values can be set as text or numeric: hjust "top" (1), "middle" (0.5), "bottom" (0) vjust "left" (0), "center" (0.5), "right" (1)


###the importance of the group aesthetic ----
#first we plot the same map without the group aesthetic 
ggplot() + 
  geom_polygon(data = , aes(x = , y = ), fill = "", color = "") +  geom_point(data = , aes(x = , y = ), shape = , color = "", fill = "", size = ) +
  geom_text(data = , aes(x = , y = , label = names), hjust = , nudge_x = ) +
  coord_quickmap() #this map is no good - the lines are connecting points that should not be connected

###include state boundaries ----

#create object 'states' this is what the map will use to include state boundaries 
 <- map_data("")

dim(states)
head(states)
tail(states)

#now plot all the states all colored a little differently 
#This is just like it is above, but (using the aes function) we can map the fill aesthetic to region and make sure the the lines of state borders are white.
#fill = region (for states)

ggplot(data = states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
  coord_quickmap() +
  guides(fill = "none") 
#fill=region for states 
#'guides' can either be a string (i.e. "colorbar" or "legend"), or a call to a guide function (i.e. guide_colourbar() or guide_legend() ) specifying additional arguments.

###plot a subset of states (for states whos borders touch) -----

#Because the map_data() sends back a data frame, we can use the 'tidy tools' or 'dplyr' to retain just certain parts of it. (ie to just want the states: CA, OR, and WA)

westcoast <- states  %>%
  filter( %in% c("california", "oregon", "washington"))
ggplot(data = west_coast) + 
  geom_polygon(aes(x = , y = ), fill = "", color = "") 
#use pipe operator; takes the output of one function and passes it into another function as an argument
#%in% is an actual operator defined in R which tests whether the left-hand expression is contained in the right-hand expression. 
#this map is ugly because the group function and the coord_quickmap() function were not included, without these functions the aspect ratio is off

ggplot(data = ) + 
  geom_polygon(aes(x = , y = , group = ), fill = "", color = "") + 
  coord_quickmap()

###CA and at its counties----

#create an object of USA states
ca_df <- states  %>% 
  
  #filter out the states object to just get CA
  filter(region =="california") #filter function is used to subset a data frame based on a provided condition # "==" returns true if two values are equal 

#first 6 lines of CA localities/ regions of CA
head(ca_df)

####include county lines of CA----
#create object for counties 
counties <-  map_data("county")

#create object for counties of CA specifically
ca_county<- counties %>%
  filter(region=="california")

#first 6 lines of CA county localities
head(ca_county)

####plot state of CA----

#create an object called 'ca_base' to plot the state of CA, the data ca_df is data of CA localities 
ca_base<- ggplot(data = ca_df, mapping = aes(x=long, y=lat, group=group)) +
  coord_quickmap() +
  geom_polygon(color="black", fill ="gray")
ca_base + theme_void()
#theme_void() is a  completely empty theme; use theme_void which leaves everything off except the geoms and the guides if they are needed,

####plot county lines in white----

#ca_base is the map of CA, data is of CA counties
ca_base + theme_void() +
  geom_polygon(data = ca_county, fill = NA, color = "white") +
  geom_polygon(color = "black", fill = NA)#have to include this to get the black outline around CA back 

###include facts about the counties -----

#load CA population data 
x <- readLines("C:/Users/kyrad/Desktop/bu-hackyhour/kyra_sp24/ca-counties-wikipedia.txt") # population data from wikipedia or http://www.california-demographics.com/counties_by_population and grab population and area data for each county.

#create an object of CA pop data to eventually  plot to map of CA
pop_and_area <- str_match(x, "^([a-zA-Z ]+)County\t.*\t([0-9,]{2,10})\t([0-9,]{2,10}) sq mi$")[, -1] %>% #str_match() : a character matrix with the same number of rows as the length of string / pattern . The first column is the complete match, followed by one column for each capture group.
  na.omit()%>%#na. omit() to remove all observations with missing data on ANY variable in the dataset.
  as.data.frame(stringsAsFactors = FALSE) %>%
  mutate(subregion = str_trim(V1) %>% tolower(),#the mutate function is used to create a new variable from a data set. 
         population = as.numeric(str_replace_all(V2, ",", "")),
         area = as.numeric(str_replace_all(V3, ",", ""))
  ) %>%
  dplyr::select(subregion, population, area) %>%
  tibble::as_tibble() #The tibble::as_tibble() class is a subclass of data frame , created in order to have different default behaviour. 

head(pop_and_area)


#cacopa (CA_county_population) will be the object for adding the numbers we want to the counties 
cacopa <- left_join(ca_county, pop_and_area, by = "subregion") %>% # we now have the numbers we want but we need to attach those to every point on polygons of the counties--you need left_join from the dplyr package to do this. 
  mutate(people_per_mile = population / area)#the mutate function is used to create a new variable from a data set; this will add a column of people_per_mile

head()

####plot population denisty by county ----

#create object of CA map w/ population densities
elbow_room1 <- ca_base + #remember that ca_base is the map of CA, data is of the population denisty of CA counties
  geom_polygon(data = cacopa, aes(fill = people_per_mile), color = "white") +
  geom_polygon(color = "black", fill = NA) +
  theme_void()
#view map 
elbow_room1 
#the plot produced isnt great because you cant see the gradient color of ppl per mile in CA 

####Edit cacopa map -----

#get the previous map just made and add a gradient 
elbow_room1 + scale_fill_gradient(trans ="log10")

#add colors to the cacopa gradient map 

#we need to create a new object "eb2" for the CA plot in color
eb2 <- elbow_room1 + 
  scale_fill_gradientn(colours = rev(rainbow
    (7)), #'gradientn' for colors 
                       breaks = c(2, 4, 10, 100, 1000, 10000), #Anumeric vector of positions
                       trans = "log10")

#run ?scale_fill_gradientn for more info on this function

#view map
eb2

#make map more colorblind friendly :)
eb3 <- elbow_room1 + 
  scale_fill_viridis(breaks = c(2, 4, 10, 100, 1000, 10000), #use package virdis, within virdis use scale_fill_viridis
                     trans = "log10")

#view colorblind friendly map


##zoom into CA -----

#You want to keep all the data the same but only just zoom and to keep the aspect ratio correct you need to use coord_quickmap() 
eb3 + coord_quickmap(xlim = c(-123, -121.0),  ylim = c(36, 38))

#Create map of diff country using ggplot2----

#view what countries you can make map of 
unique(map_data('world')$region)

#create object of costa rica coordinates/localities to make map of CR
Costa_Rica <- map_data('')[map_data('')$region == "Costa ",]

#now create map of Costa Rica using ggplot2
## First layer: worldwide map
ggplot() +
  geom_polygon(data = map_data(""),
               aes(x=long, y=lat, group = group),
               color = '#9c9c9c', fill = '#f3f3f3') +
  ## Second layer: costa rica map
  geom_polygon(data = ,
               aes(x=, y=, group = group),
               color = '', fill = '') + ggtitle("") +
  theme(panel.background =element_rect(fill = ''))
ggplot() +
  geom_polygon(data = Costa_Rica, aes(x = long, y = lat, group = group), fill = NA, color = "") + coord_quickmap()

#view list of colors for 'fill' in geom_polygon
colours(distinct = FALSE)

#GGMAP - Stadiamaps maps! ---------------------------
#ggmap is an R package that makes it easy to retrieve raster map tiles from popular online mapping services like Google Maps, Stadia Maps, and OpenStreetMap, and plot them using the ggplot2 framework.

#I use stadiamaps because its a free API key unilke googlemaps 


#load you API key for stadiamaps
register_stadiamaps
#Your API key is private and unique to you, so be careful not to share it online, for example in a GitHub issue or saving it in a shared R script file. 
#If you share it inadvertently, just go to client.stadiamaps.com, delete your API key, and create a new one.

install.packages("patchwork")
install.packages("ggdensity")

library("ggmap")
library("dplyr", warn.conflicts = FALSE) #Data manipulation
library("forcats") #forcats package is to provide useful tools that solve common problems with factors. Factors are useful when you have categorical data, variables that have a fixed and known set of values, and when you want to display character vectors in non-alphabetical order.
library("patchwork") #Patchwork is designed to make plot composition in R extremely simple and powerful. It makes sure ggplots are properly aligned no matter the complexity of your composition.
library("ggdensity") #'ggdensity' implements additional density estimators as well as more interpretable visualizations based on highest density regions instead of the traditional height of the estimated density surface. Perform 2D density estimation, compute and plot the resulting highest density region

base <- readRDS("kyra_sp24/data/map_base.rds")

###create map of southern Costa Rica-----

#use google maps to get coordantes for what you want to make a map of 
#you really just need two sets of coordinates; you need the top-left corner and the bottom-right corner that cover the surface of what you want to make a map of (imagine a square)
#ie mine are:
# top(x) left(y): (8.93, -83.7) 
# bottom(x) right(y): (7.97, -82.8)

scr <- c(left =-86.7, bottom =7.97, right = -82.8, top = 8.93) 
base |> ggmap()
base(scr,zoom = , maptype =  "") |> ggmap() 
#you can choose diff map types. Run ?get_stadiamap to see maptype options and other details 

# lets add field site points
#load in file and create object of field sites 
CRsites <- read.csv("kyra_sp24/data/cr_sites_coord.csv")
CRsites

#add the field sites as points to map of SCR you just made 
scr <- c(left =, bottom =, right = -, top =) 
base|> ggmap() + geom_point(data = CRsites, aes (x = lat, y = lon), color = "red")



# GGMAP



