#--------------------------------------------------------------------------#
# UI for Trend Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version                          #
#--------------------------------------------------------------------------#

ui <- fluidPage(
  #style = "background-color: #a6cbe3" ,
  #titlePanel(tags$h2("Trend")),
  
  sidebarLayout(
    sidebarPanel(#style = "background-color: #a6cbe3" ,
      #Input the Topic
      fluidRow(
        selectInput("topic_input",
                    "Select topic",
                    choices = c("Life Expectancy", "Drug Abuse","Smoking")

        )),
      fluidRow(
        selectInput("area_input",
                    "Select Data Zone",
                    choices = NULL
                    
        )),
      
      fluidRow(
        selectInput("name_input",
                    "Select Region:",
                    choices = NULL
        ),
      ),
      fluidRow(
        selectInput("breakdown_input",
                    "Select breakdown:",
                    choices = NULL
        )
      ),
      fluidRow(
      dropdown(
        label = "Select one or more breakdown", status = "default",
        checkboxGroupInput("demographic_input",
                           "",
                           choices = NULL,
                           inline = FALSE)
      )
      )
      # ,
      # fluidRow(tags$br()),
      # fluidRow(tags$br()),
      # fluidRow(
      #   downloadButton(label ="Download", "download_report")
      # )
      ),
  mainPanel(
    #Content to display the plot
    fluidRow(
             box(   
               title = tags$h3("Representation of ",textOutput("topic", inline = TRUE),
                               " data based on ",
                               textOutput("name", inline = TRUE),
                               " for the ",
                               textOutput("breakdown", inline = TRUE),
                               " Category  "
               ),
               width = 12, status = "primary",
               plotlyOutput("distPlot")
               )
             
    ),
  #Content to display the table
        fluidRow(
          box(
            width = 12,
            title = tags$h3("Table"),
            DT::dataTableOutput("output_table")
          )
        )
      
    )
  )
)
