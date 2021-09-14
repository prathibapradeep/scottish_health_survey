#-------------------------------------------------------------------------------
#Paddy Hudson
#This script is to produce a leaflet map object with health board zones
#And LE data
#-------------------------------------------------------------------------------

#First load libraries

library(leaflet)
library(sf)
library(tidyverse)
library(here)

#load data - update filepath as necessary

# hb_zones <- read_sf(here("clean_data/hb_zones/hb_zones_simple.shp"))
# le <- read_csv("clean_data/life_expectancy.csv")
# 
# #Get Scottish Average
# 
# scot_ave <- le %>% 
#   filter(
#     date_code == "2017-2019" &
#       age == 0 &
#       type == "Scotland" &
#       sex == "All"
#   ) %>% 
#   select(le_value) %>% 
#   pull()
# 
# #filter le data
# 
# le_filtered <- le %>% 
#   filter(
#     date_code == "2017-2019" &
#     age == 0 &
#     type == "NHS Health Board" &
#     sex == "All"
#   )
  
#Join spatial data to health data

# map_data <- hb_zones %>% 
#   left_join(le_filtered, by = c("hb_code" = "feature_code")) %>% 
#   select(-name) %>% 
#   mutate(label = "LE")
# 
# #Create comparative data
# 
# map_data <- map_data %>%
#   mutate(le_value = le_value - scot_ave) %>%
#   mutate(label = "LE - Scottish Average")

#choose spatial data
spatial_data <- switch(input$area_input,
                       "NHS Health Board" = hb_zones,
                       "Local Authority" = la_zones
)

#choose topic data
topic_data <- switch(input$topic_input,
                     "Life Expectancy" = life_expectancy_clean,
                     "Drug Abuse" = sdmd_combined_plus_zones,
                     "Smoking" = smoking_clean
) %>%
  filter(type == input$area_input,
         sex == "All",
         age == switch(input$topic_input,
                       "Life Expectancy" = 0,
                       "Drug Abuse" = "All",
                       "Smoking" = "All"
         )
  ) %>%
  select(-name)

if (input$topic_input == "Life Expectancy"){
  topic_data <- topic_data %>%
    filter(date_code == "2017-2019") %>%
    rename(value = le_value) %>%
    mutate(label = "Life Expectancy")
} else if (input$topic_input == "Drug Abuse"){
  topic_data <- topic_data %>%
    filter(year == "2017/18") %>%
    rename(value = number_assessed) %>%
    mutate(label = "Number Assessed")
} else if (input$topic_input == "Smoking"){
  topic_data <- topic_data %>%
    filter(date_code == 2019,
           long_term_condition == "All",
           household_type == "All",
           smokes == "Yes"
    ) %>% 
    rename(value = sm_percent) %>% 
    mutate(label = "Percentage of Population who are Smokers")
}

#join to get map data
map_data <- spatial_data %>%
  left_join(topic_data, by = c("code" = "feature_code"))

#Create colour palette
map_palette <- colorNumeric("magma", domain = range(map_data$value))

#get the map
#output$my_map <- renderLeaflet({
map_data %>%
  leaflet() %>%
  #addTiles() %>% #uncomment this line to add background map
  addPolygons(
    popup = ~str_c(name, "<br>", label, " = ", round(value, 2), sep = ""),
    color = ~map_palette(value)
  )
#})