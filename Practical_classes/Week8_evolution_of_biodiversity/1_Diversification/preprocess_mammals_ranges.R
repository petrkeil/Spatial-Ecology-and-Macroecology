
## Pre-process mammal range map rasters ##
rm(list=ls())

# These range maps come from the PHYLACINE database (you can download the "Data" folder from their online repository)
# The range maps are based on IUCN but were checked for the development of PHYLACINE. 
# The folder also has the phylogeny that we will be using for PART 2. 
# For simplicity, we will do our analysis on country-scale (.shp file). I will use the TDWG botanical country scale (level 3). 
# It mostly captures countries, but for very diverse countries, the country is divided into smaller regions that are individual botanical countries.


# Libraries ================
library(terra)
library(here)
library(sf)
library(dplyr)



# Set Folder Path ===========
here()
out_path <- here("data")

# Data ================

## Country-scale map
bot_v <- st_read(here("data_raw", "shp")) %>%
  vect()

## Species ranges
## !!!  Paste the Ranges folder from PHYLACINE into the data_raw folder for this to work !!!
mammals_path <- here("data_raw" ,"Ranges", "Current")
tif_files <- list.files(file.path(mammals_path), pattern = "\\.tif$", full.names = TRUE)

# =====================



# Extract occurrence in botanical countries ==============

# ## Read in .tif files with range maps to a raster stack
# r_mammals <- rast(tif_files)
# 
# ## Save to RDS for quicker use
# saveRDS(r_mammals, here(out_path, "mammals_rasterstack.rds"))
r_mammals <- readRDS(here(out_path, "mammals_rasterstack.rds"))

# unpack the geo pack:
r_mammals <- r_mammals %>% 
  unwrap()

## Check the coordinate reference system. They have to be the same (i.e., = TRUE)
crs(r_mammals) == crs(bot_v)

## They are not the same, so we have to project the botanical countries to the same CRS as the raster
bot_v2 <- terra::project(bot_v,r_mammals)
crs(r_mammals) == crs(bot_v2)
# plot(bot_v2)

# =====================


# Extract values =============

length(names(r_mammals)) # 5831 species

## Plot example range map
plot(r_mammals$Rattus_norvegicus)
plot(bot_v2, add=T)



## Save as df
# Initialize an empty dataframe
df_values <- data.frame()

# Use lapply and bind the results to the dataframe
df_values <- do.call(rbind, lapply(seq_along(names(r_mammals)), function(tax) {
  
  sp <- names(r_mammals)[tax] # species name
  print(sp)
  
  # Extract presence/absence from range maps on country scale
  v <- unique(terra::extract(r_mammals[[tax]], bot_v2, touches = TRUE))
  v$species <- names(v[2])
  names(v) <- c("LEVEL_3_ID", "presence", "species")
  head(v)
  
  # Convert 'v' to a dataframe and add the species name
  df <- as.data.frame(v)
  
  return(df)
  
}))

# Save and load
saveRDS(df_values, here(out_path, "extracted_values_mammals_df.rds"))
df_values <- readRDS(here(out_path, "extracted_values_mammals_df.rds")) %>% filter(presence != 0)

# Load phylogeny to reduce species to those of which
library(ape)
## !!!! Put the Phylogenies folder from PHYLACINE into the data_raw folder for this to work !!!!
sp_in_tree <- read.nexus(here("data_raw", "Phylogenies", "Small_phylogeny.nex"))$tip.labels
df_values2 <- df_values %>% 
  filter(species %in% sp_in_tree$tip.label)

bot_v3 <- bot_v2 %>% st_as_sf()

mammals_occu <- left_join(bot_v3, df_values2)

saveRDS(mammals_occu, here(out_path, "mammals_occu.rds"))

# =====================




# Plot the distribution maps 

plot(bot_v4)

# =====================

###########################

