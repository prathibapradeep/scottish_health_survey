#--------------------------------------------------------------------------
# This script is to load and clean the life expectancy data.
# Cleaned by John Paul
#--------------------------------------------------------------------------

# Load the library --------------------------------------------------------
library(here)
library(tidyverse)
library(janitor)

source(here("data_cleaning_wrangling/datazonelookup.R"))

# Read the data file ------------------------------------------------------
smoking<- read_csv(here("original_data/smoking_core_questions_raw_data.csv")) %>% clean_names()


# Data Cleaning -----------------------------------------------------------

# Tidy the data and rename some column names
smoking_clean <- smoking %>%
  pivot_wider(
    names_from = measurement,
    values_from = value
  ) %>%
  rename(
    smokes = "currently_smokes_cigarettes",
    sex = "gender",
    long_term_condition = "limiting_long_term_physical_or_mental_health_condition",
    sm_lower_ci = "95% Lower Confidence Limit, Percent",
    sm_upper_ci = "95% Upper Confidence Limit, Percent",
    sm_percent = "Percent"
  )

# Tidy the age column 
smoking_clean <- smoking_clean %>%
  mutate(age = str_replace(age, " years", ""))

# Lookup the Area name using data_zone_lookup_code
smoking_clean <- smoking_clean %>%
  left_join(data_zone_lookup_code_names, by = c("feature_code" = "code")) %>%
  select(feature_code, name, type, date_code, smokes, type_of_tenure, household_type, sex,
         long_term_condition, age, sm_lower_ci, sm_upper_ci, sm_percent)

# Rename the authority types & filter out unnecessary ones
smoking_clean <- smoking_clean %>%
  mutate(type = recode(type,
                       "la" = "Local Authority",
                       "hb" = "NHS Health Board",
                       "country" = "Scotland"
  )) %>% 
  filter(type %in% c("Local Authority", "NHS Health Board", "Scotland"))

# Change all columns to char to remove List type for csv, change numeric values back to numeric type
smoking_clean <- smoking_clean %>% 
  mutate(across(everything(), as.character)) %>% 
  mutate_at("sm_lower_ci", as.numeric) %>%
  mutate_at("sm_upper_ci", as.numeric) %>% 
  mutate_at("sm_percent", as.numeric)

smoking_clean <- smoking_clean %>% 
  mutate(entry_id = row_number())

#smoking_clean <- smoking_clean %>% 
#  mutate(age = as_factor(age)) %>% 
#  mutate(age = fct_relevel(age, c("All","16-34","35-64","16-64","65 and over")))

smoking_country <- smoking_clean %>% 
  filter(type == "Scotland",
         type_of_tenure == "All",
         household_type == "All",
         sex == "All",
         long_term_condition == "All",
         age == "All"
  )

# Write the clean data ----------------------------------------------------

# Write the cleaned data into clean_data folder

#write_csv(smoking_clean, here("clean_data/smoking.csv"))

# End of code -------------------------------------------------------------
