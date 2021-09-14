#--------------------------------------------------------------------------#
# Server file to select the data and plots required for smoking            #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | John Paul   | Updated Plot contents                    #
#--------------------------------------------------------------------------#


# Function to select the data based on user choice

select_smoke_data <- function( user_choice, input_name, input_demographic) {
  
  if(user_choice == "Gender")
  {
    smoking_clean %>%
      select(feature_code, date_code, name, type, date_code,sex,age, smokes, sm_lower_ci, sm_upper_ci, sm_percent) %>% 
      filter(name == input_name,
             smokes == "Yes",
             sex != "All",
             sex %in% input_demographic) %>% 
    arrange(date_code) 
    
  }
  else{
    smoking_clean %>%
      select(feature_code, date_code, name, type, date_code,sex,age, smokes, sm_lower_ci, sm_upper_ci, sm_percent) %>% 
      filter(name == input_name,
             smokes == "Yes",
             age %in% input_demographic,
             !(age %in% (c("All","16-64"))),
             sex == "All") 
    
    
  }
}

# Function to plot the data based on selected data from user choice

plot_smoke_object <- function(data, user_choice) {
  
  if(user_choice == "Gender"){
    
    data %>% 
      ggplot(aes(x = date_code, y = sm_percent,  group = sex, colour = sex)) +
      geom_point() +
      geom_line() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\nYear",
        y = "All Smokers (%)\n",
        colour = "Sex"
      ) +
      color_theme()
    }
  else {
    data %>% 
      ggplot(aes(x = date_code, y = sm_percent,  group = age, colour = age)) +
      geom_point() +
      geom_line() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\nYear",
        y = "All Smokers (%)\n",
        colour = "Age"
      ) +
      color_theme()
    }
}


select_sm_rank_data <- function(rank_sex_input, rank_area_input, select_input) {
  
  if (select_input == "Highest 5"){
  smoking_clean %>%
    filter(type == rank_area_input,
           date_code == "2019",
           sex == rank_sex_input,
           household_type == "All",
           long_term_condition == "All",
           age == "All",
           smokes == "Yes") %>%
    arrange(desc(sm_percent)) %>% 
    head(n=5) %>% 
    select(feature_code, date_code, name, type, date_code,sex,age,sm_lower_ci, sm_upper_ci, sm_percent) 
    
  }
  else {
    smoking_clean %>%
      filter(type == rank_area_input,
             date_code == "2019",
             sex == rank_sex_input,
             household_type == "All",
             long_term_condition == "All",
             age == "All",
             smokes == "Yes") %>%
      arrange(desc(sm_percent)) %>% 
      tail(n=5) %>% 
      select(feature_code, date_code, name, type, date_code,sex,age,sm_lower_ci, sm_upper_ci, sm_percent)
    }
}

# Function to plot the data based on selected data from user choice

plot_sm_rank_object <- function(data, select_input) {
    
  if (select_input == "Highest 5"){
      
    data %>%
      ggplot() +
      aes(x = reorder(name, sm_percent), y = sm_percent, fill = sm_percent) +
      geom_col() +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Smokers (%)\n"
      ) +
    scale_fill_distiller(palette = "YlGn")+
    color_theme()
  }
  else {
    data %>%
      ggplot() +
      aes(x = reorder(name, sm_percent), y = sm_percent, fill = sm_percent) +
      geom_col() +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Smokers (%)\n"
      ) +
      scale_fill_distiller(palette = "YlOrRd")+
      color_theme()
    
  }
}