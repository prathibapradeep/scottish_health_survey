library(shiny)
library(tidyverse)
library(here)

life_expectancy <- read_csv(here("data/life_expectancy.csv"))
drug_data <- read_csv(here("data/sdmd_combined_plus_zones.csv"))
smoking <- read_csv(here("data/smoking.csv"))

library(shiny)

ui <- fluidPage(
  
  sidebarLayout(
    
    sidebarPanel(
      
      # these are now aligned with the repo app ui_rank
      selectInput("rank_topic_input",
                  "Select topic",
                  choices = c("Life Expectancy", "Drug Abuse", "Smoking")
      ),
      
      selectInput("rank_area_input",
                  "Select Data Zone",
                  choices = c("Local Authority", "NHS Health Board")
      ),
      
      selectInput("sex_input",
                  "Sex",
                  choices = c("All", "Male", "Female")
      ),
      
      selectInput("select_input",
                  "Selection",
                  choices = c("Top 5 Areas", "Bottom 5 Areas")
                  
      ),
      
      mainPanel(
        
        plotOutput("rank_distPlot"),
        
        tableOutput("dataTable")
        
      )
      
    )
    
  )
  
)

server <- function(input, output, session) {
  
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
  
  output$rank_distPlot <- renderPlot({
    
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
  
}

shinyApp(ui, server)

