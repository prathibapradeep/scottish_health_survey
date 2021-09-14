#-------------------------------------------------------------------------------
#Paddy Hudson
#This script is to load, clean and simplify the Local Authority spatial data.
#-------------------------------------------------------------------------------
library(sf)
library(tidyverse)
library(here)
library(janitor)

#read the shapefile and clean column names

la_zones <- read_sf(here("original_data/localauthorityboundaries/pub_las.shp")) %>% 
  clean_names()

#Transform the projection to match leaflet() requirements
#Then simplify geometries for quicker mapping
#NB do not use these simplified geometries for analysis

la_zones <- la_zones %>% 
  st_transform('+proj=longlat +datum=WGS84') %>% 
  mutate(geometry = st_simplify(st_make_valid(geometry), dTolerance = 500)) %>% 
  rename(name = local_auth)

#Use this code to save the output in a new file.  Remember to specify filepath

la_zones %>% st_write(here("clean_data/la_zones/la_zones_simple.shp"), append = FALSE)