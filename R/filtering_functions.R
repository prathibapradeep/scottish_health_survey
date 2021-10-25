#--------------------------------------------------------------------------#
# Helper file to select the data                                           #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | Derek       | Updated select data for Life expectancy  #
# 1.2             | JP          | Updated select data for Drug Abuse       #
# 1.3             | John Paul   | Updated select data for Smoking          #
#--------------------------------------------------------------------------#

# Function to select trend data based on user choice---------------
select_trend_data <- function( user_choice, input_name,input_area, input_demographic, topic_input) {
  
  if(topic_input == "Life Expectancy")
  {
    if(user_choice == "Gender")
    {
      return(life_expectancy_clean %>%
        group_by(name,type,date_code, sex) %>% 
        filter(name == input_name,
               type == input_area,
               sex %in% input_demographic,
        ) %>% 
          summarise(mean_le = mean(le_value),
                    mean_le_lower_ci = mean(le_lower_ci),
                    mean_le_upper_ci = mean(le_upper_ci),
                    .groups = "drop"
          )
        )
    }
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      if(user_choice == "Age")
      {
        return(sdmd_combined_plus_zones %>%
          filter(name == input_name,
                 type == input_area,
                 age %in% input_demographic,
                 sex == "All") %>% 
          filter(number_assessed != 0) %>% 
          filter(!is.na(number_assessed)) %>% 
          arrange(year) %>% 
          group_by(year, age) %>% 
          summarise(number_assessed_total = sum(number_assessed), .groups = "drop"))
      }
      else{
        return(sdmd_combined_plus_zones %>%
          filter(name == input_name,
                 type == input_area,
                 sex %in% input_demographic) %>% 
          filter(number_assessed != 0) %>% 
          filter(!is.na(number_assessed)) %>% 
          arrange(year) %>% 
          group_by(year, sex) %>% 
          summarise(number_assessed_total = sum(number_assessed), .groups = "drop"))
      }
    }
    else
    {
      if(user_choice == "Gender")
      {
       return( smoking_clean %>%
          select(feature_code, date_code, name, type, date_code,sex,age, smokes, sm_lower_ci, sm_upper_ci, sm_percent) %>% 
          filter(name == input_name,
                 type == input_area,
                 smokes == "Yes",
                 sex != "All",
                 sex %in% input_demographic) %>% 
          arrange(date_code) )
      }
      else{
        return(smoking_clean %>%
          select(feature_code, date_code, name, type, date_code,sex,age, smokes, sm_lower_ci, sm_upper_ci, sm_percent) %>% 
          filter(name == input_name,
                 type == input_area,
                 smokes == "Yes",
                 age %in% input_demographic,
                 !(age %in% (c("All","16-64"))),
                 sex == "All") )
      }
    }
  }
}

# Function to select rank data based on user choice---------------
select_rank_data <- function(topic_input, rank_sex_input, rank_area_input,select_input) {
  
  if(topic_input == "Life Expectancy")
  {
    if (select_input == "Highest 5"){
      return(life_expectancy_clean %>% 
        filter(type == rank_area_input,
               simd_quintiles == "All",
               urban_rural_classification == "All",
               date_code == "2017-2019",
               sex == rank_sex_input,
               age == 0) %>%
        arrange(desc(le_value)) %>% 
        select (name, type, date_code, sex, le_value)  %>% 
        head(n = 5))
    }
    else {
      return(life_expectancy_clean %>% 
        filter(type == rank_area_input,
               simd_quintiles == "All",
               urban_rural_classification == "All",
               date_code == "2017-2019",
               sex == rank_sex_input,
               age == 0) %>%
        arrange(desc(le_value)) %>% 
        select (name, type, date_code, sex, le_value)  %>% 
        tail(n = 5))
    }
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      if (select_input == "Highest 5"){
        return (sdmd_combined_plus_zones %>%
          filter(type == rank_area_input,
                 year == "2018/19",
                 sex == rank_sex_input,
                 age == "All")%>%
          filter(!is.na(number_assessed)) %>% 
          arrange(desc(number_assessed)) %>% 
          head(5))
      }
      else {
        return(sdmd_combined_plus_zones %>%
          filter(type == rank_area_input,
                 year == "2018/19",
                 sex == rank_sex_input,
                 age == "All")%>%
          filter(!is.na(number_assessed)) %>% 
          arrange(desc(number_assessed)) %>% 
          tail(5))
        
      }
    }
    else {
      if (select_input == "Highest 5"){
        return(smoking_clean %>%
          filter(type == rank_area_input,
                 date_code == "2019",
                 sex == rank_sex_input,
                 household_type == "All",
                 long_term_condition == "All",
                 age == "All",
                 smokes == "Yes") %>%
          arrange(desc(sm_percent)) %>% 
          head(n=5) %>% 
          select(feature_code, date_code, name, type, date_code,sex,age,sm_lower_ci, sm_upper_ci, sm_percent) )
        
      }
      else {
        return(smoking_clean %>%
          filter(type == rank_area_input,
                 date_code == "2019",
                 sex == rank_sex_input,
                 household_type == "All",
                 long_term_condition == "All",
                 age == "All",
                 smokes == "Yes") %>%
          arrange(desc(sm_percent)) %>% 
          tail(n=5) %>% 
          select(feature_code, date_code, name, type, date_code,sex,age,sm_lower_ci, sm_upper_ci, sm_percent))
      }
    }
  }
}

# Filter the data for Map ---------------------------------------------------

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

