#--------------------------------------------------------------------------#
# Server file to select the data and plots required for rank               #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | Derek       | Updated the contents of the function     #
#--------------------------------------------------------------------------#

# Function to select the data based on user choice

select_life_data <- function( user_choice, input_name, input_demographic) {
  
  # filtered data for life expectancy plots
  filtered_data_le <-reactive({life_expectancy %>% 
      filter(type == input$rank_area_input,
             simd_quintiles == "All",
             urban_rural_classification == "All",
             date_code == "2017-2019",
             sex == input$sex_input,
             age == 0) %>%
      arrange(desc(le_value))
  }) 
  
  # filtered data for drug misuse plots
  filtered_data_dm <- reactive({drug_data %>%
      filter(type == input$rank_area_input,
             year == "2018/19",
             sex == input$sex_input) %>%
      arrange(desc(number_assessed)) 
  })
  
  # filtered data for smoking plots
  filtered_data_sm <- reactive({smoking %>%
      filter(type == input$rank_area_input,
             date_code == "2019",
             sex == input$sex_input,
             household_type == "All",
             long_term_condition == "All",
             age == "All",
             smokes == "Yes") %>% 
      arrange(desc(sm_percent))
  })
  
    # if(user_choice == "Gender")
    # {
    #   life_expectancy_clean %>%
    #     group_by(name,date_code, sex) %>% 
    #     summarise(mean_le = mean(le_value),
    #               mean_le_lower_ci = mean(le_lower_ci),
    #               mean_le_upper_ci = mean(le_upper_ci),
    #               .groups = "drop"
    #     ) %>% 
    #     filter(name == input_name,
    #            sex %in% input_demographic,
    #     )
    #     
    # }
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
  
  if (input$rank_topic_input == "Life Expectancy" &
      input$select_input == "Top 5 Areas"){
    
    # Five Highest Areas for Life Expectancy 
    plot <- filtered_data_le() %>%
      head(n = 5) %>%
      ggplot() +
      aes(x = reorder(name, le_value), y = le_value) +
      geom_col() +
      ggtitle(paste("Five Highest Areas for Life Expectancy by", input$rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Life Expectancy (years)\n"
      )
    
  }
  
  if (input$rank_topic_input == "Drug Misuse" &
      input$select_input == "Top 5 Areas"){
    
    # Five Highest Areas by Number of Drug Users 
    plot <- filtered_data_dm() %>%
      head(5) %>%
      ggplot() +
      aes(x = reorder(name, number_assessed), y = number_assessed) +
      geom_col() +
      ggtitle(paste("Five Highest Areas by Number of Drug Users in Treatment by", input$rank_area_input)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Number of Patients Assessed\n"
      )
    
  }
  
  if (input$rank_topic_input == "Smoking" &
      input$select_input == "Top 5 Areas"){
    
    # Five Highest Areas by Percentage of Smokers
    plot <- filtered_data_sm() %>%
      head(5) %>%
      ggplot() +
      aes(x = reorder(name, sm_percent), y = sm_percent) +
      geom_col() +
      ggtitle(paste("Five Highest Areas by Percentage of Smokers by", input$rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Number of Smokers (%)\n"
      )
    
  }
  
  if(input$rank_topic_input == "Life Expectancy" &
     input$select_input == "Bottom 5 Areas"){
    
    # Five Lowest Areas for Life Expectancy by
    plot <- filtered_data_le() %>%
      tail(n = 5) %>%
      ggplot() +
      aes(x = reorder(name, -le_value), y = le_value) +
      geom_col() +
      ggtitle(paste("Five Lowest Areas for Life Expectancy by", input$rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Life Expectancy (years)\n"
      )
    
  }
  
  if (input$rank_topic_input == "Drug Misuse" &
      input$select_input == "Bottom 5 Areas"){
    
    # Five Lowest Areas by Number of Drug Users by
    plot <- filtered_data_dm() %>%
      filter(number_assessed != 0) %>% 
      tail(5) %>%
      ggplot() +
      aes(x = reorder(name, -number_assessed), y = number_assessed) +
      geom_col() +
      ggtitle(paste("Five Lowest Areas by Number of Drug Users in Treatment by", input$rank_area_input)) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Number of Patients Assessed\n"
      )
    
  }
  
  # Five Lowest Areas by Percentage of Smokers by
  if(input$rank_topic_input == "Smoking" &
     input$select_input == "Bottom 5 Areas"){
    
    plot <- filtered_data_sm() %>%
      tail(5) %>%
      ggplot() +
      aes(x = reorder(name, -sm_percent), y = sm_percent) +
      geom_col() +
      ggtitle(paste("Five Lowest Areas by Percentage of Smokers by", input$rank_area_input)) +
      ylim(0, 100) +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
      labs(
        x = paste("\n", input$rank_area_input),
        y = "Number of Smokers (%)\n"
      )
    
  }
  
  plot
  
})

output$rank_output_table <- renderTable({
  
  if (input$rank_topic_input == "Life Expectancy" &
      input$select_input == "Top 5 Areas"){
    
    # data table for Five Highest Areas for Life Expectancy 
    table <- filtered_data_le() %>%
      select(-age, -simd_quintiles, -urban_rural_classification) %>% 
      head(5) 
  }
  
  if (input$rank_topic_input == "Drug Misuse" &
      input$select_input == "Top 5 Areas"){
    
    # data table for Five Highest Areas by Number of Drug Users
    table <- filtered_data_dm() %>%
      head(5)
  }
  
  if (input$rank_topic_input == "Smoking" &
      input$select_input == "Top 5 Areas"){
    
    # data table for Five Highest Areas by Percentage of Smokers
    table <- filtered_data_sm() %>% 
      head(5)
  }
  
  if (input$rank_topic_input == "Life Expectancy" &
      input$select_input == "Bottom 5 Areas"){
    
    # data table for Five Highest Areas for Life Expectancy 
    table <- filtered_data_le() %>%
      select(-age, -simd_quintiles, -urban_rural_classification) %>% 
      tail(5) 
  }
  
  if (input$rank_topic_input == "Drug Misuse" &
      input$select_input == "Bottom 5 Areas"){
    
    # data table for Five Highest Areas by Number of Drug Users
    table <- filtered_data_dm() %>%
      tail(5)
  }
  
  
  if (input$rank_topic_input == "Smoking" &
      input$select_input == "Bottom 5 Areas"){
    
    # data table for Five Highest Areas by Percentage of Smokers
    table <- filtered_data_sm() %>% 
      tail(5)
  }
  
  table
  
})
  
  # if(user_choice == "Gender"){
  #   
  #   data %>% 
  #     ggplot() +
  #     aes(x = date_code, y = mean_le, group = sex, colour = sex) +
  #     geom_line() +
  #     geom_point() +
  #     geom_ribbon(aes(ymax = mean_le_lower_ci, ymin = mean_le_lower_ci), alpha = 0.8, colour = NA) +
  #     theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
  #     labs(
  #       x = "\n\nYear",
  #       y = "Life Expectancy (years)\n",
  #       colour = "Sex"
  #     )+
  #     color_theme()
  # }
  # else {
  #   
  #   data %>% 
  #   ggplot() +
  #     aes(x = date_code, y = le_value, group = simd_quintiles, colour = simd_quintiles) +
  #     geom_line() +
  #     facet_wrap(~sex)+
  #     theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  #     labs(
  #       x = "\nYear",
  #       y = "Life Expenctancy (Years)\n",
  #       colour = "SIMD\nQuintiles"
  #     )+
  #     color_theme()
  # }
}


