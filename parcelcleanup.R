library(foreign)
library(tidyverse)
library(readr)
library(readxl)

parcels <- read.dbf("H:/PPUA GIS/Final Project/TODParcelswithLUCDefinitions.dbf")

names(parcels)

LUCnonBoston <- parcels %>% 
  select(LOC_ID,USE_CODE,USE_DESC,YEAR_BUILT,FY,UNITS) %>%
  group_by(USE_CODE,USE_DESC) %>%
  summarise(ParcelCOUNT = n()) %>%
  arrange(USE_CODE)

View(LUCnonBoston)
parcels$USE_CODE[parcels$USE_CODE=='1010'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='1040'] <- '104'
parcels$USE_CODE[parcels$USE_CODE=='1050'] <- '105'
parcels$USE_CODE[parcels$USE_CODE=='1320'] <- '132'
parcels$USE_CODE[parcels$USE_CODE=='1020'] <- '102'
parcels$USE_CODE[parcels$USE_CODE=='1110'] <- '111'
parcels$USE_CODE[parcels$USE_CODE=='1120'] <- '112'
parcels$USE_CODE[parcels$USE_CODE=='1090'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1310'] <- '131'
parcels$USE_CODE[parcels$USE_CODE=='131V'] <- '131'

parcels$USE_CODE[parcels$USE_DESC=='Accessory Land with Improvement'] <- '106'
parcels$USE_CODE[parcels$USE_DESC=='Apartments with More than Eight Units Residential'] <- '112'
parcels$USE_CODE[parcels$USE_DESC=='Apartments, More than 8 units'] <- '112'
parcels$USE_CODE[parcels$USE_DESC=='Apartments, 4 to 8 units'] <- '111'
parcels$USE_CODE[parcels$USE_DESC=='APT 4-8 UN MDL R'] <- '111'
parcels$USE_CODE[parcels$USE_CODE=='1111'] <- '111'
parcels$USE_CODE[parcels$USE_CODE=='111C'] <- '111'
parcels$USE_CODE[parcels$USE_DESC=='Apt Subsidized R'] <- '111'

parcels$USE_CODE <- gsub("[^0-9]","",parcels$USE_CODE)                                   

parcels$USE_CODE[parcels$USE_CODE=='0101'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='0102'] <- '102'
parcels$USE_CODE[parcels$USE_CODE=='0104'] <- '104'
parcels$USE_CODE[parcels$USE_CODE=='0105'] <- '105'
parcels$USE_CODE[parcels$USE_CODE=='0111'] <- '111'
parcels$USE_CODE[parcels$USE_CODE=='0112'] <- '112'
parcels$USE_CODE[parcels$USE_CODE=='0130'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='0134'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='0139'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='0139'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='012'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='014'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='016'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='017'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='018'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='0180'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='019'] <- '013'
parcels$USE_CODE[parcels$USE_CODE=='0193'] <- '013'

parcels$USE_CODE[parcels$USE_CODE=='1012'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='1013'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='1014'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='1015'] <- '101'
parcels$USE_CODE[parcels$USE_CODE=='1021'] <- '102'
parcels$USE_CODE[parcels$USE_CODE=='1029'] <- '102'
parcels$USE_CODE[parcels$USE_CODE=='1030'] <- '103'
parcels$USE_CODE[parcels$USE_CODE=='1043'] <- '104'
parcels$USE_CODE[parcels$USE_CODE=='1045'] <- '104'
parcels$USE_CODE[parcels$USE_CODE=='1062'] <- '106'
parcels$USE_CODE[parcels$USE_CODE=='1063'] <- '106'
parcels$USE_CODE[parcels$USE_CODE=='1091'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1092'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1093'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1094'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1095'] <- '109'
parcels$USE_CODE[parcels$USE_CODE=='1121'] <- '112'
parcels$USE_CODE[parcels$USE_CODE=='1140'] <- '114'
parcels$USE_CODE[parcels$USE_CODE=='1210'] <- '121'
parcels$USE_CODE[parcels$USE_CODE=='1230'] <- '123'
parcels$USE_CODE[parcels$USE_CODE=='1250'] <- '125'
parcels$USE_CODE[parcels$USE_CODE=='1252'] <- '125'
parcels$USE_CODE[parcels$USE_CODE=='1300'] <- '130'
parcels$USE_CODE[parcels$USE_CODE=='1322'] <- '132'


usecodedesc <- read_xlsx("H:/PPUA GIS/Final Project/ResLUCbook.xlsx")
parcels <- parcels %>% 
  select(LOC_ID,USE_CODE,USE_DESC,YEAR_BUILT,FY,UNITS) %>%
  left_join(usecodedesc, by = c("USE_CODE" = "LUC"))
View(parcels)

write.csv(parcels, "standardizedparcels.csv")

