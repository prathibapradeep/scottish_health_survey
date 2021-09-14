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
       select (type) %>% 
       unique() %>% 
       filter(!(is.na(type))) %>% 
       arrange(type) %>% 
       mutate(list = type)
    return (area_selection$list)
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

# Function to choose the breakdown topic dynamically based on topic chosen---------
choose_breakdown_topic <- function(topic_input, break_down, area_input, name_input)
{
  if( topic_input == "Life Expectancy")
  { choices <- "Gender" }
  else{
    if(topic_input == "Drug Abuse")
    {choices <- c("Gender", "Age")}
    else 
    {choices <- c("Gender", "Age")}
  }
    return (choices)
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
else{
  choices <- input_table %>%
    filter(type %in% area_input,
           name %in% name_input,
           sex != "All") %>%
    distinct(sex) %>% 
    arrange(sex) %>% 
    flatten_chr()
  return (choices)
}
#Commented the code for SIMD Quintile        
# if(break_down == "SIMD"){
#    choices <- input_table %>%
#      filter (sex != "All") %>% 
#      distinct(sex) %>% 
#      arrange(sex) %>% 
#      flatten_chr()
#    return (choices)
#   
# }
}

# Since there is only one render Plot which displays dynamically based on user input,
# this function helps to select the data for the plot based on chosen topic
# This function inturn calls the function which is available in its corresponding server file

# Function to select the data based on user choice---------------
select_data <- function( user_choice, input_name, input_demographic, topic_input) {
  
  if(topic_input == "Life Expectancy")
  {
        #Function available in the server_life_expectancy.R
        return (select_life_data(user_choice, input_name, input_demographic))
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      #Function available in the server_drugs.R
      return(select_drug_data(user_choice, input_name, input_demographic))
    }
    else
    {
      #Function available in the server_smoking.R
      return(select_smoke_data(user_choice, input_name, input_demographic))
    }
  }
}

# Function to plot the data based on user choice------------------------------
plot_object <- function( data, user_choice, topic_input) {
  
  if(topic_input == "Life Expectancy")
  {
   return(plot_life_object(data, user_choice))
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      return(plot_drugs_object(data, user_choice))
    }
    else 
      {
      return(plot_smoke_object(data, user_choice))
    }
  }
}

# Function to select the data based on user choice---------------
select_rank_data <- function(topic_input, sex_input, rank_area_input,select_input) {
  
  if(topic_input == "Life Expectancy")
  {
    #Function available in the server_life_expectancy.R
      select_life_rank_data(sex_input, rank_area_input,select_input )
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      #Function available in the drug.R
      select_drugs_rank_data(sex_input, rank_area_input, select_input)
    }
    else {
        #Function available in the drug.R
        select_sm_rank_data(sex_input,rank_area_input, select_input )  
    }
  }
}

# Function to plot the data based on user choice------------------------------
plot_rank_object <- function(data, topic_input,select_input) {
  
  if(topic_input == "Life Expectancy")
  {
    plot_life_rank_object(data,select_input)
  }
  else
  {
    if(topic_input == "Drug Abuse")  {
      plot_drugs_rank_object(data,select_input)
    }
    else{
        plot_sm_rank_object(data,select_input)
      
    }
  }
}