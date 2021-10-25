#--------------------------------------------------------------------------#
# UI script                                                                #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version                          #
#--------------------------------------------------------------------------#
header <-  dashboardHeader(
  
  ### changing logo
  title = shinyDashboardLogo(
    theme = "blue_gradient",
    boldText = "SHS",
    mainText = "App",
    badgeText = "v1.1"
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "tabs",
    menuItem("Overview", tabName = "home_tab" ),
    menuItem("Trend", tabName = "trend_tab" ),
    menuItem("Rank", tabName = "rank_tab" ),
    menuItem("Map", tabName = "map_tab" ),
    menuItem("About", tabName = "about_tab" )
  )
)

body <- dashboardBody(
  shinyDashboardThemes(
    theme = "blue_gradient"
  ),
  
  # css ---------------------------------------------------------------------
  includeCSS("styles.css"),
  
  # Main Page ---------------------------------------------------------------
  
  # tabitems ----------------------------------------------------------------
  tabItems( 
    tabItem(tabName = "home_tab",source("ui_home.R", local = TRUE)$value),
    tabItem(tabName = "trend_tab",source("ui_trend.R", local = TRUE)$value),
    tabItem(tabName = "rank_tab",source("ui_rank.R", local = TRUE)$value),
    tabItem(tabName = "map_tab",source("ui_map.R", local = TRUE)$value),
    tabItem(tabName = "about_tab",source("ui_about.R", local = TRUE)$value)
  )
)

ui <- dashboardPage( title = "Public Health Priorities in Scotland",
                     header ,
                     sidebar,  
                     body
                     )


