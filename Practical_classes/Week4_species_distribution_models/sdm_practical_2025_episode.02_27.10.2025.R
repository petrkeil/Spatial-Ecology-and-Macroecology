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

bio_extr <- raster::extract(bio, spd_clean_thin_sf, df = T, id = T)

bio_extr <- bio_extr %>% na.omit()

spd_clean_thin_sf <- spd_clean_thin_sf[bio_extr$ID, ]

# 4. SDM ####

# 4.1 Define presences column

spd_clean_thin_sf$P <- 1

# 4.2 Define model formula

mf <- paste0('P ~', paste(names(bio), collapse = ' + ')) %>%
  as.formula()

# 4.3 Prepare the data with `sdm::sdmData()`

sdmd <- sdmData(
  formula = mf,
  train = spd_clean_thin_sf,
  predictors = bio, # %>% raster::mask(uk_shape), 
  bg = list(
    method = 'gRandom', n = nrow(spd_clean_thin_sf)
  )
)

# visualize presence absence data
sdmd@info@coords %>%
  as.data.frame() %>%
  left_join(
    sdmd %>%
      as.data.frame()
  ) %>%
  ggplot(aes(coords.x1, coords.x2, col=as.factor(P))) +
  geom_point()

# # retrieve UK coastline shapefile (used to mask predictor rasters)
# uk_shape <- rnaturalearth::ne_countries(scale = 'large', country = 'united kingdom')
# plot(uk_shape)

# 4.4 Fit a GLM model

# standard glm in R
glm(mf, 'binomial', data = as.data.frame(sdmd)) %>%
  summary()

# get the method names (algorithm names)
sdm::getmethodNames()

sdm_glm <- sdm(
  formula = mf,
  data = sdmd,
  methods = 'glm',
  # use random cross validation
  replication = 'cv',
  cv.folds = 5,
  n = 1,
  test.percent = 30 
)

gui(sdm_glm) # explore results in the GUI

# 4.5 Explore response curves with `sdm::rcurve()`

# for glm
rcurve(sdm_glm, id=1, n = 'bio_15') +
  labs(
    x = 'Clim. predictor (Precipitation seasonality)', y = 'P. occ. of E. aethiops'
  )
rcurve(sdm_glm, id=1, n = 'bio_1') +
  labs(
    x = 'Clim. predictor (Mean Annual Temperature)', y = 'P. occ. of E. aethiops'
  )

# 4.6 Fit a RF model
sdm_rf <- sdm(
  formula = mf,
  data = sdmd,
  methods = 'rf',
  # use random cross validation
  replication = 'cv',
  cv.folds = 5,
  n = 1,
  test.percent = 30 
)

gui(sdm_rf) # explore results in the GUI

# plot curves with random forests
rcurve(sdm_rf, id=1, n = 'bio_15') +
  labs(
    x = 'Clim. predictor (Precipitation seasonality)', y = 'P. occ. of E. aethiops'
  )
rcurve(sdm_rf, id=1, n = 'bio_1') +
  labs(
    x = 'Clim. predictor (Mean Annual Temperature)', y = 'P. occ. of E. aethiops'
  )


# 5. Predict ####

# 5.1 Aggregate bioclimatic raster for prediction (optional step)
bio_aggr <- raster::aggregate(bio, fact = 10)

# 5.2 Predict the probability of occurrence
pred_glm <- predict(sdm_glm, bio_aggr)
# plot(pred_glm)

pred_rf <- predict(sdm_rf, bio_aggr)
# plot(pred_rf)

# compare predictions made by the two algorithms
par(mfrow = c(1,2))
plot(pred_glm[[1]], main='GLM')
plot(pred_rf[[1]], main='RandomForest')

# 6. Run multiple algorithms & ensemble ####

# 6.1 Fit and explore the performance of multiple algorithms (be aware of the computational time!)

st=Sys.time() # Note it could take some time, say 8 minutes
sdm_multi <- sdm(
  formula = mf,
  data = sdmd,
  methods = c('svm', 'gam', 'glm', 'rf'), # check names of algorithms that can be used: sdm::getmethodNames()
  # use random cross validation
  replication = 'cv',
  cv.folds = 5,
  n = 1,
  test.percent = 30 
)
print(Sys.time()-st)

# 6.2 Compare unweighted and weighted ensemble methods

?ensemble

unweight_ens <- ensemble(sdm_multi, 
         bio_aggr,
         setting = list(
           method= 'unweighted'
         ))

weight_ens <- ensemble(sdm_multi, 
                         bio_aggr,
                         setting = list(
                           method= 'weighted', stat='TSS', opt=2
                         ))

par(mfrow = c(1,2))
plot(unweight_ens[[1]], main='unweighted')
plot(weight_ens[[1]], main='weighted (TSS)')

gui(sdm_multi)