library(foreign)
library(tidyverse)
library(readr)
library(readxl)
library(stringr)

WestHingham <- read.dbf("H:/PPUA GIS/Final Project/WestHinghamStation.dbf")
EastWeymouth <- read.dbf("H:/PPUA GIS/Final Project/EastWeymouthStation.dbf")
NantasketJunction <- read.dbf("H:/PPUA GIS/Final Project/NantasketJunctionStation.dbf")
Cohasset <- read.dbf("H:/PPUA GIS/Final Project/CohassetStation.dbf")
NorthScituate <- read.dbf("H:/PPUA GIS/Final Project/NorthScituateStation.dbf")
Greenbush <- read.dbf("H:/PPUA GIS/Final Project/GreenbushStation.dbf")

WestHingham <- WestHingham %>% filter(LUCDesc != 'NA')
EastWeymouth <- EastWeymouth %>% filter(LUCDesc != 'NA')
NantasketJunction <- NantasketJunction %>% filter(LUCDesc != 'NA')
Cohasset <- Cohasset %>% filter(LUCDesc != 'NA')
NorthScituate <- NorthScituate %>% filter(LUCDesc != 'NA')
Greenbush <- Greenbush %>% filter(LUCDesc != 'NA')
unique(EastWeymouth$LUCDesc)
WestHingham$LUCDesc <- factor(x=WestHingham$LUCDesc, levels = c(
  'Single Family Home',  'Multiple homes on one parcel',  'Two-Family Home',
  'Three-Family Home',  'Apartments - 4 to 8 units','Apartments - over 8 units',  'Condo',  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',  'Developable Residential Land',  'Undevelopable Residential Land'
))
NantasketJunction$LUCDesc <- factor(x=NantasketJunction$LUCDesc, levels = c(
  'Single Family Home',  'Multiple homes on one parcel',  'Two-Family Home',
  'Three-Family Home',  'Apartments - 4 to 8 units','Apartments - over 8 units',  'Condo',  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',  'Developable Residential Land',  'Undevelopable Residential Land'
))
Cohasset$LUCDesc <- factor(x=Cohasset$LUCDesc, levels = c(
  'Single Family Home',  'Multiple homes on one parcel',  'Two-Family Home',
  'Three-Family Home',  'Apartments - 4 to 8 units','Apartments - over 8 units',  'Condo',  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',  'Developable Residential Land',  'Undevelopable Residential Land'
))
NorthScituate$LUCDesc <- factor(x=NorthScituate$LUCDesc, levels = c(
  'Single Family Home',  'Multiple homes on one parcel',  'Two-Family Home',
  'Three-Family Home',  'Apartments - 4 to 8 units','Apartments - over 8 units',  'Condo',  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',  'Developable Residential Land',  'Undevelopable Residential Land'
))
Greenbush$LUCDesc <- factor(x=Greenbush$LUCDesc, levels = c(
  'Single Family Home',  'Multiple homes on one parcel',  'Two-Family Home',
  'Three-Family Home',  'Apartments - 4 to 8 units','Apartments - over 8 units',  'Condo',  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',  'Developable Residential Land',  'Undevelopable Residential Land'
))

EastWeymouth$LUCDesc <- factor(x=EastWeymouth$LUCDesc, levels = c(
  'Single Family Home',
  'Multiple homes on one parcel',
  'Two-Family Home',
  'Three-Family Home',
  'Apartments - 4 to 8 units',
  'Apartments - over 8 units',
  'Condo',
  'Mixed Use - Primarily Residential',
  'Potentially Developable Residential Land',
  'Developable Residential Land',
  'Undevelopable Residential Land'
))

View(subset(NorthScituate, `UNITS` == 0 & !(LUCDesc %in% c("Developable Residential Land","Potentially Developable Residential Land", "Undevelopable Residential Land"))))


WHinghamChart <- ggplot(subset(WestHingham,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("WHingham.png", 
       plot = WHinghamChart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)

View(EastWeymouth)
Greenbush %>% group_by(LUCDesc) %>%
  summarise(unittotal = sum(UNITS))

EWeymouthChart <- ggplot(subset(EastWeymouth,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("EWeymouth.png", 
       plot = EWeymouthChart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)


NantasketChart <- ggplot(subset(NantasketJunction,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("Nantasket.png", 
       plot = NantasketChart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)



CohassetChart <- ggplot(subset(Cohasset,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("Cohasset.png", 
       plot = CohassetChart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)

NScituateChart <- ggplot(subset(NorthScituate,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("NScituate.png", 
       plot = NScituateChart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)

Greenbushchart <- ggplot(subset(Greenbush,!(LUCDesc %in% c("Undevelopable Residential Land","Developable Residential Land","Potentially Developable Residential Land")))) +
  geom_bar(aes(x=LUCDesc, y = UNITS, fill = LUCDesc), stat = "identity")+
  scale_y_discrete(expand = c(0,0))+
  scale_x_discrete(labels = function(x) str_wrap(x, width=25))+
  scale_fill_manual(values = c('Single Family Home' = "#ffff99",
                               'Multiple homes on one parcel' = "#ffff80",
                               'Two-Family Home' = "#ffff1a",
                               'Three-Family Home' = "#ffb31a",
                               'Apartments - 4 to 8 units' = "#ff3300",
                               'Apartments - over 8 units' = "#990000",
                               'Condo' = "#ff6600",
                               'Mixed Use - Primarily Residential' = "#ff944d"))+
  theme_bw()+
  ggtitle("Units by building type")+
  theme(
    axis.text.x = element_text(angle=90),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    axis.title = element_blank()
  )

ggsave("Greenbush.png", 
       plot = Greenbushchart, 
       width = 2.5, height = 3.7, 
       units = "in", # other options c("in", "cm", "mm"), 
       dpi = 300)



ggplot()+
  geom_density(data = subset(EastWeymouth, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")+
  geom_density(data = subset(NorthScituate, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")+
  geom_density(data = subset(Cohasset, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")+
  geom_density(data = subset(NantasketJunction, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")+
  geom_density(data = subset(WestHingham, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")+
  geom_density(data = subset(EastWeymouth, YEAR_BUILT !=0),aes(x=YEAR_BUILT), fill = "yellow2", alpha = 0.5, color = "black")
