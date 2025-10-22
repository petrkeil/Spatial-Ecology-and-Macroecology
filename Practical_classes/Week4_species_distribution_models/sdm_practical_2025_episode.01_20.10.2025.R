#-- Practicals on SDM 20/10/2025 (lesson 1) & 27/10/2025 (lesson 2) --#
#-- Authors: Gabriele Midolo, Melanie Tietje, Carmen Soria
#-- Emails: (Gabriele: midolo@fzp.czu.cz; Melanie: tietje@fzp.czu.cz; Carmen: soria_gonzalez@fzp.czu.cz)

#-- Here we will model the probability of occurrence of Scotch argus (Erebia aethiops - Nymphalidae) in the British Isles using occurrence records from GBIF
#-- Information on this species (and many others) can be found here: https://butterfly-conservation.org/butterflies/scotch-argus
#-- Feel free to explore other species too in the practicals and for your final projects!

#-- This is the R script summarizing the steps necessary to conduct the analyses
#-- We will write down together this code during the practicals by filling each of the steps below
#-- If you can, *before the practicals*, please install the packages below, with the following code:
# install.packages(c('sdm', 'geodata', 'dismo', 'sf', 'mapview', 
#                    'tidyverse', 'CoordinateCleaner', 'ecospat', 
#                    'usdm', 'terra', 'raster'))

# 1. Load Packages ####
# Install packages, where needed

# Type the following in the console: install.package(x), where x is the character string of the name of the package
# install.packages('sdm')

library(sdm) # Main package to run our models
# installAll() # run it the first time (it install other package dependencies) 

# additional packages we will be using:
library(geodata) # to download climatic variables
library(dismo) # Used in SDM, here, we will use it to downoad P/A data
library(sf) # library for sf manipulation and visualisation
library(mapview) # for spatial visualisation
library(tidyverse) # for tidy data manipulation and other stuff
library(CoordinateCleaner) # cleaning species occurrence data
library(ecospat) # We will use this to clean occurrences
library(usdm) # assess collinearity in the predictors

# 2. Get climatic predictors ####

# 2.1 Download bioclim data for the study area
?geodata
bio <- worldclim_country('United Kingdom', 'bio', tempdir())
bio

# 2.2 Rename bioclim data (if needed)
names(bio) <- gsub('wc2.1_30s_','',names(bio))

# 2.3 Plot examples
plot(bio$bio_1) # plot mean annual temperature
# plot(bio) # plot all variables

# 2.4 Detect and remove collinear variables
dim(bio)

# subsample raster to reduce computation costs/time
bio_sub <- terra::spatSample(bio, 10000, method = 'regular', na.rm=T, as.points=T)
str(bio_sub)
plot(bio_sub) # view points (raster cells) sampled

# visualize correlations
values(bio_sub) %>%
  cor() %>%
  corrplot::corrplot.mixed(upper='ellipse')

# exclude unwanted variables up to a certain correlation threshold (th argument)
var_to_exclude <- 
  usdm::vifcor(
    values(bio_sub), th=0.7
  )
var_to_exclude # summary of vifcor()

# remove variables to exclude from the bio object
bio <- usdm::exclude(bio, var_to_exclude)

# plot variables left
bio %>%
  plot()

# 2.5 Convert everything to raster::stack() (step needed for running things in the sdm package)
bio <- raster::stack(bio)

# 3. Get Presence-Absence data ####

# set seed if you want
set.seed(123)

# 3.1 Download data from GBIF, we can use dismo::gbif
spd <- dismo::gbif('Erebia', 'aethiops', ext = raster::extent(bio), end = 5000)

# 3.2 Select only the columns you need
spd <- spd[,c('species','lon','lat')]
spd$species %>% table()

# 3.3 Coerce the dataframe to a spatial object
spd_sf <- st_as_sf(spd, coords = c('lon','lat'), crs = 'WGS84')

# possible visualizations of downloaded occurrences
plot(spd_sf)
mapview(spd_sf)

# 3.4 Clean occurrence records with CoordinateCleaner
spd_clean <- CoordinateCleaner::clean_coordinates(spd, 'lon', 'lat')
table(spd_clean$.summary) 

spd_clean <- spd_clean[spd_clean$.summary, ]

spd_clean <- spd_clean[,c('species','lon','lat')]

# 3.5 Remove duplicated occurrences
spd_clean <- unique(spd_clean)

# 3.6 Thin too closely located occurrences
spd_clean_thin <- ecospat::ecospat.occ.desaggregation(
  xy = spd_clean %>% rename(x=lon, y=lat),
  min.dist = 0.00834 # units in degrees, values obtained from `raster::res(bio)`
  )

spd_clean_thin <- spd_clean_thin %>% rename(lon=x, lat=y) # bring orginal names back

# 3.7 Transform the dataframe to a SpatialDataframe (hint: use `sf::as_Spatial()`)
spd_clean_thin_sf <-
  st_as_sf(spd_clean_thin,
           coords = c('lon', 'lat'),
           crs = 'WGS84') %>%
  as_Spatial() # step needed for working with rasters

mapview(spd_clean_thin_sf)

#### WE STOPPED HERE on the 20.10.2025 ####

# 3.8 Use only occurrences that overlaps with climatic data 

# 4. SDM ####

# 4.1 Define presences column

# 4.2 Define model formula

# 4.3 Prepare the data with `sdm::sdmData()`

# 4.4 Fit a GLM model

# 4.5 Fit a RF model

# 4.6 Explore response curves with `sdm::rcurve()`


# 5. Predict ####

# 5.1 Aggregate bioclimatic raster for prediction (optional step)

# 5.2 Predict the probability of occurrence


# 6. Run multiple algorithms & ensemble ####

# 6.1 Fit and explore the performance of multiple algorithms (be aware of the computational time!)

# 6.2 Compare unweighted and weighted ensemble

