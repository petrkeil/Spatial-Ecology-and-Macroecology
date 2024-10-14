library(patchwork)
library(rnaturalearth)
library(sf)
library(tidyverse)

peru <- ne_countries(country = 'Peru',
                     scale=50,
                     returnclass = 'sf')

proj_peru <- 'PROJCS["ProjWiz_Custom_Transverse_Cylindrical_Equal_Area",
 GEOGCS["GCS_WGS_1984",
  DATUM["D_WGS_1984",
   SPHEROID["WGS_1984",6378137.0,298.257223563]],
  PRIMEM["Greenwich",0.0],
  UNIT["Degree",0.0174532925199433]],
 PROJECTION["Transverse_Cylindrical_Equal_Area"],
 PARAMETER["False_Easting",0.0],
 PARAMETER["False_Northing",0.0],
 PARAMETER["Central_Meridian",-74.7949219],
 PARAMETER["Scale_Factor",1.0],
 PARAMETER["Latitude_Of_Origin",0.0],
 UNIT["Meter",1.0]]'

peru_ea <- peru %>% st_transform(crs=proj_peru)
peru_grid <- st_make_grid(peru_ea,
                          cellsize=50000,
                          square=FALSE) %>%  # this will make hexagons
  st_intersection(peru_ea) %>% 
  st_collection_extract('POLYGON') %>% 
  st_sf(gridID=1:length(.))

amphibiansPE <- readRDS('Practical_classes/Week3_predictors/data/amphibiansPE.rds') 

amphibiansPE_sf <- amphibiansPE %>%
  st_as_sf(coords=c('decimalLongitude', 'decimalLatitude'),
           crs=4326)

# species plot
ggplot() + 
  geom_sf(data= peru, fill='white', size=0.5)  +
  geom_sf(data= amphibiansPE_sf, aes(col=species),
          alpha=0.5, lwd = 0.1, show.legend = F) 

amphibiansPE_sf_ea <- st_transform(amphibiansPE_sf, 
                                   crs=proj_peru)
# richness map

amphibians_grid <- st_join(peru_grid, amphibiansPE_sf_ea) %>%
  group_by(gridID) %>%
  summarise(N=sum(!is.na(species)), 
            SR=n_distinct(species, na.rm = TRUE)) %>% 
  st_cast()

SR <- ggplot() + 
  geom_sf(data=amphibians_grid %>% mutate(SR=ifelse(SR==0, NA, SR)), aes(fill=SR), lwd = 0) +
  scale_fill_fermenter(palette ='YlOrBr', na.value ='grey90', n.breaks=6, direction = 1) +
  geom_sf(data=peru_ea, fill=NA, col='grey70', size=0.2) +
  theme_bw()

N <- ggplot() + 
  geom_sf(data=amphibians_grid %>% mutate(N=ifelse(N==0, NA, N)), aes(fill=N), lwd = 0) +
  scale_fill_fermenter(palette ='YlGnBu', na.value ='grey90', n.breaks=6, direction = 1) +
  geom_sf(data=peru_ea, fill=NA, col='grey70', size=0.2) +
  theme_bw()

SR | N

saveRDS(amphibians_grid, 'Practical_classes/Week3_predictors/data/amphibians_grid.rds')
