#--------------------------------------------------------------------------#
# UI script                                                                #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version                          #
#--------------------------------------------------------------------------#


ui <- fluidPage(
  fluidRow(tags$br()),
  fluidRow(
  box(
    width = 12,
    background = "teal",
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
      
      )
    )
  )
  ),

  fluidRow(tags$br()),
  fluidRow(tags$br()),
  fluidRow(HTML("<p>The dashboard includes data on the following topics:</p>
                <h3>Life Expectancy</h3>
<a>https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2FLife-Expectancy</a>
<p style='text-align:justify'>Life expectancy refers to the number of years that a person could expect to survive if the current mortality rates for each age group, sex and geographic area remain constant throughout their life. This is referred to as 'period life expectancy' and does not usually reflect the actual number of years that a person will survive. This is because it does not take into account changes in health care and other social factors that may occur through someone's lifetime. However, life expectancy is a useful statistic as it provides a snapshot of the health of a population and allows the identification of inequalities between populations.
The data published by the Scottish Government contains information on life 
expectancy, at birth and for age groups.</p>

<h3>Scottish Drugs Misuse Database</h3>
<a>https://www.opendata.nhs.scot/dataset/scottish-drug-misuse-database</a>
<p style='text-align:justify'>Harm from the use of alcohol and drugs is a major public health problem in Scotland. Such harm, from both ill health and early death, is disproportionately experienced by the most vulnerable in our communities. Access to timely, compassionate, person centred services saves lives. 
The data published by Public Health Scotland contains information on the number of individuals presenting for assessment at specialist drug treatment services in Scotland at health board level, broken down by age and sex.</p>

<h3>Smoking - Scottish Survey Core Questions</h3>
<a>https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fsmoking-sscq</a>
<p style='text-align:justify'>Two of the Scottish Government's National Performance Framework (NPF) National Indicators are relevant to smoking. There is a specific indicator on reducing the proportion of adults who are current smokers, as well as a more general indicator on reducing premature mortality (deaths from all causes in those aged under 75), for which smoking is a significant contributory factor. 
The data published by the Scottish Government contains information on current smokers by current smokers by tenure, household type, age, sex and disability.</p>
")),
  fluidRow(tags$br()),
  fluidRow(tags$br())
)
