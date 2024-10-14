# gbif data download
# occ_download() is the best way to get GBIF mediated occurrences

library(rgbif)
library(taxize)
library(sf)
library(tidyverse)

# variables
taxa <- 'Amphibia'
country_code <- 'PE' 
taxon_key <- get_gbifid_(taxa) %>% # get a taxon_id for mammals
  bind_rows() %>% 
  filter(matchtype == 'EXACT' & status == 'ACCEPTED') %>% 
  pull(usagekey)

# set up your credentials (you will need a GBIF user)

GBIF_USER <- 'florencia_grattarola' # your gbif.org username 
GBIF_PWD <- 'naFvez-modjir-dovpu1' # your gbif.org password
GBIF_EMAIL <- 'flograttarola@gmail.com' # your email 

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
#   https://www.gbif.org/occurrence/download/0011679-241007104925546
#   Most downloads finish within 15 min.
#   Check status with
#   occ_download_wait('0011679-241007104925546')
#   After it finishes, use
#   d <- occ_download_get('0011679-241007104925546') %>%
#     occ_download_import()
#   to retrieve your download.
# Download Info:
#   Username: #### your gbif.org username 
#   E-mail: #### your email  
#   Format: SIMPLE_CSV
#   Download key: 0011679-241007104925546
#   Created: 2024-10-13T11:39:39.902+00:00
# Citation Info:  
#   Please always cite the download DOI when using this data.
# https://www.gbif.org/citation-guidelines
# DOI: 10.15468/dl.9e9fjn
# Citation:
#   GBIF Occurrence Download https://doi.org/10.15468/dl.9e9fjn Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2024-10-13

# check the query status
occ_download_wait('0011679-241007104925546')

# <<gbif download metadata>>
#   Status: SUCCEEDED
#   DOI: 10.15468/dl.9e9fjn
#   Format: SIMPLE_CSV
#   Download key: 0011679-241007104925546
#   Created: 2024-10-13T11:39:39.902+00:00
#   Modified: 2024-10-13T11:40:52.882+00:00
#   Download link: https://api.gbif.org/v1/occurrence/download/request/0011679-241007104925546.zip
#   Total records: 36264

# download the data
data <- occ_download_get('0011679-241007104925546') %>%
  occ_download_import()

# clean the data
data_clean <- data %>% 
  filter(taxonRank == 'SPECIES') %>% 
  filter(occurrenceStatus == 'PRESENT') %>% 
  filter(basisOfRecord == 'PRESERVED_SPECIMEN' |
           basisOfRecord == 'HUMAN_OBSERVATION') %>% 
  filter(coordinateUncertaintyInMeters < 25000) %>% # 25km
  filter(!is.na(year) & year>2000)
  
# save the data
saveRDS(data_clean, 
        'Practical_classes/Week3_predictors/data/amphibiansPE.rds') 


