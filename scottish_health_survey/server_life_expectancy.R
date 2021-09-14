#--------------------------------------------------------------------------#
# Server file to select the data and plots required for life expectancy    #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | Derek       | Updated the contents of the function     #
#--------------------------------------------------------------------------#

# Function to select the data based on user choice

select_life_data <- function( user_choice, input_name, input_demographic) {
  
    if(user_choice == "Gender")
    {
      life_expectancy_clean %>%
        group_by(name,date_code, sex) %>% 
        summarise(mean_le = mean(le_value),
                  mean_le_lower_ci = mean(le_lower_ci),
                  mean_le_upper_ci = mean(le_upper_ci),
                  .groups = "drop"
        ) %>% 
        filter(name == input_name,
               sex %in% input_demographic,
        )
    }
    #Commented the code for SIMD Quintile      
    # else{
    #   life_expectancy_clean %>%
    #     filter(sex != "All",
    #            sex %in% input_demographic,
    #            urban_rural_classification == "All",
    #            simd_quintiles != "All") %>%
    #     arrange(date_code)
    # }
}

# Function to plot the data based on selected data from user choice

plot_life_object <- function(data, user_choice) {
  
  if(user_choice == "Gender"){
      ggplot(data) +
      aes(x = date_code, y = mean_le, group = sex, colour = sex) +
      geom_point(alpha = 0.8) +
      geom_line()+
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\n\nYear",
        y = "Life Expectancy (years)\n",
        colour = "Sex"
      )+
      color_theme()
  }
  #Commented the code for SIMD Quintile
  # else {
  #   
  #   data %>% 
  #   ggplot() +
  #     aes(x = date_code, y = le_value, group = simd_quintiles, colour = simd_quintiles) +
  #     geom_line() +
  #     facet_wrap(~sex)+
  #     theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
  #     labs(
  #       x = "\nYear",
  #       y = "Life Expenctancy (Years)\n",
  #       colour = "SIMD (Quintiles)"
  #     )+
  #     color_theme()
  # }
}

select_life_rank_data <- function(sex_input, rank_area_input, select_input) {
  
 if (select_input == "Highest 5"){
  life_expectancy_clean %>% 
    filter(type == rank_area_input,
           simd_quintiles == "All",
           urban_rural_classification == "All",
           date_code == "2017-2019",
           sex == sex_input,
           age == 0) %>%
    arrange(desc(le_value)) %>% 
    head(n = 5)
  }
  else {
    life_expectancy_clean %>% 
      filter(type == rank_area_input,
             simd_quintiles == "All",
             urban_rural_classification == "All",
             date_code == "2017-2019",
             sex == sex_input,
             age == 0) %>%
      arrange(desc(le_value)) %>% 
      tail(n = 5)
  }
  
}

# Function to plot the data based on selected data from user choice

plot_life_rank_object <- function(data,select_input) {
  
  if (select_input == "Highest 5"){
  data %>%
    ggplot() +
    aes(x = reorder(name, le_value), y = le_value, fill = le_value) +
    geom_col() +
    ylim(0, 100) +
    theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
    labs(
      x = "Data Zone",
      y = "Life Expectancy (years)\n",
      fill = "Life Expectancy Percentage"
    )+
    scale_fill_distiller(palette = "YlGn")+
    color_theme()
  }
  else {
    data %>%
      ggplot() +
      aes(x = reorder(name, le_value), y = le_value, fill = le_value) +
      geom_col() +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "Data Zone",
        y = "Life Expectancy (years)\n",
        fill = "Life Expectancy Percentage"
      )+
      scale_fill_distiller(palette = "YlOrRd")+
      color_theme()
  }
}
