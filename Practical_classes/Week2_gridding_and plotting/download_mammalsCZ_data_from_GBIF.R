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
#   Your download is being processed by GBIF:
#   https://www.gbif.org/occurrence/download/0010836-260928105237408
#   Most downloads finish within 15 min.
#   Check status with
#   occ_download_wait('0010836-260928105237408')
#   After it finishes, use
#   d <- occ_download_get('0010836-260928105237408') %>%
#     occ_download_import()
#   to retrieve your download.
# Download Info:
#   Username: # your gbif.org username 
#   E-mail: # your gbif.org email 
#   Format: SIMPLE_CSV
#   Download key: 0010836-260928105237408
#   Created: 2026-10-05T08:18:43.682+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
#   https://www.gbif.org/citation-guidelines
# DOI: 
#   Citation:
#   GBIF Occurrence Download https://www.gbif.org/occurrence/download/0010836-260928105237408 Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2026-10-05

# check the query status 
occ_download_wait('0010836-260928105237408') # USE THE NUMBER OF YOUR DOWNLOAD HERE (Download key)

# status: preparing
# status: running
# status: succeeded
# download is done, status: succeeded
# <<gbif download metadata>>
#   Status: SUCCEEDED
#   DOI: 10.15468/dl.zvnbsq
#   Format: SIMPLE_CSV
#   Download key: 0010836-260928105237408
#   Created: 2026-10-05T08:18:43.682+00:00
#   Modified: 2026-10-05T08:20:36.577+00:00
#   Download link: https://api.gbif.org/v1/occurrence/download/request/0010836-260928105237408.zip
#   Total records: 18532

# download the data 
data <- occ_download_get('0010836-260928105237408') %>% # USE THE NUMBER OF YOUR DOWNLOAD HERE
  occ_download_import()

# Download file size: 1.32 MB
# On disk at ./0010836-260928105237408.zip

# clean the data
data_clean <- data %>% 
  filter(taxonRank == "SPECIES") %>% 
  filter(basisOfRecord == "PRESERVED_SPECIMEN" |
           basisOfRecord == "HUMAN_OBSERVATION") %>% 
  filter(coordinateUncertaintyInMeters < 10000)

# save the data
saveRDS(data_clean, 
        'Practical_classes/Week2_gridding_and plotting/data/mammalsCZ.rds')
