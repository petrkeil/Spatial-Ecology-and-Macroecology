# save trees shapefiles as gpkg

pacman::p_load(fs)
pacman::p_load(sf)
sf_use_s2(F)
pacman::p_load(tidyverse)

folder_path <- 'Practical_classes/Week2_gridding_and plotting/big_data/trees/chorological_maps_dataset'

# I will only keep polygons

for(file in (fs::dir_ls(folder_path))){
  sp <- stringr::word(file, sep = '/', 6)
  shp_file <- fs::dir_ls(stringr::str_glue('{file}/shapefiles/'), 
                         glob = '*_plg.shp$')
  shp_file <- shp_file[stringr::str_detect(shp_file, 'syn_plg', negate = TRUE)]
  if (length(shp_file) > 0) {
    shp_file_to_save <- sf::read_sf(shp_file[1])
  }
  layer_name <- stringr::str_replace(sp, ' ', '_')
  sf::st_write(shp_file_to_save, 
           dsn='Practical_classes/Week2_gridding_and plotting/big_data/gpkg_trees.gpkg', 
           layer= layer_name, 
           append=FALSE)
}

# check the layers
sf::st_layers('Practical_classes/Week2_gridding_and plotting/big_data/gpkg_trees.gpkg')

# read one layer
sf::read_sf('Practical_classes/Week2_gridding_and plotting/big_data/gpkg_trees.gpkg') 

#################################
# Now, merge all layers into one single file

# Specify the path to your GeoPackage file
gpkg_path <- 'Practical_classes/Week2_gridding_and plotting/big_data/gpkg_trees.gpkg'

# Get the list of all layer names in the GeoPackage
layer_names <- sf::st_layers(gpkg_file)$name

# Read each layer and store them in a list of sf objects
sf_list <- lapply(layer_names, function(layer) {
  sf_object <- sf::st_read(gpkg_path, layer = layer)
  
  sf_aggregated <- sf_object %>%
    summarize(geometry = st_union(geom)) %>%
    mutate(layer_name = layer)  # Add layer name as a new column
  
  return(sf_aggregated)
})

# Combine all layers into a single sf object
merged_sf <- bind_rows(sf_list) %>% st_cast()

sf::st_write(merged_sf, 
             dsn='Practical_classes/Week2_gridding_and plotting/trees.gpkg', 
             delete_dsn = TRUE)

trees <- read_sf('Practical_classes/Week2_gridding_and plotting/trees.gpkg')
