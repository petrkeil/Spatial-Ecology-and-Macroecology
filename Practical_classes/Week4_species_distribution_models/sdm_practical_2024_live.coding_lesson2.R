#-- Practicals on SDM 21/10/2024 & 04/11/2024 --#
#-- Authors: Gabriele Midolo & Carmen Soria
#-- Emails: (Gabriele: midolo@fzp.czu.cz; Carmen: soria_gonzalez@fzp.czu.cz)

#-- Here we will model the probability of occurrence of Scotch argus (Erebia aethiops - Nymphalidae) in the British Isles using occurrence records from GBIF
#-- Information on this species (and many others) can be found here: https://butterfly-conservation.org/butterflies/scotch-argus
#-- Feel free to explore other species too in the practicals and for your final projects

#-- This is the R script summarizing the steps necessary to conduct the analyses
#-- We will write down together this code during the practicals by filling each of the steps below
#-- If you can, *before the practicals*, please install the packages below, with the following code:
#install.packages(c('sdm', 'geodata', 'dismo', 'sf', 'mapview', 
#                   'tidyverse', 'CoordinateCleaner', 'ecospat', 
#                   'usdm', 'terra', 'raster'))

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

# set seed
set.seed(22)

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
res(bio)
sp <- ecospat.occ.desaggregation(sp %>% rename(x=lon, y=lat), min.dist = 0.008333333)
View(sp)
names(sp) <- c('species', 'lon', 'lat')

# 3.7 Transform the dataframe to a SpatialDataframe (hint: use `sf::as_Spatial()`)
sp_spatial <- sp %>%
  st_as_sf(coords = c('lon','lat'), crs='WGS84', remove=F) %>%
  as_Spatial()

# 3.8 Use only use occurrences that overlaps with climatic data
is_out <- raster::extract(bio, sp_spatial) %>%
  rowSums() %>%
  is.na()

sp <- sp[!is_out , ] %>%
  st_as_sf(coords = c('lon','lat'), crs='WGS84', remove=F) %>%
  as_Spatial()

nrow(sp)

# 4. SDM ####

# 4.1 Define presences column
sp$P <- 1

# 4.2 Define model formula
names(bio) %>% paste0(collapse = ' + ')
f <- formula(P ~ bio_1 + bio_3 + bio_4 + bio_8 + bio_9 + bio_18)

# 4.3 Prepare the data with `sdm::sdmData()`
sdmd <- sdmData(
  formula = f,
  train = sp,
  predictors = bio,
  bg = list(
    method = 'gRandom',
    n = nrow(sp)
  )
)
plot(sdmd)

# Plot presence and pseudoabsence data:
d_pa <- sdmd@info@coords %>% as.data.frame()
d_pa$PA <- ifelse(d_pa$rID %in% sdmd@species[["P"]]@presence, 'Presence', 'PseudoAbsence')
d_pa <- d_pa %>%
  st_as_sf(coords = c('coords.x1','coords.x2'), crs='WGS84')
plot(d_pa %>% select(PA, geometry))
#mapview(d_pa, zcol = 'PA')

# 4.4 Fit a GLM model
m_GLM <- sdm(formula = f,
             data = sdmd,
             methods = 'glm',
             replication = 'cv',
             cv.folds = 10, # number of folds
             n = 3, # number of replications
             test.p = 4/5) # the proportion of data that will be used for training

gui(m_GLM)

# 4.5 Fit a RF model
m_RF <- sdm(formula = f,
             data = sdmd,
             methods = 'rf',
             replication = 'cv',
             cv.folds = 5,
             n = 1,
             test.p = 4/5)

gui(m_RF)

# 4.6 Explore response curves with `sdm::rcurve()`
sdm::rcurve(m_GLM, id = 1, n='bio_1')
sdm::rcurve(m_GLM, id = 1, n='bio_18')
sdm::rcurve(m_RF, id = 1, n='bio_1')
sdm::rcurve(m_RF, id = 1, n='bio_18')


# 5. Predict ####

# 5.1 Aggregate bioclimatic raster for prediction (optional step)
bio_aggr <- raster::aggregate(bio, fact=10)
plot(bio_aggr$bio_1)
plot(bio$bio_1)

# 5.2 Predict the probability of occurrence
preds_GLM <- predict(m_GLM, bio_aggr)
preds_RF <- predict(m_RF, bio_aggr)

par(mfrow=c(1,2))
plot(preds_GLM$id_1__sp_P__m_glm__re_cros, main='GLM')
plot(preds_RF$id_1__sp_P__m_rf__re_cros, main='RandomForest')

# 6. Run multiple algorithms & ensemble ####

# 6.1 Fit and explore the performance of multiple algorithms (be aware of the computational time!)

sdm::getmethodNames()# this is the list of implemented algorithms

m_multi <- sdm(formula = f,
               data = sdmd,
               methods = c('ranger', 'svm', 'gbm', 'gam', 'glm'), # you can also add 'maxent' here, but make sure you have rjava installed!
               replication = 'cv',
               cv.folds = 5,
               n = 1,
               test.p = 4/5)
gui(m_multi)

# 6.2 Compare unweighted and weighted ensemble

# unweighted ensemble
e <- ensemble(m_multi, bio_aggr, setting = list(method = 'unweighted'))

# weighted ensamble
e_w <- ensemble(m_multi, bio_aggr, setting = list(method='weighted', stat='kappa', opt=2))

# compare ensemble predictions
par(mfrow=c(1,2))
# distribution of Pocc change based on twe two ensemble method. This time using the two methods seems like it is giving the same results...
plot(e, main='unweighted'); plot(e_w, main='weighted')

par(mfrow=c(1,1))
hist(e_w[]-e[]) 
