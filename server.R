#--------------------------------------------------------------------------#
# Server file                                                              #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba   | Initial Version; Server script for       #
#                 |             | Home Page, Trend Page & Rank Page        #
#                 |             |                                          #
# 1.1             | Derek       | Server script for Life Expectancy        #
# 1.2             | JP          | Server script for Drug Abuse             #
# 1.3             | Paddy       | Server script for Map                    #
#--------------------------------------------------------------------------#

server <- function(input, output, session) {

# Server script for Home Page -----------------------------------------------
  observeEvent(input$jumpToTrend, {
    newtab <- switch(input$tabs, "home_tab" = "trend_tab",)
    updateTabItems(session, "tabs", newtab)
  })

  observeEvent(input$jumpToRank, {
    newtab <- switch(input$tabs,"home_tab" = "rank_tab",)
    updateTabItems(session, "tabs", newtab)
  })
  
  observeEvent(input$jumpToMap, {
    newtab <- switch(input$tabs,"home_tab" = "map_tab",)
    updateTabItems(session, "tabs", newtab)
  })


# Server script for Trend Page ------------------------------------------------

  #This output variable is used in UI to display the plot title in Trend Tab
  output$topic <- renderText({ input$topic_input})
  output$area <- renderText({ input$area_input})
  output$name <- renderText({ input$name_input})
  output$demographic <- renderText({ input$demographic_input})
  output$breakdown <- renderText({ input$breakdown_input})

# Update Inputs for Trend Page

    # Event to populate the area dynamically

    observeEvent( input$topic_input, {
      updateSelectInput(
        inputId = "area_input",
        choices = choose_area(input$topic_input),
        session = getDefaultReactiveDomain()
      )
    })

    # Event to populate the name dynamically
    observeEvent(c( input$area_input,
                    input$topic_input), {
                      updateSelectInput(
                        inputId = "name_input",
                        choices = choose_name(input$topic_input,input$area_input),
                        session = getDefaultReactiveDomain()
                      )
                    })

    # Event to populate the breakdown topic dynamically
    observeEvent(input$topic_input, {
      updateSelectInput(
        inputId = "breakdown_input",
        choices = switch(input$topic_input,
                         "Life Expectancy" = "Gender",
                         "Drug Abuse" = c("Gender", "Age"),
                         "Smoking" = c("Gender", "Age")
                        ),
        session = getDefaultReactiveDomain()
      )
    })

    # Event to populate the choices of breakdown dynamically
    observeEvent(c(input$breakdown_input,
                   input$area_input,
                   input$name_input,
                   input$topic_input), {

                     choice <- choose_breakdown( input$topic_input,
                                                 input$breakdown_input,
                                                 input$area_input,
                                                 input$name_input )

                     updateCheckboxGroupInput(session = session,
                                              inputId = "demographic_input",
                                              choices = choice,
                                              selected = sort(choice),
                                              inline = FALSE
                     )
                   })

# Server script for Rank Page ------------------------------------------------

    #This output variable is used in UI to display the plot title in Rank Tab
    output$rank_topic<- renderText({ input$rank_topic_input})
    output$rank_area <- renderText({ input$rank_area_input})
    output$rank_sex <- renderText({ input$rank_sex_input})
    output$rank_select <- renderText({input$rank_select_input})
    
# Server script for Trends Page -------------------------------------    
      filtered_data <- reactive(
          select_trend_data(input$breakdown_input,input$name_input,input$area_input,input$demographic_input, input$topic_input)
        )
        # Function to create ggplot
        trend_plot <- reactive(
          make_trend_plot(data = filtered_data(), input$breakdown_input, input$topic_input)
        )
        # create plot
        output$distPlot <- renderPlotly({
          plotly::ggplotly(trend_plot())
        })
        # data table to show the data displayed in the life expectancy plot
        output$output_table <- renderDataTable({
          filtered_data()
        })
# Server script for Rank Page -------------------------------------      
        
    filtered_rank_data <- reactive(
      select_rank_data(input$rank_topic_input, input$rank_sex_input, input$rank_area_input,  input$rank_select_input)
    )
    
    # Function to create ggplot
    rank_plot <- reactive(
      make_rank_plot(data = filtered_rank_data(),input$rank_topic_input,input$rank_select_input)
    )
    
    # create plot
    output$rank_distPlot <- renderPlotly({
      ggplotly(rank_plot())
    })
    
    # data table to show the data displayed in the life expectancy plot
    output$rank_output_table <- renderDataTable({
      filtered_rank_data() 
    })

# Server script for Map  ------------------------------------------------
    map_area_input <- reactive(input$map_area_input)
    map_topic_input <- reactive(input$map_topic_input)
    map_breakdown_input <- reactive(input$map_breakdown_input)
    map_group_input <- reactive(input$map_group_input)
    map_data <- reactive(get_map_data(map_topic_input(),
                                      map_area_input(),
                                      map_breakdown_input(),
                                      map_group_input())
    )
    
    observeEvent(input$map_topic_input, {
                     updateSelectInput(
                       session = getDefaultReactiveDomain(),
                       inputId = "map_breakdown_input",
                       choices = switch(
                         input$map_topic_input,
                         "Life Expectancy" = c("None", "Gender"),
                         "Drug Abuse" = c("None", "Age", "Gender"),
                         "Smoking" = c("None", "Age", "Gender")
                       )
                    )
                   })
    
    observeEvent(c(input$map_breakdown_input,
                   input$map_topic_input), {
      updateSelectInput(
        session = getDefaultReactiveDomain(),
        inputId = "map_group_input",
        choices = get_group_choices(map_topic_input(), map_breakdown_input())
      )
    })

          #get the map
          output$my_map <- renderLeaflet({
            map_data() %>%
              leaflet() %>%
              #addTiles() %>% #uncomment this line to add background map
              addPolygons(
                popup = ~ str_c(name, "<br>", label, " = ", round(value, 2), sep = ""),
                color = ~colour
              ) %>%
              addLegend(
                position = "bottomright",
                colors = ~colour,
                labels = ~name
              )
          })

          #get the table

          output$map_table <- renderDataTable({
            map_data() %>%
              as_tibble() %>%
              mutate("Area Name" = name,
                     "Value" = round(value, 2)
                     ) %>%
              select("Area Name", Value)
          })
          
          #get the stats
          
          output$map_stats <- renderTable({
            map_data() %>%
              as_tibble() %>%
              summarise(
                "Mean" = mean(value),
                "Standard Deviation" = sd(value)
                ) %>%
              pivot_longer(cols = 1:2)
          },
          colnames = FALSE)
          
          #get the units
          
          output$map_units <- renderText({
            switch(
              map_topic_input(),
              "Life Expectancy" = "Displaying Years of Life Expectancy.",
              "Drug Abuse" = "Displaying Number of Individuals Presenting for Assessment.",
              "Smoking" = "Displaying Percentage of Population who Smoke."
            )
          })

          
#   output$plot <- renderPlot(plot(),width = 850, height = 425)
#           
# # Download script   -----------------------------------------------------
# output$download_report <- downloadHandler(
# 
#   filename = "my_report.html",
# 
#   content = function(file) {
#     src <- normalizePath('report.Rmd')
#     owd <- setwd(tempdir())
#     on.exit(setwd(owd))
#     file.copy(src, 'report.Rmd', overwrite = TRUE)
#     #all the info you need to pass to the output file
#     params <- list( plot = plot  )
# 
#     out <- render('report.Rmd',
#                   output_format = pdf_document(),
#                   params = params,
#                   envir = new.env(parent = globalenv())
#     )
# 
#     file.rename(out, file)
#   }
# )
}
