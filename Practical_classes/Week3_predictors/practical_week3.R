# Libraries
library(MODIStsp)
library(tmap)
library(terra)
library(sf)
sf_use_s2(FALSE)
library(tidyverse)

# First, let's get a base map of Asia using the `rnaturalearth` package.
Asia <- ne_countries(scale=10,
                     continent='Asia',
                     type = 'map_units',
                     returnclass = 'sf')

# Now, let's dissolve the administrative borders using `st_union()`
Asia_union <- st_union(Asia) %>% st_cast()

# And transform the layer to an equal area projection. We will use: [WGS 1984 Lambert Asia](https://epsg.io/102012).
Asia_union <- st_transform(Asia_union, crs='ESRI:102012')

# Let's store that `proj4string` in an object for later.
proj_Asia_ea <- '+proj=lcc +lat_0=0 +lon_0=105 +lat_1=30 +lat_2=62 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +type=crs'

# Let's see how it looks
ggplot() +
  geom_sf(data=Asia_union, fill='white') +
  geom_sf(data=st_as_sfc(st_bbox(Asia_union)), fill=NA, col='red') +
  theme_bw()


# Let's read the data. For this we will use the `terra` package.
tavg <- rast('data/wc2.1_30s_bio_1.tif')
prec <- rast('data/wc2.1_30s_bio_15.tif')

# We will also get the elevation data from **WorldClim**.
elev <- rast('data/wc2.1_30s_elev.tif')

# Now, let's get the landcover data. For this we will use the package `MODIStsp`.  
# To download **MODIS** data through the NASA *http* server, we need to create a profile at <https://urs.earthdata.nasa.gov/home> to get a user and password. 

# Let's see what `MODIStsp` has to offer. 
MODIStsp_get_prodnames()

#With `MODIStsp_get_prodlayers()` you can see all the layers of the product:
MODIStsp_get_prodlayers("MCD12Q1")$bandnames


# We will use the function `MODIStsp()` to download data:
MODIStsp(gui             = FALSE,
         out_folder      = 'data/',
         out_folder_mod  = 'data/',
         selprod         = 'LandCover_Type_Yearly_500m (MCD12Q1)',
         bandsel         = 'LC1', 
         sensor          = 'Terra',
         user            = '' , # your username for NASA http server
         password        = '',  # your password for NASA http server
         start_date      = '2020.01.01', 
         end_date        = '2020.12.31', 
         verbose         = TRUE,
         bbox            =  c(-6784249, -1828374, 5602080, 7891185), #bbox of Asia
         spatmeth        = 'bbox',
         out_format      = 'GTiff',
         compress        = 'LZW',
         out_projsel     = 'User Defined',
         output_proj     = 'ESRI:102012',
         delete_hdf      = TRUE,
         parallel        = TRUE
)



## 2.1. Process raster 
# First we need to create a new raster to use as a base.
r <- rast(res=100000, ext(vect(Asia_union)), crs=proj_Asia_ea)

# Then, we will crop the global layer by the **bounding box** of Asia (+1 degree).
tavg <- crop(tavg, ext(vect(Asia))+1)

# We will project the layer to the equal area projection.  
tavg <- project(tavg, proj_Asia_ea, method='bilinear') # reproject to equal area

# We will resample the layer to our target resolution.  
tavg <- resample(tavg, r, method='bilinear')

# And finally we will use `mask()` to intersect the layer with the Asia polygon.
tavg <- mask(tavg, vect(Asia_union))
tavg

# We will do the same for the other continuous layers. 
prec <- crop(prec, ext(vect(Asia))+1)
prec <- project(prec, proj_Asia_ea, method='bilinear') # reproject to equal area
prec <- resample(prec, r, method='bilinear')
prec <- mask(prec, vect(Asia_union))
prec

elev <- crop(elev, ext(vect(Asia))+1)
elev <- project(elev, proj_Asia_ea, method='bilinear') # reproject to equal area
elev <- resample(elev, r, method='bilinear')
elev <- mask(elev, vect(Asia_union))
elev

# For land cover we will use a different projection method.
land <- crop(land, ext(vect(Asia))+1)
land <- project(land, proj_Asia_ea, method='near') # reproject to equal area

# Then we `resample()` and `mask()`.  
land <- resample(land, r, method='near')
land <- mask(land, vect(Asia_union))
land

# For human footprint we will also use a different projection method.
footp <- crop(footp, ext(vect(Asia))+1)
footp <- project(footp, proj_Asia_ea, method='near') # reproject to equal area
footp <- resample(footp, r, method='near')
footp <- mask(footp, vect(Asia_union))
footp <- footp %>% classify(cbind(128, NA)) # 128 is NA value in the original layer
footp


## 2.2. Visualise data 
# We will use the package `tmap`.  
tmap_mode(mode ='view')

# Annual mean temperature (WorldClim BIO1)
tm_shape(tavg) +
  tm_raster(palette = 'OrRd', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

# Precipitation seasonality (WorldClim BIO15)
tm_shape(prec) +
  tm_raster(palette = 'RdBu', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

# Elevation (WorldClim)
tm_shape(elev) +
  tm_raster(palette = 'BrBG', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

# Land-cover (MODIS Terra MCD12Q1). We need to make sure values are factors.
land <- as.factor(land$land)

# Then we can add values to the levels
levels(land[[1]]) <- data.frame(ID=c(1,2,3,11,12,13,14,15,16,21,22,31,32,41,42,43),
                                label=c('Barren',
                                        'Permanent Snow and Ice',
                                        'Water Bodies',
                                        'Evergreen Needleleaf Forest',
                                        'Evergreen Broadleaf Forests',
                                        'Deciduous Needleleaf Forests',
                                        'Deciduous Broadleaf Forests',
                                        'Mixed Broadleaf/Needleleaf Forests',
                                        'Mixed Broadleaf Evergreen/Deciduous Forests',
                                        'Open Forests',
                                        'Sparse Forests',
                                        'Dense Herbaceous',
                                        'Sparse Herbaceous',
                                        'Dense Shrublands',
                                        'Shrubland/Grassland Mosaics',
                                        'Sparse Shrubland'))


# Land-cover (MODIS Terra MCD12Q1)
tm_shape(land) +
  tm_raster(palette = 'Set1', style= "cat") +
  tm_view(bbox = st_bbox(Asia))

# Human footprint index (SEDAC)
tm_shape(footp) +
  tm_raster(palette = 'viridis', style= "cont") +
  tm_view(bbox = st_bbox(Asia))


## 3. Correlations between predictors

#Let's get values per grid-cell
tavg[]

#Rename the field
tavg[] %>% 
  as_tibble() %>% 
  rename(tavg=wc2.1_30s_bio_1)
  
# Transform the `NaN` values into `NA`, and store the values in an object.  
tavg_values <- tavg[] %>% 
  as_tibble() %>% 
  rename(tavg=wc2.1_30s_bio_1) %>% 
  mutate(tavg=ifelse(is.nan(tavg), NA, tavg))

# We will do the same with the other layers  
prec_values <- prec[] %>% 
  as_tibble() %>% 
  rename(prec=wc2.1_30s_bio_15) %>% 
  mutate(prec=ifelse(is.nan(prec), NA, prec))

elev_values <- elev[] %>% 
  as_tibble() %>% 
  rename(elev=wc2.1_30s_elev) %>% 
  mutate(elev=ifelse(is.nan(elev), NA, elev))

land_values <- land[] %>% 
  as_tibble() %>% 
  rename(land=label) %>% 
  mutate(land=ifelse(is.nan(land), NA, land))

footp_values <- footp[] %>% 
  as_tibble() %>% 
  rename(footp=`wildareas-v3-2009-human-footprint`) %>% 
  mutate(footp=ifelse(is.nan(footp), NA, footp))

# Let's see all the values together.
predictors  <- tibble(tavg_values,
                      prec_values, 
                      elev_values,
                      land_values,
                      footp_values)

summary(predictors)

# Let's see how these values correlate.
pairs(predictors, cex=0.1)

# Let's get the data
# Create 1-degree grid-cells for the entire world
# For the `cellsize` we will chose 1 degree, which is ~100km (=100,000m)
Asia_grid <- st_make_grid(Asia_union,
                          cellsize=100000,
                          square=FALSE) %>%  # this will make hexagons
  st_intersection(Asia_union) %>% 
  st_sf(gridID=1:length(.))                   # this will create a grid ID

# Testudines
turtles <- st_read('Practical_classes/Week2_gridding_and plotting/data/testudines/data_0.shp')
testudines_ea <- st_transform(turtles, crs = proj_Asia_ea) %>% st_make_valid %>% st_cast

# Get a smaller dataset of testudines
testudines_Asia <-  testudines_ea %>% 
  filter(is.na(ISLAND)) %>% 
  filter(LEGEND=='Extant (resident)') %>% 
  group_by(ID_NO) %>% 
  summarise(BINOMIAL=unique(BINOMIAL),
            PRESENCE=sum(PRESENCE)) %>% 
  ungroup() %>% st_cast()

# Calculate number of records (N) and number of species per grid-cell (SR)
grid_testudines_Asia <- st_join(Asia_grid, testudines_Asia) %>%
  group_by(gridID) %>%
  summarise(N=ifelse(n_distinct(BINOMIAL, na.rm = TRUE)==0, 0, n()),
            SR=n_distinct(BINOMIAL, na.rm = TRUE))

# saveRDS(grid_testudines_Asia, 'Practical_classes/Week3_predictors/data/grid_testudines_Asia.rds')

# Alternatively, let's read the data
grid_testudines_Asia <- readRDS('data/grid_testudines_Asia.rds')

# Plot the data and see the patterns
tm_shape(grid_testudines_Asia) +
  tm_fill('SR', palette = 'YlOrBr') +
  tm_view(bbox = st_bbox(Asia))

tm_shape(grid_testudines_Asia) +
  tm_fill('SR', palette = 'YlOrBr') +
  tm_view(bbox = st_bbox(Asia))

tm_shape(tavg) +
  tm_raster(palette = 'OrRd', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

tm_shape(prec) +
  tm_raster(palette = 'RdBu', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

tm_shape(elev) +
  tm_raster(palette = 'BrBG', midpoint = NA, style= "cont", n=10) +
  tm_view(bbox = st_bbox(Asia))

tm_shape(land) +
  tm_raster(palette = 'Set1', style= "cat") +
  tm_view(bbox = st_bbox(Asia))

tm_shape(footp) +
  tm_raster(palette = 'viridis', style= "cont") +
  tm_view(bbox = st_bbox(Asia))

