get_map_data <- function(topic, area, breakdown, group)
{  
  
  #choose spatial data
  
  spatial_data <- switch(area,
                         "NHS Health Board" = hb_zones,
                         "Local Authority" = la_zones)
  
  #choose topic data
  topic_data <- switch(
    topic,
    "Life Expectancy" = life_expectancy_clean,
    "Drug Abuse" = sdmd_combined_plus_zones %>% drop_na(),
    "Smoking" = smoking_clean
  )
  
   if (breakdown == "Age"){
    topic_data <- topic_data %>% 
      filter(type == area,
             sex == "All",
             age == group) %>%
      select(-name) 
   } else if (breakdown == "Gender"){
    topic_data <- topic_data %>% 
       filter(type == area,
              sex == group,
              age == switch(
                topic,
                "Life Expectancy" = 0,
                "Drug Abuse" = "All",
                "Smoking" = "All"
                )) %>%
       select(-name)
   } else {
     topic_data <- topic_data %>% 
       filter(type == area,
              sex == "All",
              age == switch(
                topic,
                "Life Expectancy" = 0,
                "Drug Abuse" = "All",
                "Smoking" = "All"
              )) %>%
       select(-name)
   }
  
  
  if (topic == "Life Expectancy") {
    topic_data <- topic_data %>%
      filter(date_code == "2017-2019") %>%
      rename(value = le_value) %>%
      mutate(label = "Life Expectancy")
  } else if (topic == "Drug Abuse") {
    topic_data <- topic_data %>%
      filter(year == "2017/18") %>%
      rename(value = number_assessed) %>%
      mutate(label = "Number Assessed")
  } else if (topic == "Smoking") {
    topic_data <- topic_data %>%
      filter(
        date_code == 2019,
        long_term_condition == "All",
        type_of_tenure == "All",
        household_type == "All",
        smokes == "Yes"
      ) %>%
      rename(value = sm_percent) %>%
      mutate(label = "Percentage of Population who are Smokers")
  }
  
  #join to get map data
  map_data <- spatial_data %>%
    inner_join(topic_data, by = c("code" = "feature_code"))
  
  #Create colour palette
  
  if (topic == "Life Expectancy"){
    map_palette <- colorNumeric("viridis", domain = range(map_data$value), reverse = TRUE)
    map_data <- map_data %>% arrange(desc(value))
  } else {
    map_palette <- colorNumeric("viridis", domain = range(map_data$value))
    map_data <- map_data %>% arrange(value)
  }
  
  map_data <- map_data %>% 
    mutate(colour = map_palette(value))
  
  return(map_data)
}


get_group_choices <- function(topic, breakdown){
  
  if (topic == "Life Expectancy"){
    choices <- life_expectancy_clean
  } else if (topic == "Drug Abuse"){
    choices <- sdmd_combined_plus_zones
  } else if (topic == "Smoking"){
    choices <- smoking_clean %>%
      mutate(age = as_factor(age)) %>%
      mutate(age = fct_relevel(age, c("All","16-34","35-64","16-64","65 and over")))
  }
  
  if (breakdown == "None"){
    return("No Breakdown Selected")
  } else if (breakdown == "Age"){
    choices <- choices %>% 
      select(age) %>% 
      unique() %>% 
      arrange(age) %>% 
      mutate(list = age)
  } else if (breakdown == "Gender"){
    choices <- choices %>% 
      select(sex) %>% 
      unique() %>% 
      arrange(sex) %>% 
      mutate(list = sex)
  }
  
  return(choices$list)
  
}