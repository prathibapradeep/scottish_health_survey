#--------------------------------------------------------------------------#
# Server file to select the data and plots required for drug abuse         #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | JP          | Updated the contents of the function     #
#--------------------------------------------------------------------------#

# Function to select the data based on user choice

select_drug_data <- function(user_choice, input_name, input_demographic) {
  
    if(user_choice == "Age")
    {
      sdmd_combined_plus_zones %>%
        filter(name == input_name,
               age %in% input_demographic,
               sex == "All") %>% 
        filter(number_assessed != 0) %>% 
        filter(!is.na(number_assessed)) %>% 
        arrange(year) %>% 
        group_by(year, age) %>% 
        summarise(number_assessed_total = sum(number_assessed), .groups = "drop")
        
    }
    else{
      sdmd_combined_plus_zones %>%
        filter(name == input_name,
               sex %in% input_demographic) %>% 
        filter(number_assessed != 0) %>% 
        filter(!is.na(number_assessed)) %>% 
        arrange(year) %>% 
        group_by(year, sex) %>% 
        summarise(number_assessed_total = sum(number_assessed), .groups = "drop")
    }
}

# Function to plot the data based on selected data from user choice

plot_drugs_object <- function(data, user_choice) {
  
  if(user_choice == "Age"){
  
    data %>% 
      ggplot(aes(x = year, y = number_assessed_total, group = age, colour = age)) +
      geom_point() +
      #geom_line() +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Patients Assessed\n",
        colour = "Age"
      )+
      color_theme()  
  }
  else {
    
    data %>% 
      ggplot(aes(x = year, y = number_assessed_total, group = sex, colour = sex)) +
      geom_point() +
      geom_line()+
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Patients Assessed\n", 
        colour = "Age"
      )+
      color_theme()
    
  }
}


select_drugs_rank_data <- function(sex_input, rank_area_input, select_input) {
  
  if (select_input == "Highest 5"){
  sdmd_combined_plus_zones %>%
    filter(type == rank_area_input,
           year == "2018/19",
           sex == sex_input,
           age == "All")%>%
    filter(!is.na(number_assessed)) %>% 
    arrange(desc(number_assessed)) %>% 
    head(5)
  }
  else {
    sdmd_combined_plus_zones %>%
      filter(type == rank_area_input,
             year == "2018/19",
             sex == sex_input,
             age == "All")%>%
      filter(!is.na(number_assessed)) %>% 
      arrange(desc(number_assessed)) %>% 
      tail(5)
    
  }
}

# Function to plot the data based on selected data from user choice

plot_drugs_rank_object <- function(data,select_input) {
  
  if (select_input == "Highest 5"){
    # Five Highest Areas for drug abuse
    data %>%
      ggplot() +
      aes(x = reorder(name, number_assessed), y = number_assessed, fill = number_assessed) +
      geom_col() +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Patients Assessed\n"
      )+
      scale_fill_distiller(palette = "YlGn")+
      color_theme()
  }
  else {
    # Five Highest Areas for drug abuse
    data %>%
      ggplot() +
      aes(x = reorder(name, number_assessed), y = number_assessed, fill = number_assessed) +
      geom_col() +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Number of Patients Assessed\n"
      )+
      scale_fill_distiller(palette = "YlOrRd")+
      color_theme()
  }
  }