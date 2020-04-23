library("plyr") 
library("readr")
library("data.table")  
library("tidyverse")  
library("httr")  
library("jsonlite")
library("tidylog", warn.conflicts = FALSE)

# read in file containing 2 columns: SNOMED ECL expressions, description
#healthCat <- read_csv(file="comorbSNOMED.csv")
healthCat <- read_csv(file="complSNOMED.csv")

## read in latest SNOMED (UK+Int) RF2 files for mapping conceptID to descriptionID
ref <- fread("H:/My Documents/Data/Lookup tables/SnomedCT_InternationalRF2_PRODUCTION_20180731T120000Z/Snapshot/Terminology/sct2_Description_Snapshot-en_INT_20180731.txt", sep= "\t", select = c("id", "conceptId","term"))
#We are only reading in the descriptionId, conceptID and read-able explaination of the code
names(ref)[names(ref) == "id"] <- "descriptionId"

### Define function: Get SNOMED ECL query results (conceptIDs) from SNOWSTORM. Match to RF2 files to get decriptionIDs. Join conceptIDs  
ecl_to_descIDs <- function(ecl){
  df <- URLencode(paste("https://browser.ihtsdotools.org/snowstorm/snomed-ct/MAIN/SNOMEDCT-GB/concepts?limit=10000&ecl=", ecl)) %>%
    GET(url = .) %>%
    content(., as = "text", encoding = "UTF-8") %>%
    fromJSON(.,flatten = TRUE)
  ecl_conceptId <- data.frame(conceptId = c(df$items$conceptId))
  ecl_descriptionID <- join(ecl_conceptId, ref, by = "conceptId", type = "inner")
  names(ecl_conceptId)[names(ecl_conceptId) == "conceptId"] <- "descriptionId"
  return(join(ecl_conceptId, ecl_descriptionID['descriptionId'],type='full'))
}

# Define function: Run through comorbidities file and pull out all SNOMED description IDs + concept IDs from ECL query
# Loop through ECLs and save as csv
for(i in 1:43){
  matched <- ecl_to_descIDs(healthCat$ECL[i])
  a <- healthCat[i,'description']
  names(matched) <- a
  write.csv(matched, file = paste0(a,".csv"), row.names = FALSE)
} 