#--------------------------------------------------------------------------#
# UI for Rank Page                                                         #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             |Prathiba     | Initial Version                          #
# 1.1             |Derek        | Updated Code
#--------------------------------------------------------------------------#

ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  titlePanel(tags$h2("Rank")),
  
  sidebarLayout(
    sidebarPanel(#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("rank_topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug Abuse", "Smoking")
                    
        )),
      fluidRow(
        selectInput("rank_area_input",
                    "Select Data Zone",
                    choices = c("Local Authority", "NHS Health Board")
                    
        )),
      
      fluidRow(
        selectInput("rank_sex_input",
                    "Select Sex",
                    choices = c("Male", "Female")
        )
      ),
      
      fluidRow(
        radioButtons("rank_select_input",
                    "Selection",
                    choices = c("Highest 5", "Lowest 5")
        )
      )
    ),
    mainPanel(
      #Content to display the plot
      fluidRow(
        box(   
          title = tags$h3("Representation of ",textOutput("rank_topic", inline = TRUE),
                          "data for the  ",
                          textOutput("rank_select", inline = TRUE),
                          " Data Zone under ",
                          textOutput("rank_area", inline = TRUE)
          ),
          width = 12, status = "primary",
          plotlyOutput("rank_distPlot")
        )
      ),
      #Content to display the table
      fluidRow(
        box(
          width = 12,
          title = tags$h3("Table"),
          DT::dataTableOutput("rank_output_table")
        )
      )
      
    )
  )
)
