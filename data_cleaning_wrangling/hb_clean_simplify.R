#-------------------------------------------------------------------------------
#Paddy Hudson
#This script is to load, clean and simplify the health board spatial data.
#-------------------------------------------------------------------------------
library(sf)
library(tidyverse)
library(here)
library(janitor)

#read the shapefile and clean column names

hb_zones <- read_sf(here("original_data/healthboards2019/SG_NHS_HealthBoards_2019.shp")) %>% 
  clean_names()

#Transform the projection to match leaflet() requirements
#Then simplify geometries for quicker mapping
#NB do not use these simplified geometries for analysis

hb_zones <- hb_zones %>% 
  st_transform('+proj=longlat +datum=WGS84') %>% 
  mutate(geometry = st_simplify(geometry, dTolerance = 500)) %>% 
  rename(name = hb_name, code = hb_code)

#Use this code to save the output in a new file.  Remember to specify filepath

hb_zones %>% st_write(here("clean_data/hb_zones/hb_zones_simple.shp"), append = FALSE)
