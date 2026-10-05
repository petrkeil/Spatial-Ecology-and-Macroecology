# gbif data download
# occ_download() is the best way to download data from GBIF

library(rgbif)
library(taxize)
library(sf)
library(tidyverse)

# variables
taxa <- 'Mammalia'
country_code <- 'CZ' 
taxon_key <- get_gbifid_(taxa) %>% # get a taxon_id for mammals
  bind_rows() %>% 
  filter(matchtype == 'HIGHERRANK' & status == 'ACCEPTED') %>% 
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
#   Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0040070-250920141307145
#   Most downloads finish within 15 min.
#   Check status with
#   occ_download_wait('0040070-250920141307145')
#   After it finishes, use
#   d <- occ_download_get('0040070-250920141307145') %>%
#     occ_download_import()
#   to retrieve your download.
# Download Info:
#   Username: # your gbif.org username 
#   E-mail: # your gbif.org email 
#   Format: SIMPLE_CSV
#   Download key: 0040070-250920141307145
#   Created: 2025-10-02T13:42:01.349+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
#   https://www.gbif.org/citation-guidelines
#   DOI: 
#   Citation:
#   GBIF Occurrence Download https://www.gbif.org/occurrence/download/0040070-250920141307145 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2025-10-02

# check the query status # USE THE NUMBER OF YOUR DOWNLOAD HERE
occ_download_wait('0040070-250920141307145') 

# status: preparing
# status: running
# status: succeeded
# download is done, status: succeeded
# <<gbif download metadata>>
#   Status: SUCCEEDED
#   DOI: 10.15468/dl.uwa52s
#   Format: SIMPLE_CSV
#   Download key: 0040070-250920141307145
#   Created: 2025-10-02T13:42:01.349+00:00
#   Modified: 2025-10-02T13:46:06.180+00:00
#   Download link: https://api.gbif.org/v1/occurrence/download/request/0040070-250920141307145.zip
# Total records: 14907

# download the data # USE THE NUMBER OF YOUR DOWNLOAD HERE
data <- occ_download_get('0040070-250920141307145') %>% 
  occ_download_import()

# Download file size: 1.04 MB
# On disk at ./0040070-250920141307145.zip

# clean the data
data_clean <- data %>% 
  filter(taxonRank == "SPECIES") %>% 
  filter(basisOfRecord == "PRESERVED_SPECIMEN" |
           basisOfRecord == "HUMAN_OBSERVATION") %>% 
  filter(coordinateUncertaintyInMeters < 10000)
  
# save the data
saveRDS(data_clean, 
        'Practical_classes/Week2_gridding_and plotting/data/mammalsCZ.rds')