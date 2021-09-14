#--------------------------------------------------------------------------
# This script is to load and clean the Scottish Drug Misuse Database data.
#--------------------------------------------------------------------------

# cleaned by Derek H

# Information on the number of individuals presenting for assessment at specialist drug
# treatment services in Scotland presented at council area and health board levels,
# broken down by age and sex.

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

# Read in the data files and clean names ---------------------------------------

source(here("data_cleaning_wrangling/datazonelookup.R"))

# local authority-level data
sdmd_by_ca_and_demo_clean <-
  read_csv(here("original_data/sdmd_by_council_area_and_demographics.csv")) %>%
  clean_names()

# health board-level data
sdmd_by_hb_and_demo_clean <-
  read_csv(here("original_data/sdmd_by_health_board_and_demographics.csv")) %>%
  clean_names()

# Data Cleaning -----------------------------------------------------------

# rename the 'ca' (from the local authority-level data) and 'hbr' (from the health
# board-level data) variables to 'feature_code' to enable joining.
# remove qualifier variables ('caqf' and 'hbrqf') as not required for joining or analysis.
sdmd_by_ca_and_demo_clean <- sdmd_by_ca_and_demo_clean %>%
  rename(feature_code = ca) %>%
  select(-caqf)

sdmd_by_hb_and_demo_clean <- sdmd_by_hb_and_demo_clean %>%
  rename(feature_code = hbr) %>%
  select(-hbrqf)

# join both sdmd datasets to create one showing data for both local authorities
# and health boards
sdmd_combined_clean <-
bind_rows(sdmd_by_ca_and_demo_clean, sdmd_by_hb_and_demo_clean)


# join combined sdmd dataset with 'data_zone_lookup_code' dataset
sdmd_combined_plus_zones <- sdmd_combined_clean %>%
  left_join(data_zone_lookup_code_names, by = c("feature_code" = "code")) %>%
  # rename variables to match data sets for other priority areas
  rename(year = financial_year, age = age_group) %>%
  # select relevant variables
  select(feature_code, name, type, year, age, sex, number_assessed) %>%
  # recode type column
  mutate(type = recode(type,
                       "la" = "Local Authority",
                       "hb" = "NHS Health Board",
                       "country" = "Scotland",
                       "spc" = "Scottish Parliamentary Constituencies"
  ))

#set age factors
sdmd_combined_plus_zones <- sdmd_combined_plus_zones %>% 
  mutate(age = recode(age, "Under 20yrs old" = "0 to 20 yrs old")) %>% 
  filter(age != "Unknown")

#sdmd_combined_plus_zones <- sdmd_combined_plus_zones %>% 
#  mutate(age = as_factor(age))

# commented out code to convert 20XX/XX to YYYY
# year = as.integer(recode(year, "2006/07" = "2007",
#                          "2007/08" = "2008",
#                          "2008/09" = "2009",
#                          "2009/10" = "2010",
#                          "2010/11" = "2011",
#                          "2011/12" = "2012",
#                          "2012/13" = "2013",
#                          "2013/14" = "2014",
#                          "2014/15" = "2015",
#                          "2015/16" = "2016",
#                          "2016/17" = "2017",
#                          "2017/18" = "2018",
#                          "2018/19" = "2019"))

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data/folder

#write_csv(sdmd_combined_plus_zones, "clean_data/sdmd_combined_plus_zones.csv")

# End of code -------------------------------------------------------------
