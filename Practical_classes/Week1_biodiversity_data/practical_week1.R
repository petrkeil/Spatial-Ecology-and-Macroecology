install.packages('tidyverse')
install.packages('rgbif')
install.packages('taxize')

# Libraries

library(taxize)
library(rgbif)
library(tidyverse)

##### Data Download

# get the taxon ID for the *Mammalia* class
get_gbifid_('Mammalia') 

mammaliaTaxonKey <- get_gbifid_('Mammalia') %>% bind_rows() %>% 
  filter(matchtype == 'EXACT' & status == 'ACCEPTED') %>%
  pull(usagekey)


# How many occurrence records are in GBIF for the entire **Czech Republic**?
occ_count(country='CZ') # country code for Czech Republic (https://countrycode.org/)

# And how many records for the **mammals** of Czech Republic?
occ_count(country='CZ', 
          taxonKey=mammaliaTaxonKey) 

# Get occurrences records of mammals from Czech Republic
occ_search(taxonKey=mammaliaTaxonKey, 
           country='CZ') 

# Get **all** occurrences records of mammals from Czech Republic.
occ_search(taxonKey=mammaliaTaxonKey,
           country='CZ',
           limit=6000) 

# store the result in the object `mammalsCZ`
mammalsCZ <- occ_search(taxonKey=mammaliaTaxonKey,
                        country='CZ',
                        limit=6000) 

mammalsCZ <- mammalsCZ$data

# How many records do we have?
nrow(mammalsCZ)

# How many species do we have?
mammalsCZ %>% 
  filter(taxonRank=='SPECIES') %>% 
  distinct(scientificName) %>% nrow()


##### Data Quality

# check `basisOfRecord`: we want preserved specimens or observations

mammalsCZ %>% distinct(basisOfRecord)
mammalsCZ %>% group_by(basisOfRecord) %>% count()
mammalsCZ <- mammalsCZ %>% 
  filter(basisOfRecord=='PRESERVED_SPECIMEN' |
           basisOfRecord=='HUMAN_OBSERVATION')

# How many records do we have now?
nrow(mammalsCZ)

# check `taxonRank`: we want records at species level

mammalsCZ %>% distinct(taxonRank)
mammalsCZ <- mammalsCZ %>% 
  filter(taxonRank == 'SPECIES')

# How many records do we have now?
nrow(mammalsCZ)


# Check `coordinateUncertaintyInMeters`: we want them to be smaller than 10km
mammalsCZ %>% 
  filter(coordinateUncertaintyInMeters > 10000) %>% # 10000 meters = 10km
  select(scientificName, coordinateUncertaintyInMeters, stateProvince)

mammalsCZ <- mammalsCZ %>% 
  filter(coordinateUncertaintyInMeters < 10000) # keeping this

# How many records do we have now?
nrow(mammalsCZ)
