# gbif data download
# occ_download() is the best way to get GBIF mediated occurrences

library(rgbif)
library(taxize)
library(sf)
library(tidyverse)

# variables
taxa <- 'Mammalia'
country_code <- 'CZ' 
taxon_key <- get_gbifid_(taxa) %>% # get a taxon_id for mammals
  bind_rows() %>% 
  filter(matchtype == 'EXACT' & status == 'ACCEPTED') %>% 
  pull(usagekey)

# set up your credentials (you will need a GBIF user)

GBIF_USER <- '' # your gbif.org username 
GBIF_PWD <- '' # your gbif.org password
GBIF_EMAIL <- '' # your email 

# generate a download
occ_download(
  pred('taxonKey', taxon_key),
  pred('country', country_code),
  pred('hasGeospatialIssue', FALSE),
  pred('hasCoordinate', TRUE),
  pred('occurrenceStatus','PRESENT'), 
  format = 'SIMPLE_CSV',
  user=GBIF_USER,pwd=GBIF_PWD,email=GBIF_EMAIL
)

# <<gbif download>>
# Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0044820-240906103802322
#   Most downloads finish within 15 min.
#   Check status with
#   occ_download_wait('0044820-240906103802322')
#   After it finishes, use
#   d <- occ_download_get('0044820-240906103802322') %>%
#     occ_download_import()
#   to retrieve your download.
# Download Info:
#   Username: # your gbif.org username 
#   E-mail: # your gbif.org email 
#   Format: SIMPLE_CSV
#   Download key: 0044820-240906103802322
#   Created: 2024-10-06T14:42:23.587+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
#   https://www.gbif.org/citation-guidelines
#   DOI: 10.15468/dl.a9fytb
#   Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.a9fytb Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-10-06

# check the query status
occ_download_wait('0044820-240906103802322')

# <<gbif download metadata>>
# Status: SUCCEEDED
# DOI: 10.15468/dl.a9fytb
# Format: SIMPLE_CSV
# Download key: 0044820-240906103802322
# Created: 2024-10-06T14:42:23.587+00:00
# Modified: 2024-10-06T14:43:08.387+00:00
# Download link: https://api.gbif.org/v1/occurrence/download/request/0044820-240906103802322.zip
# Total records: 7317

# download the data
data <- occ_download_get('0044820-240906103802322') %>%
  occ_download_import()

# clean the data
data_clean <- data %>% 
  filter(taxonRank == "SPECIES") %>% 
  filter(basisOfRecord == "PRESERVED_SPECIMEN" |
           basisOfRecord == "HUMAN_OBSERVATION") %>% 
  filter(coordinateUncertaintyInMeters < 10000)
  
# save the data
saveRDS(data_clean, 
        'Practical_classes/Week2_gridding_and plotting/data/mammalsCZ.rds') 


