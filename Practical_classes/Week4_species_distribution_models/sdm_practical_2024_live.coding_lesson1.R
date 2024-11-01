#-- Practicals on SDM 21/10/2024 & 04/11/2024 --#
#-- Authors: Gabriele Midolo & Carmen Soria
#-- Emails: (Gabriele: midolo@fzp.czu.cz; Carmen: soria_gonzalez@fzp.czu.cz)

#-- Here we will model the probability of occurrence of Scotch argus (Erebia aethiops - Nymphalidae) in the British Isles using occurrence records from GBIF
#-- Information on this species (and many others) can be found here: https://butterfly-conservation.org/butterflies/scotch-argus
#-- Feel free to explore other species too in the practicals and for your final projects

#-- This is the R script summarizing the steps necessary to conduct the analyses
#-- We will write down together this code during the practicals by filling each of the steps below
#-- If you can, *before the practicals*, please install the packages below, with the following code:
install.packages(c('sdm', 'geodata', 'dismo', 'sf', 'mapview', 
                   'tidyverse', 'CoordinateCleaner', 'ecospat', 
                   'usdm', 'terra', 'raster'))

# 1. Load Packages ####
# Install packages, where needed

# Type the following in the console: install.package(x), where x is the character string of the name of the package
# install.packages('sdm')

library(sdm) # Main package to run our models
installAll() # run it the first time (it install other package dependencies) 

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
?geodata::geodata
bio <- worldclim_country('United Kingdom', var = 'bio', tempdir())

# 2.2 Rename bioclim data (if needed)
names(bio) <- str_remove(names(bio), 'wc2.1_30s_')

# 2.3 Plot examples
bio$bio_1 %>% plot # Mean annual temperature
plot(bio)

# 2.4 Convert everything to raster::stack
bio <- raster::stack(bio)

# # 2.5 Crop manually (if need; not really in this case!)
# ext <- drawExtent()
# ext
# 
# bio2 <- crop(bio, ext) 
# 
# plot(bio2$bio_1)

# 2.6 Detect and remove collinear variables
set.seed(22)
random_points <- bio[] %>%
  as.data.frame() %>%
  na.omit() %>%
  sample_n(10000)

str(random_points)

cor(random_points) %>%
  corrplot::corrplot.mixed(upper='ellipse')

vifcor_res <- usdm::vifcor(random_points, th=0.7) # remove collinear variables below pearson's correlation < 0.7
vifcor_res

# ?usdm::vif
# vifcor_res <- usdm::vif(random_points, th=10) # use Variance Inflation Factor instead

bio <- usdm::exclude(bio, vifcor_res)
plot(bio)

# 3. Get Presence-Absence data ####

# 3.1 Download data from GBIF, we can use dismo::gbif
sp <- dismo::gbif('Erebia', 'aethiops', ext=extent(bio), download = T, end = 5000)
sp

# 3.2 Select only the columns you need
names(sp)

sp <- sp[, c('species','lon','lat','country')]

# 3.3 Coerce the dataframe to a spatial object
sp_sf <- sp %>%
  st_as_sf(coords = c('lon','lat'), crs='WGS84', remove=F)

sp_sf

plot(sp_sf)
mapview(sp_sf)

# 3.4 Clean occurrence records with CoordinateCleaner
sp_clean <- CoordinateCleaner::clean_coordinates(sp, 'lon', 'lat', 'species', 'country')

sp_clean %>% View()

sp_clean$.summary %>% table()

sp <- sp[sp_clean$.summary,] # exclude flagged observations

sp <- sp[, c('species','lon','lat')] # we can get rid of country

sp_sf <- sp %>%
  st_as_sf(coords = c('lon','lat'), crs='WGS84', remove=F)
mapview(sp_sf)

# 3.5 Remove duplicated occurrences
sp <- unique(sp)

# 3.6 Thin too closely located occurrences

# 3.7 Transform the dataframe to a SpatialDataframe (hint: use `sf::as_Spatial()`)

# 3.8 Use only use occurrences that overlaps with climatic data 


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

