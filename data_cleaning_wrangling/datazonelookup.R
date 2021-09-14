#--------------------------------------------------------------------------
# This script is to load the data zone look up file 
# and extract the distinct code & names.
#--------------------------------------------------------------------------

# Load library ------------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Read the Data zone look up -----------------------------------------------

data_zone_lookup <- read_csv(here("original_data/Datazone2011lookup.csv")) %>% clean_names()

# Data Cleaning -----------------------------------------------------------

#Convert the column datatype to character
data_zone_lookup$ur2_code <- as.character(data_zone_lookup$ur2_code)
data_zone_lookup$ur3_code <- as.character(data_zone_lookup$ur3_code)
data_zone_lookup$ur6_code <- as.character(data_zone_lookup$ur6_code)
data_zone_lookup$ur8_code <- as.character(data_zone_lookup$ur8_code)

#Pivot all the code and names to generate distinct code and names

data_zone_lookup_code_names <- data_zone_lookup %>% 
  pivot_longer(cols = dz2011_code:country_name,
               names_to = c("type", ".value"),
               names_pattern = "(.+)_(.+)"
  ) %>% 
  distinct()

# End of code -------------------------------------------------------------