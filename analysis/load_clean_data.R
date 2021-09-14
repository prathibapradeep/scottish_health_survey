library(here)
library(tidyverse)
library(sf)

source (here("data_cleaning_wrangling/life_expectancy.R"))
source (here("data_cleaning_wrangling/smoking.R"))
source (here("data_cleaning_wrangling/sdmd_by_council_area_and_demographic.R"))
#load spatial data
hb_zones <- read_sf(here("clean_data/hb_zones/hb_zones_simple.shp"))
la_zones <- read_sf(here("clean_data/la_zones/la_zones_simple.shp"))