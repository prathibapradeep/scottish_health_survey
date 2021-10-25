#--------------------------------------------------------------------------#
# UI for Trend Page                                                        #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             |             | Initial Version                          #
#--------------------------------------------------------------------------#

ui <- fluidPage(
  fluidRow(
  titlePanel(tags$h1("About")),
    
    box(
      width = 12,
      background = "teal",
      fluidRow(tags$br()),
      HTML("
           
<h2>Life Expectancy: </h2> 

<p style='text-align:justify'>
<ul>
<li>Life expectancy refers to the number of years that a person could expect to survive if the current mortality rates for each age group, sex and geographic area remain constant throughout their life. </li>
<li> This is referred to as 'period life expectancy' and does not usually reflect the actual number of years that a person will survive.</li>
<li>This is because it does not take into account changes in health care and other social factors that may occur through someone's lifetime.</li>
<li>However, life expectancy is a useful statistic as it provides a snapshot of the health of a population and allows the identification of inequalities between populations.</li>
</ul>
<br>
<p><b><i>Data : </i></b></p> 
<p>The data is published by the <b><a href ='https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2FLife-Expectancy'> Scottish Government </b> </a> and contains information on life expectancy, at birth and for age groups.</p>

<h2>Scottish Drugs Misuse: </h2>

<p style='text-align:justify'>
<ul>
<li>Harm from the use of alcohol and drugs is a major public health problem in Scotland. </li>
<li>Such harm, from both ill health and early death, is disproportionately experienced by the most vulnerable in our communities.</li>
<li>Access to timely, compassionate, person centred services saves lives.</li>
</ul>
<br>
<p><b><i>Data : </i></b></p> 

The data is published by <b><a href = https://www.opendata.nhs.scot/dataset/scottish-drug-misuse-database> Public Health Scotland </b> </a> and contains information on the number of individuals presenting for assessment at specialist drug treatment services in Scotland at health board level, broken down by age and sex.</p>

<h2>Smoking - Scottish Survey Core Questions: </h2>

<p style='text-align:justify'>
<ul>
<li>Two of the Scottish Government's National Performance Framework (NPF) National Indicators are relevant to smoking.</li>
<li>There is a specific indicator on reducing the proportion of adults who are current smokers, as well as a more general indicator on reducing premature mortality (deaths from all causes in those aged under 75), for which smoking is a significant contributory factor.</li> 
</ul>
<br>
<p><b><i>Data : </i></b></p> 

The data published by the <b><a href = https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fsmoking-sscq> Scottish Government</b> </a> contains information on current smokers by current smokers by tenure, household type, age, sex and disability.</p>
"),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br()),
fluidRow(tags$br())
)))
