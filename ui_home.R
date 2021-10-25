#--------------------------------------------------------------------------#
# UI script                                                                #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version                          #
#--------------------------------------------------------------------------#


ui <- fluidPage(  

  titlePanel(tags$h1("Public Health Priorities in Scotland")),
  fluidRow(tags$br()),
  fluidRow(
    box(
      width = 12,
      background = "teal",
      fluidRow(style = "padding-left : 2%" ,
              tags$h3("This dashboard contains an overview of Scottish public
                        health over the past 5-10 years mainly focussing on Life Expectancy,
                      Smoking and Drug Abuse topics."),
              tags$h3("It summarises the key statistics of these 
                      three topics based on temporal, geographic and demographic perspective.")),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(style = "padding-left : 10% ;",
               column(
                 width = 4,
                 use_hover(),
                 hover_action_button(style = "padding-top : 25% ;
                              padding-left : 25% ;
                              padding-right : 25% ;
                              padding-bottom :25% ;  
                              color: #ffffff;
                              background-color: #3481ad; 
                              border-color: #ffffff",
                              inputId = 'jumpToTrend',
                              label = tags$h1("Trend"), 
                              icon = icon("line-chart", "fa-3x"),
                              title="Explore how indicators change over Time",
                              button_animation = "bounce-in",
                              icon_animation = "icon-pulse-grow")
               ),
               
               column(
                 width = 4,
                 use_hover(),
                 hover_action_button(style = "  padding-top : 25% ;
                                padding-left : 25% ;
                                padding-right : 25% ;
                                padding-bottom :25% ;   
                                color: #ffffff;
                                background-color: #f5b942; 
                                border-color:  #ffffff",
                                inputId = 'jumpToRank',
                                label = tags$h1("Rank"),
                                icon = icon("bar-chart-o", "fa-3x"),
                                title = "Compare the indicators using Bar Chart" ,
                                button_animation = "bounce-in",
                                icon_animation = "icon-pulse-grow")
               ),
               column(
                 width = 4,
                 use_hover(),
                 hover_action_button(style = "padding-top : 25% ;
                        padding-left : 25% ;
                        padding-right : 25% ;
                        padding-bottom :25% ;   
                        color: #ffffff;
                        background-color: #33b07a; 
                        border-color:  #ffffff",
                        inputId ='jumpToMap',
                        label = tags$h1("Map"),
                        icon = icon("globe", "fa-3x"),
                        title = "Compare indicators between geographies using Map",
                        button_animation = "bounce-in",
                        icon_animation = "icon-pulse-grow")
                 
               ),
      ),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br()),
      fluidRow(tags$br())
    )
  )
)
