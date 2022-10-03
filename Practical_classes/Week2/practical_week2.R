# install.packages('sf')
# Libraries

library(rnaturalearth)
library(sf)
sf_use_s2(FALSE)
library(tidyverse)

##### LOCAL: Mapping occurrence records
# -   Get mammal's of the Czech Republic occurrence records (`POINTS`)   
# -   Get the Czech Republic's grid  
# -   Calculate mammal's species richness per grid-cell (SR)   
# -   Visualise SR hotspots in Czech Republic  


# Get the occurrence records
mammalsCZ <- readRDS('Practical_classes/Week2/data/mammalsCZ.rds')
mammalsCZ

# Let's keep few fields
mammalsCZ <- mammalsCZ %>% select(species, order, eventDate, 
                                  decimalLongitude, decimalLatitude,
                                  stateProvince, countryCode, datasetName)

mammalsCZ_sf <- mammalsCZ %>% 
  filter(!is.na(decimalLongitude) & !is.na(decimalLatitude)) %>% # filter records without coordinates
  st_as_sf(coords=c('decimalLongitude', 'decimalLatitude'),
           crs=4326) # WGS 84 = EPSG:4326


# Get the administrative borders
CZ_borders <- st_read('Practical_classes/Week2/data/CZE_adm0.shp')
CZ_borders

# Get the standard grids from the Czech Republic
CZ_grids <- st_read('Practical_classes/Week2/data/KvadratyCR_JTSK.shp')
CZ_grids

# Check CRS
st_crs(CZ_borders)
st_crs(CZ_grids)

# Let's plot the sf objects
ggplot() + 
  geom_sf(data=CZ_borders, fill='white') +
  geom_sf(data=CZ_grids, fill=NA) + 
  geom_sf(data=mammalsCZ_sf)

# Transform `CZ_borders` CRS to [S-JTSK / Krovak East North](https://epsg.io/5514)
mammalsCZ_sf <- st_transform(mammalsCZ_sf, crs = st_crs(CZ_grids))
mammalsCZ_sf

# Calculate number of records (N) and number of species per grid-cell (SR)
st_join(CZ_grids,       # GRID
        mammalsCZ_sf)   # POINTS


# Summarise the data per grid-cell. 
st_join(CZ_grids, mammalsCZ_sf) %>% 
  group_by(OBJECTID) %>% 
  summarise(N=n(),
            SR=n_distinct(species))

# Store the output into a new object `CZ_mammals_grids`.
mammalsCZ_grids <- st_join(CZ_grids, mammalsCZ_sf) %>%
  group_by(OBJECTID) %>%
  summarise(N=n(),
            SR=n_distinct(species))

# Plot
ggplot() + 
  geom_sf(data=mammalsCZ_grids) +
  coord_sf(crs=4326)

# Indicate which column from the object should the grids be filled with
ggplot() + 
  geom_sf(data=mammalsCZ_grids, aes(fill=SR)) +
  coord_sf(crs=4326)

# Check which are the minimum and maximum values of the variable we want to plot
summary(mammalsCZ_grids)

# Get a nicer scale
ggplot() + 
  geom_sf(data=mammalsCZ_grids, aes(fill=SR)) +
  scale_fill_fermenter(palette ='YlOrBr', n.breaks=9, direction = 1)+
  geom_sf(data=CZ_borders, fill=NA) +
  coord_sf(crs=4326) +
  theme_bw()

# Plot the sampling effort (`N`: number of records) 
ggplot() + 
  geom_sf(data=mammalsCZ_grids, aes(fill=N)) +
  scale_fill_fermenter(palette ='YlGnBu', n.breaks=9, direction = 1) +
  geom_sf(data=CZ_borders, fill=NA) +
  coord_sf(crs=4326) +
  theme_bw()

SR <- ggplot() + 
  geom_sf(data=mammalsCZ_grids, aes(fill=SR)) +
  scale_fill_fermenter(palette ='YlOrBr', n.breaks=9, direction = 1) +
  geom_sf(data=CZ_borders, fill=NA) +
  coord_sf(crs=4326) +
  theme_bw()

N <- ggplot() + 
  geom_sf(data=mammalsCZ_grids, aes(fill=N)) +
  scale_fill_fermenter(palette ='YlGnBu', n.breaks=9, direction = 1)+
  geom_sf(data=CZ_borders, fill=NA) +
  coord_sf(crs=4326) +
  theme_bw()

SR 
N

##### GLOBAL: Testudines of the World
# -   Get testudines' IUCN range maps (`POLYGONS`)
# -   Get a world map
# -   Create 1 degree grid-cells
# -   Calculate testudines's species richness per grid-cell (SR)   
# -   Visualise SR global hotspots  

# Read testudines' IUCN range maps
testudines <- st_read('Practical_classes/Week2/data/testudines/data_0.shp')
testudines


# Download a shapefile of the world at medium scale 
world <- ne_countries(scale = 50, returnclass='sf')

# Combine all countries into one unique polygon
world <- st_union(world) %>% st_make_valid() %>% st_cast()

# Let's see how it looks
ggplot() + 
  geom_sf(data=world, fill='white')

# Project the layers (both the world and the testudines' layers): from lat/lon to equal area projection
world_ea <- st_transform(world, crs = 'EPSG:8857') %>% st_make_valid %>% st_cast
testudines_ea <- st_transform(testudines, crs = 'EPSG:8857') %>% st_make_valid %>% st_cast

# Double check everything's alright
st_crs(world_ea, parameters = TRUE)$epsg
st_crs(world_ea, parameters = TRUE)$ud_unit
st_crs(testudines_ea, parameters = TRUE)$epsg
st_crs(testudines_ea, parameters = TRUE)$ud_unit

# Create 1-degree grid-cells for the entire world
# For the `cellsize` we will chose 1 degree, which is ~100km (=100,000m)
world_grid <- st_make_grid(world_ea, 
                           cellsize=100000,
                           square=FALSE) %>%  # this will make hexagons
  st_intersection(world_ea) %>% 
  st_sf(gridID=1:length(.))                   # this will create a grid ID

# saveRDS(world_grid, 'Practical_classes/Week2/data/world_grid.rds')

ggplot() + 
  geom_sf(data= world_grid, fill='white', size=0.5) 

# Get a smaller dataset of testudines
testu <- testudines_ea %>% 
  filter(LEGEND=='Extant (resident)') %>% 
  group_by(ID_NO) %>% 
  summarise(BINOMIAL=unique(BINOMIAL),
            PRESENCE=sum(PRESENCE)) %>% 
  ungroup() %>% st_cast()

ggplot() + 
  geom_sf(data= world_grid, fill='white', size=0.5)  +
  geom_sf(data= testu %>% head(n=3), fill='red', alpha=0.5)

# Calculate number of records (N) and number of species per grid-cell (SR)
testudines_grid <- st_join(world_grid, testu) %>%
  group_by(gridID) %>%
  summarise(N=ifelse(n_distinct(BINOMIAL, na.rm = TRUE)==0, 0, n()),
            SR=n_distinct(BINOMIAL, na.rm = TRUE))

# saveRDS(testudines_grid, 'Practical_classes/Week2/data/testudines_grid.rds')

# Plot 
ggplot() + 
  geom_sf(data=testudines_grid %>% mutate(SR=ifelse(SR==0, NA, SR)), aes(fill=SR), lwd = 0) +
  scale_fill_fermenter(palette ='YlOrBr', na.value ='grey90', n.breaks=6, direction = 1) +
  geom_sf(data=world_ea, fill=NA, col='grey70', size=0.2) +
  theme_bw()
