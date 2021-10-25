#--------------------------------------------------------------------------#
# Helper file which contains the functions to choose the inputs dynamically#
# as a part of server script                                               #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version; Created select_data,    #
#                 |             | plot data                                #
# 1.1             | Derek       | Worked on area & name selection          #
#--------------------------------------------------------------------------#

# Function to choose the area dynamically based on topic chosen--------------
choose_area <- function (topic_input)
{
  
  if( topic_input == "Life Expectancy")
  {input_table <- life_expectancy_clean }
  else{
    if(topic_input == "Drug Abuse")
    {input_table <- sdmd_combined_plus_zones}
    else 
    {input_table <- smoking_clean }
  }
  
  #Fetch Zone data dynamically
  
  area_selection <- input_table %>% 
    select(type) %>% 
    filter(!(is.na(type))) %>% 
    unique() %>% 
    arrange(type) %>% 
    mutate(list = type)
  return (area_selection$type)
}

# Function to choose the region name dynamically based on topic and area chosen-----
choose_name <- function (topic_input, area_input)
{
  
  if( topic_input == "Life Expectancy")
  {input_table <- life_expectancy_clean }
  else{
    if(topic_input == "Drug Abuse")
    {input_table <- sdmd_combined_plus_zones}
    else 
    {input_table <- smoking_clean }
  }
  
  #Fetch Region data dynamically
  name_selection <- input_table %>%
    filter(type %in% area_input) %>%
    distinct(name) %>% 
    arrange(name)  %>% 
    flatten_chr()
  return (name_selection)
}

# Function to choose the breakdown's dynamically based on topic chosen----------
choose_breakdown <- function(topic_input, break_down, area_input, name_input)
{
  if( topic_input == "Life Expectancy")
  {input_table <- life_expectancy_clean }
  else{
    if(topic_input == "Drug Abuse")
    {input_table <- sdmd_combined_plus_zones}
    else 
    {input_table <- smoking_clean }
  }
  
  if(break_down == "Age")
  {
    choices <- input_table %>%
      filter(type %in% area_input,
             name %in% name_input,
             !(age %in% (c("All","16-64")))) %>%
      distinct(age) %>% 
      arrange(age) %>% 
      flatten_chr()
    return (choices)
  }
  if(break_down == "Gender"){
    choices <- input_table %>%
      filter(type %in% area_input,
             name %in% name_input,
             sex != "All") %>%
      distinct(sex) %>% 
      arrange(sex) %>% 
      flatten_chr()
    return (choices)
  }
}


# Function to choose the breakdown's dynamically based on topic chosen----------

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