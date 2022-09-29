install.packages('sf')
# Libraries

library(sf)
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
