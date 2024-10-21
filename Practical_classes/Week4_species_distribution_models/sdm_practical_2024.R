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

# 2.2 Rename bioclim data (if needed)

# 2.3 Plot examples

# 2.4 Convert everything to raster::stack

# 2.5 Detect and remove collinear variables


# 3. Get Presence-Absence data ####

# 3.1 Download data from GBIF, we can use dismo::gbif

# 3.2 Select only the columns you need

# 3.3 Coerce the dataframe to a spatial object

# 3.4 Clean occurrence records with CoordinateCleaner

# 3.5 Remove duplicated occurrences

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

