library(foreign)
library(tidyverse)
library(readr)
library(readxl)
library(scales)

TODresparcels <- read.dbf("H:/PPUA GIS/Final Project/TODParcels_ResOnly_WholeSystem.dbf")

TODresparcels<- TODresparcels %>% select(LOC_ID_12, USE_CODE_1,USE_DESC_1,YEAR_BUI_1,FY_1,UNITS_1,LUCDesc_1,LINE_BRNCH,STATION)


subset(TODresparcels,UNITS_1 != 1 & LUCDesc_1 == 'Single Family Home')

####Cleaning up the single family home records###
#starting with SFR with 0 units, making assumption that it is one home
subset(TODresparcels,UNITS_1 == 0 & LUCDesc_1 == 'Single Family Home')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 == 0 & TODresparcels$LUCDesc_1 == 'Single Family Home')] <- 1
#For SFR records with more than one unit, assuming that these records represent multiple homes on one parcel, so recoding the use codes
subset(TODresparcels,UNITS_1 != 1 & LUCDesc_1 == 'Single Family Home')
TODresparcels$LUCDesc_1[which(TODresparcels$UNITS_1 > 1 & TODresparcels$LUCDesc_1 == 'Single Family Home')] <- 'Multiple homes on one parcel'

####Cleaning up the two-family records####
#if a parcel assessed as 2-fam has fewer than two units, I am assuming it is an error and correcting it to two units
#if a parcel assessed as 2-fam has more than two units, I am assuming there are multiple homes on the parcel and leaving it alone
subset(TODresparcels,UNITS_1 != 2 & LUCDesc_1 == 'Two-Family Home')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 < 2 & TODresparcels$LUCDesc_1 == 'Two-Family Home')] <- 2

####Cleaning up the three-family records####
#if a parcel assessed as 3-fam has fewer than three units, I am assuming it is an error and correcting it to three units
#if a parcel assessed as 3-fam has more than three units, I am assuming there are multiple homes on the parcel and leaving it alone
subset(TODresparcels,UNITS_1 != 3 & LUCDesc_1 == 'Three-Family Home')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 < 3 & TODresparcels$LUCDesc_1 == 'Three-Family Home')] <- 3

####Cleaning up the 4-8 unit records####
#if a parcel assessed as 4-8 units has fewer than four units, I am assuming it is an error and correcting it to the minimum of 4 units
subset(TODresparcels,UNITS_1 < 4 & LUCDesc_1 == 'Apartments - 4 to 8 units')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 < 4 & TODresparcels$LUCDesc_1 == 'Apartments - 4 to 8 units')] <- 4

####Cleaning up the 8+ unit records####
#if a parcel assessed as 4-8 units has fewer than four units, I am assuming it is an error and correcting it to the minimum of 9 units
subset(TODresparcels,UNITS_1 < 9 & LUCDesc_1 == 'Apartments - over 8 units')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 < 9 & TODresparcels$LUCDesc_1 == 'Apartments - over 8 units')] <- 9


####Cleaning up condos####
#if a parcel assessed as condo, but has a unit value of zero, I am assuming it has a unit of 1
subset(TODresparcels,UNITS_1 ==0 & LUCDesc_1 == 'Condo')
TODresparcels$UNITS_1[which(TODresparcels$UNITS_1 == 0 & TODresparcels$LUCDesc_1 == 'Condo')] <- 1


#Summary table
TODparcelunitsummary <- TODresparcels %>% group_by(LUCDesc_1) %>% summarise(count = n(), totalunits = sum(UNITS_1)) %>% arrange(-totalunits)
TODparcelunitsummary$LUCDesc_1 <- factor(TODparcelunitsummary$LUCDesc_1,levels = c('Single Family Home',
                                                                                   'Two-Family Home',
                                                                                   'Three-Family Home',
                                                                                   'Apartments - 4 to 8 units', 
                                                                                   'Apartments - over 8 units',
                                                                                   'Mixed Use - Primarily Residential',
                                                                                   'Condo',
                                                                                   'Multiple homes on one parcel',
                                                                                   'Mobile Home'))

plot2 <- ggplot(TODparcelunitsummary)+
  geom_bar(aes(x=LUCDesc_1, y = totalunits), stat = "identity", fill = "aquamarine3")+
  geom_text(aes(x=LUCDesc_1, y = totalunits+2000, label = comma(totalunits)))+
  scale_y_continuous(expand = c(0,0),
                     label = comma,
                     limits = c(0,55000))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=15))+
  ggtitle("TOD residential parcels by housing type (parcels within 0.25 miles of commuter rail station - Boston excluded)")+
  ylab("total units")+
  theme_bw()+
  theme(
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    axis.title.x = element_blank()
  )

unique(TODresparcels$LUCDesc_1)
stationsbyunits <- TODresparcels %>% group_by(STATION) %>% summarize(totalunits = sum(UNITS_1))
TODresparcels$STATION <- factor(TODresparcels$STATION, levels = stationsbyunits$STATION)

TODresparcels <- TODresparcels %>% 
  left_join(stationsbyunits, by = c("STATION" = "STATION"))


TODresparcels <- TODresparcels %>% arrange(totalunits)
TODresparcels$STATION <- factor(TODresparcels$STATION, 
                                levels = unique(TODresparcels$STATION[order(TODresparcels$totalunits)]),ordered = TRUE)

TODresparcels$LUCDesc_1 <- factor(x=TODresparcels$LUCDesc_1, levels = c(
  'Mobile Home',
  'Single Family Home',
  'Multiple homes on one parcel',
  'Two-Family Home',
  'Three-Family Home',
  'Mixed Use - Primarily Residential',
  'Condo',
  'Apartments - 4 to 8 units',
  'Apartments - over 8 units'
))


ggplot(subset(TODresparcels,YEAR_BUI_1 !=0))+
  geom_bar(aes(x=YEAR_BUI_1, y = UNITS_1), stat = "identity")

ggplot(arrange(TODresparcels,desc(totalunits)))+
  geom_bar(aes(x=STATION, y = UNITS_1, fill = LUCDesc_1), 
           stat = "identity",
           width = 1)+
  theme_bw()+
  ylab("housing units within 1/4 mile")+
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values = c('Single Family Home' = "#edf8b1",
                               'Multiple homes on one parcel' = "#c7e9b4",
                               'Two-Family Home' = "#B8E1C0",
                               'Three-Family Home' = "#7fcdbb",
                               'Apartments - 4 to 8 units' = "#253494",
                               'Apartments - over 8 units' = "#081d58",
                               'Condo' = "#225ea8",
                               'Mixed Use - Primarily Residential' = "#1d91c0",
                               'Mobile Home' = "#ffffd9"))+
  theme(
    legend.position = c(0.3,0.6),
    legend.title = element_blank(),
    axis.text = element_text(size = 5, angle = 90),
    panel.border = element_blank()
  )

write.csv(TODresparcels,"test.csv")

ggsave("allstationsbar.png", 
       plot = plot1, 
       width = 10, height = 6, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)


ggsave("summary.png", 
       plot = plot2, 
       width = 10, height = 6, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)

#scale_fill_manual(values = c('Single Family Home' = "#ffff99",
 #                            'Multiple homes on one parcel' = "#ffff80",
  #                           'Two-Family Home' = "#f4f141",
   #                          'Three-Family Home' = "#f4d341",
  #                           'Apartments - 4 to 8 units' = "#ff3300",
   #                          'Apartments - over 8 units' = "#990000",
    #                         'Condo' = "#ff6600",
     #                        'Mixed Use - Primarily Residential' = "#ff944d",
      #                       'Mobile Home' = "blue"))+