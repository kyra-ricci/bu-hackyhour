# Introduction ------------------------------------------------------------------------
# Here are some steps in gathering and preparing your data to put into MaxEnt
# This shell is very unsystematic in how much I've left out or included :')


# Thin Points -------------------------------------------------------------------------
# (this is an alternative to creating a bias file... you will need to decide which route
# makes the most sense for your data and questions)
# Here we are thinning the observations that you initially downloaded to reduce sampling bias
# and spatial autocorrelation issues. This is not a cut-and-dry, one size fits all solution.
# You must think about what makes biological sense. Sometimes it is sampling bias, but sometimes
# a large number of observations in a particular area truly does represent the distribution of 
# your species' presence.
#
# This uses the package "spThin"
# install.packages("spThin", dependencies = TRUE)

library(spThin)

# Read in the file with your occurrence data that has been formatted for "spThin"
# Formatting means 3 columns:
# First column with the header "scientificName", with the species names formatted "genus_species"
# Second column with the header "decimalLongitude", with the longitude values
# Third column with the header "decimalLatitude", with the latitude values
# Make sure it is longitude FIRST, then latitude!

input <- read.csv("data/cal_obs_spThin.csv")


# Thin the points to no more than 1 observation per square kilometer - you can change this to suit your needs
thin(
  
  loc.data = , 
  lat.col = , long.col = , 
  spec.col = , 
  thin.par = , reps = , 
  locs.thinned.list.return = , 
  write.files = , 
  max.files = , 
  out.dir = , out.base = , 
  write.log.file = ,
  log.file =  
  
)

# Now you have files with your thinned observations




# Download predictor variables - Bioclim --------------------------------------------
# Adapted from https://rsh249.github.io/spatial_bioinformatics/worldclim.html

# Load in dismo and rgdal packages
library('dismo')
library('rgdal')

# For 30 arc-sec resolution, you need to download by tile...
env1 <- getData(, var= , res=, download = , lat=38.5, lon=-122)
env2 <- getData(, var=, res=, download = , lat=38.5, lon=-114)
env3 <- getData(, var=, res=, download = , lat=29.5, lon=-122)
env4 <- getData(, var=, res=, download = , lat=29.5, lon=-114)

# Merge the four tiles into one rasterstack called envall
env12<-merge(env1, env2)
env123<-merge(env12, env3)
envall<-merge(env123, env4)


# Define extent of study region (cropping)
e <- extent(c(-121.534367, -114.662118, 29.986786, 38.002557))

# Crop bioclim data to this extent
Bio <- crop()

# Write rasters as GeoTiffs and save to computer
for (i in 1:nlayers()){
  # writeRaster is a function that will write each layer with the correct name. As the 
  # loop iterates through, each layer in turn becomes "i". For the names, we will
  # use the names from any of the rasterstacks we downloaded from worldclim
  writeRaster(, filename = names(), format=, overwrite=)
}


# Convert Tiff files to Ascii files ---------------------------------------------------
# load "raster" package
library(raster)

# Load Bioclim Tiff file
f <- 
  
# Rasterize me, Cap'n
r <- raster()

# Write this raster to a new file, now in Ascii format
writeRaster(, , format=, overwrite=T)


# Download predictor variables - ISRIC ------------------------------------------------

# ISRIC is International Soil Reference and Information Center

# Load in "geodata" package
library(geodata)

# Downloading each individual variable (we'll just do two for this exercise)

nitrogen <- soil_world(var=, depth=, path='data')
soc <- soil_world(var=, depth=, path='data')

# Now we will clip this global raster to a more manageable extent
# Load the "raster" package
# library(raster)

# Create a box as a Spatial Object to define the extent we want

e <- as(extent(-122, -114, 29.5, 38.5), 'SpatialPolygons')
crs(e) <- "+proj=longlat +datum=WGS84 +no_defs"


# Crop the original (global) raster to that extent
cnitrogen <- crop(,)

# Make it into a raster
b <- raster(cnitrogen)

# Write the file in ascii format for MaxEnt
writeRaster(, filename = , format=, overwrite=)

# Do it again for each variable
csoc <- crop(,)
b <- raster(csoc)
writeRaster(, filename = , format=, overwrite=)

# Match raster extents from multiple sources ----------------------------------------
# All of the rasters need to be the EXACT same extent for MaxEnt to run, down to the pixel

# Load package "raster"
# library(raster)
# Load in and rasterize variables we've just clipped
nitrogen <- raster()
soc <- raster()

#Load in raster I want these variables to match to. In this case, I want nitrogen and soc to
# match the bioclim variables - those all have the same extents, so we'll just use Bioclim 1 as a reference
bio1 <- raster()

# Resample these rasters to the extent of the reference raster (Bioclim 1)
nitrogen1 <- resample()
soc1 <- resample()

# Write these new rasters to files
# Write the rasters
writeRaster(, , overwrite = )

# Check your rasters for highly correlated variables --------------------------------
# High correlations among variables are common, especially in Bioclim variables (like temperature
# of the warmest month vs. temperature of the warmest quarter, for example).
# MaxEnt is pretty good at accounting for these correlations, and I need to do more research on how
# necessary this is, but it's a good idea to remove some variables that are extremely highly correlated
# I haphazardly decided on correlations >95%

# Load package "raster"
# library(raster)

# Load package "ENMTools"
library(ENMTools)

# Load in all your predictor variables (we'll just do 5 in the interest of time)
bio1 <- raster()
bio2 <- raster()
bio3 <- raster()
bio4 <- raster()
bio5 <- raster()

# Stack all these layers into one Raster Stack
# Note - Raster Stacks combine rasters while allowing them to be analyzed independently,
# whereas a Raster Brick combines multiple rasters into one single object, adding the 
# values together, I think.
layers.stack <- raster::stack()

# Run your correlation check - this creates a matrix of correlations between all variables
# This step will take quite a while if you have many variables (like if you put in all 19 Bioclim variables)
correlations <- raster.cor.matrix()

# Create a csv file of this correlation matrix so you can study it. You'll want to take time to decide
# which variables to exclude if there is a high correlation. Think about which variable might be more 
# biologically relevant in terms of how it could affect your species' presence or absence.

write.csv(,)