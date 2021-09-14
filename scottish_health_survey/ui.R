#--------------------------------------------------------------------------#
# UI script                                                                #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version                          #
#--------------------------------------------------------------------------#


ui <- dashboardPage(
  dashboardHeader(
    ### changing logo
    title = shinyDashboardLogo(
      theme = "blue_gradient",
      boldText = "SHS",
      mainText = "App",
      badgeText = "v1.0"
    )
  ),
  dashboardSidebar(disable = TRUE),
  dashboardBody(

    ### changing theme
    shinyDashboardThemes(
      theme = "blue_gradient"
    ),
    
    # css ---------------------------------------------------------------------
    
    tags$head(
      tags$style(HTML(" @import url('https://fonts.googleapis.com/css2?family=Crimson+Text:ital,wght@1,600&family=Mirza&family=Cookie&display=swap');
                                          body {
                                          }
                                          h1 {
                                            font-family: 'Cookie', serif;
                                            color:#ffffff;
                                            font-size : 80px;  
                                          }
                                          h2 {
                                            font-family: 'Crimson Text', cursive;
                                            color:#000000;
                                          }
                                          h3 {
                                            font-family: 'Mirza', cursive;
                                            color:#000000;
                                          }
                                          .shiny-input-container {
                                            color: #474747;
                                          }
                                        .tabbable > .nav > li > a 
                                        {color:#000000}
                                        .tabbable > .nav > li[class=active] > a 
                                        {background-color: #2f6773; color:white}
                                        .main-header .logo {
                                                            font-family: 'Georgia', Times, 'Times New Roman', serif;
                                                            font-weight: bold;
                                                            font-size: 24px;
                                        }
                                        "
                      
      )
      )
    ),
    

# Main Page ---------------------------------------------------------------

    
  box(title = tags$h1("Public Health Priorities for Scotland"), 
      width = 12,
      background = "teal",
      tabsetPanel(id = "inTabset",
                 tabPanel(title  = tags$h2("Home"), value = "home_panel",
                               source("ui_home.R", local = TRUE)$value
                           ),
                 tabPanel(title = tags$h2("Trend", icon = icon("bar-chart-o")),
                          value = "trend_panel", 
                          source("ui_trend.R", local = TRUE)$value),
                 tabPanel(title = tags$h2("Rank"), value = "rank_panel" ,
                          source("ui_rank.R", local = TRUE)$value),
                 tabPanel(title = tags$h2("Map"),value = "map_panel",  
                          source("ui_map.R", local = TRUE)$value)
                 #,
                 #tabPanel(title = tags$h2("About"),value = "about_panel",  
                #          source("ui_about.R", local = TRUE)$value)
               )
   
  )
)
)

