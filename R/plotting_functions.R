#--------------------------------------------------------------------------#
# Helper file to plot the data                                             #
#--------------------------------------------------------------------------#
# Version         | Name        | Remarks                                  #
#--------------------------------------------------------------------------#
# 1.0             | Prathiba.R  | Initial Version; Created function        #
#                 |             | structure                                #
# 1.1             | Derek       | Updated plot for Life expectancy         #
# 1.2             | JP          | Updated plot for Drug Abuse              #
# 1.3             | John Paul   | Updated plot for Smoking                 #
#--------------------------------------------------------------------------#

# Function to create a theme for the plot-----------------------------------------
color_theme <- function() {
  theme(
    plot.background = element_rect(fill = "white"),
    plot.title = element_text(size = rel(2)),
    plot.title.position = "plot",
    panel.border = element_rect(colour = "blue", fill = NA, linetype = 1),
    panel.background = element_rect(fill = "white"),
    panel.grid = element_line(colour = "grey85", linetype = 1, size = 0.5),
    axis.text = element_text(colour = "blue", face = "italic", size = 14),
    axis.title.y = element_text(colour = "#1B732B", size = 14, angle = 90),
    axis.title.x = element_text(colour = "#1B732B", size = 14),
    legend.box.background = element_rect(),
    legend.box.margin = margin(6, 6, 6, 6)
  )
}

# Function to Plot Trend Page based on user choice--------------------------------

# Life Expectancy Plot for Trend Page -------------------------------------------
make_trend_plot <- function(data, user_choice, topic_input) {
  if (topic_input == "Life Expectancy") {
    
    p <- ggplot(data) +
      aes(x = date_code, y = mean_le, group = sex, colour = sex) +
      geom_point(alpha = 0.8)+
      geom_line() +
      geom_ribbon(aes(ymax = mean_le_upper_ci, ymin = mean_le_lower_ci), alpha = 0.25, colour = NA) +
      theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
      labs(
        x = "\n\nYear",
        y = "Life Expectancy (years)\n",
        colour = "Sex"
      ) +
      color_theme()
    return(p)
  } else {
    # Drug Abuse Plot for Trend Page ---------------------------------------------
    if (topic_input == "Drug Abuse") {
      if (user_choice == "Age") {
        return(data %>%
          ggplot(aes(x = year, y = number_assessed_total, group = age, colour = age)) +
          geom_point() +
          geom_line() +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Patients Assessed\n",
            colour = "Age"
          ) +
          color_theme())
      } else {
        return(data %>%
          ggplot(aes(x = year, y = number_assessed_total, group = sex, colour = sex)) +
          geom_point() +
          geom_line() +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Patients Assessed\n",
            colour = "sex"
          ) +
          color_theme())
      }
    }

    # Smoking Plot for Trend Page ---------------------------------------------

    else {
      if (user_choice == "Gender") {
        return(data %>%
          ggplot(aes(x = date_code, y = sm_percent, group = sex, colour = sex)) +
          geom_point() +
          geom_line() +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
          labs(
            x = "\nYear",
            y = "All Smokers (%)\n",
            colour = "Sex"
          ) +
          color_theme())
      } else {
        return(data %>%
          ggplot(aes(x = date_code, y = sm_percent, group = age, colour = age)) +
          geom_point() +
          geom_line() +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
          labs(
            x = "\nYear",
            y = "All Smokers (%)\n",
            colour = "Age"
          ) +
          color_theme())
      }
    }
  }
}

# Function to plot rank page based on user choice------------------------------
make_rank_plot <- function(data, topic_input, select_input) {
  if (topic_input == "Life Expectancy") {
    if (select_input == "Highest 5") {
      return(data %>%
        ggplot() +
        aes(x = reorder(name, le_value), y = le_value, fill = le_value) +
        geom_col() +
        ylim(0, 100) +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
        labs(
          x = "Data Zone",
          y = "Life Expectancy (years)\n",
          fill = "Life Expectancy Percentage"
        ) +
        scale_fill_distiller(palette = "YlGn") +
        color_theme())
    } else {
      return(data %>%
        ggplot() +
        aes(x = reorder(name, le_value), y = le_value, fill = le_value) +
        geom_col() +
        ylim(0, 100) +
        theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
        labs(
          x = "Data Zone",
          y = "Life Expectancy (years)\n",
          fill = "Life Expectancy Percentage"
        ) +
        scale_fill_distiller(palette = "YlOrRd") +
        color_theme())
    }
  } else {
    if (topic_input == "Drug Abuse") {
      if (select_input == "Highest 5") {
        # Five Highest Areas for drug abuse
        return(data %>%
          ggplot() +
          aes(x = reorder(name, number_assessed), y = number_assessed, fill = number_assessed) +
          geom_col() +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Patients Assessed\n"
          ) +
          scale_fill_distiller(palette = "YlGn") +
          color_theme())
      } else {
        # Five Highest Areas for drug abuse
        return(data %>%
          ggplot() +
          aes(x = reorder(name, number_assessed), y = number_assessed, fill = number_assessed) +
          geom_col() +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Patients Assessed\n"
          ) +
          scale_fill_distiller(palette = "YlOrRd") +
          color_theme())
      }
    } else {
      if (select_input == "Highest 5") {
        return(data %>%
          ggplot() +
          aes(x = reorder(name, sm_percent), y = sm_percent, fill = sm_percent) +
          geom_col() +
          ylim(0, 100) +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Smokers (%)\n"
          ) +
          scale_fill_distiller(palette = "YlGn") +
          color_theme())
      } else {
        return(data %>%
          ggplot() +
          aes(x = reorder(name, sm_percent), y = sm_percent, fill = sm_percent) +
          geom_col() +
          ylim(0, 100) +
          theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust = 1)) +
          labs(
            x = "Data Zone",
            y = "Number of Smokers (%)\n"
          ) +
          scale_fill_distiller(palette = "YlOrRd") +
          color_theme())
      }
    }
  }
}
