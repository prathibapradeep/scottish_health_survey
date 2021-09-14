#--------------------------------------------------------------------------
# This script is to load and clean the life expectancy data.
#--------------------------------------------------------------------------

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

source(here("data_cleaning_wrangling/datazonelookup.R"))

# Read the data file ------------------------------------------------------

mental_health <- read_csv("~/CodeClan/mental_health_2014_2017.csv") %>% clean_names()

# Data Cleaning -----------------------------------------------------------

# Tidy the data, rename the colummn names, remove multiple year entries
mental_health_clean <- mental_health %>%
  pivot_wider(
    names_from = measurement,
    values_from = value
  ) %>%
  
  rename(
    mh_lower_ci = "Lower 95% Confidence Limit, Mean",
    mh_upper_ci = "Upper 95% Confidence Limit, Mean",
    mh_mean = "Mean",
    year = "date_code"
  ) %>% 
  
  filter(year==c("2014","2015","2016","2017"))


# Lookup the Area name using data_zone_lookup_code
mental_health_clean <- mental_health_clean %>%
  left_join(data_zone_lookup_code_names, by = c("feature_code" = "code")) %>%
  select(feature_code, name, type, year, type_of_tenure, household_type, age, gender, mh_lower_ci, mh_upper_ci, mh_mean)


# Rename the type
mental_health_clean <- mental_health_clean %>%
  mutate(type = recode(type,
                       "la" = "Local Authority",
                       "hb" = "NHS Health Board",
                       "country" = "Scotland"
  ))

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data/folder
write_csv(mental_health_clean, here("clean_data/mental_health.csv"))

# End of code -------------------------------------------------------------
