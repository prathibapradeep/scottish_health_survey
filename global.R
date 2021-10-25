#--------------------------------------------------------------------------#
# An app to analyse the Scottish Health Data                               #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version                          #
#--------------------------------------------------------------------------#

library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(dashboardthemes)
library(shinyBS)
library(hover)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(sf)
library(leaflet)
library(DT)
library(here)
library(tidyverse)
library(janitor)

# Load the clean data
source (here("data_cleaning_wrangling/life_expectancy.R"))
source (here("data_cleaning_wrangling/smoking.R"))
source (here("data_cleaning_wrangling/sdmd_by_council_area_and_demographic.R"))
#load spatial data
hb_zones <- read_sf(here("clean_data/hb_zones/hb_zones_simple.shp"))
la_zones <- read_sf(here("clean_data/la_zones/la_zones_simple.shp"))

# Load the helper file data
source(here("R/helper.R"))
source(here("R/plotting_functions.R"))
source(here("R/filtering_functions.R"))