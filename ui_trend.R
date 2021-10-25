#--------------------------------------------------------------------------#
# UI for Trend Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version                          #
#--------------------------------------------------------------------------#

ui <- fluidPage(
  style = "background-color: #3481ad" ,
  titlePanel(tags$h1("Trend")),
  
  sidebarLayout( 
    sidebarPanel(
      #Input the Topic
      fluidRow(
        selectInput("topic_input",
                    "Select Topic",
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
                    "Select Breakdown:",
                    choices = NULL
        )
      ),
      fluidRow(
      dropdown(
        label = "Select one or more breakdown", status = "default",
        checkboxGroupInput("demographic_input",
                           "",
                           choices = NULL,
                           inline = TRUE)
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
    fluidRow(style = "background-color: #3481ad" ,
             
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
