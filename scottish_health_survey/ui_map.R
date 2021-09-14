# #--------------------------------------------------------------------------#
# # UI for Map Page                                                          #
# #--------------------------------------------------------------------------#
# # Version         | Name        | Remarks                                  #
# #--------------------------------------------------------------------------#
# # 1.0             | Paddy       | Initial Version                          #
# #--------------------------------------------------------------------------#

library (shinyWidgets)

ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  #titlePanel(tags$h2("Map")),
  
  sidebarLayout(
    sidebarPanel(width = 3,#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("map_topic_input",
                    "Select Topic",
                    choices = c("Life Expectancy", "Drug Abuse","Smoking")
                    
        )),
      fluidRow(
        selectInput("map_area_input",
                    "Select Data Zones",
                    choices = c("NHS Health Board", "Local Authority")
        )),
      fluidRow(
        selectInput("map_breakdown_input",
                    "Select Breakdown:",
                    choices = c("None", "Age", "Gender")
        )),
      fluidRow(
        selectInput("map_group_input",
                      "Select Group:",
                      choices = NULL
        )),
      fluidRow(HTML("
                    <p style='text-align:justify; color:black; font-weight:bolder'>Summary Statistics for Current View:</p>
                    ")),
      fluidRow(style = "color:black",
        tableOutput("map_stats")
      ),
      fluidRow(style = "color:black",
        textOutput("map_units")
      ),
      fluidRow(tags$br()),
      fluidRow(HTML("
                    <p style='text-align:justify; color:black'>Data shown reflects the latest available data only.</p>
                    <p style='text-align:justify; color:black'>Life Expectancy: 2017-2019</p>
                    <p style='text-align:justify; color:black'>Drug Abuse: 2017/18</p>
                    <p style='text-align:justify; color:black'>Smoking: 2019</p>
                    ")),
      fluidRow(tags$br())
    ),
    mainPanel(width = 9,
      #Content to display the map
      fluidRow(
        leafletOutput("my_map", height = 620)
      ),
      #Content to display the table
      fluidRow(style = "padding-top: 2%",
        dataTableOutput("map_table")
      )
      
    )
  )
)
