#--------------------------------------------------------------------------#
# Helper file which contains the library & load the data file necessary    #
# for the app                                                              #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba    | Initial Version                          #
#--------------------------------------------------------------------------#

library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(dashboardthemes)
library(hover)
library(here)
library(tidyverse)
library(ggplot2)
library(RColorBrewer)
library(shinyBS)
library(sf)
library(leaflet)
library (DT)
library(plotly)


source (here("analysis/load_clean_data.R"))

color_theme <- function() {
  theme(

    plot.background = element_rect(fill ="white"),
    plot.title = element_text(size = rel(2)),
    plot.title.position = "plot",

    panel.border = element_rect(colour = "blue", fill = NA, linetype = 1),
    panel.background = element_rect(fill = "white"),
    panel.grid =  element_line(colour = "grey85", linetype = 1, size = 0.5),

    axis.text = element_text(colour = "blue", face = "italic", size = 14),
    axis.title.y = element_text(colour = "#1B732B" ,  size = 14, angle = 90),
    axis.title.x = element_text(colour = "#1B732B" ,  size = 14),


    legend.box.background = element_rect(),
    legend.box.margin = margin(6, 6, 6, 6)

  )
}
