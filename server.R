library(shiny)
library(RSQLite)
library(DBI)
library(jsonlite)  
library(rgdal)
#library(tidyverse)
library(dplyr)
library(stringr)
library(ggplot2)
library(tidyr)


## Source functions
source("server_functions/plot_functions.R", local = TRUE)
source("server_functions/db_functions.R", local = TRUE)
con <- dbConnect(RSQLite::SQLite(), "database/covid_data.db", local = TRUE)

## Reading shp file
shp <- readOGR(dsn = "server_functions/Shapefiles/Wojewodztwa.shp",
               use_iconv=TRUE,
               encoding = "UTF-8"
               )
## Adjusting names of regions in SHP files to match them easily in function which creates day map plot
shp$JPT_NAZWA_ <- stringr::str_to_title(shp$JPT_NAZWA_)


shinyServer(function(input, output, session) {
  

  ## Updating db data if needed
  
  
  
  ## Type of inputs in UI depends on the choice of plot type in the first select field
  ## Function below is responsible for this task
  
  
  observeEvent(input$plotType, {
    
    
    
    ## Dates are common for three versions of plots
    dates <- dbGetQuery(con, "SELECT DISTINCT (Date) FROM Data")
    dates <- unlist(dates, use.names = FALSE)
    req(dates)
    
    req(input$plotType)
    if (input$plotType != 'Map daily'){
      
      print("not map")
      ## Loading regions matters for barplot and time plot
      regions <- dbGetQuery(con, "SELECT DISTINCT (region) FROM Data")
      regions <- unlist(regions, use.names = FALSE)
      regions <- sort(regions)
      
    
      output$secondSelection <- renderUI({
        checkboxGroupInput(inputId = "Regions", "Regions: ", choices = regions)
        
      })
      
      ############################################################# Time plot code ################################################################
      ## For time plot we have date ranges, not a specific date
      if (input$plotType == 'Time Series Plot'){

        min_date <- min(dates)
        max_date <- max(dates)

        output$thirdSelection <- renderUI({

          dateRangeInput("Dates_tsPlot",
                         "Dates:",
                         start = min_date,
                         end = max_date,
                         min = min_date,
                         max = max_date)

        })
        
        
        ## Creating the event which will react on any change 
        toListen <- reactive({
          list(input$Regions,input$Dates_tsPlot)
        })

        observeEvent(toListen(), {

          # Getting data about selected regions
          selected_regions <- input$Regions

          # Getting dates
          selected_dates <-  input$Dates_tsPlot

          ## Converting dates to vector and extracting min and max date for sql query
          selected_dates <- unlist(str_split(selected_dates, " "))
          min_selected_date <- selected_dates[1]
          max_selected_date <- selected_dates[2]
          
          ## This function is defined in separate file - plot_functions.R
          plt <- time_series_plot(min_selected_date, max_selected_date, selected_regions, 20)

          output$Plot <- renderPlot(plt)




        })

        


      }
      
      ##################################################################### Barplot Code #################################################################
      
      ## This condition is for Barplot. Barplot can be presented, by the assumption here, only for a specific day. 
      ## Therefore, date range, which is specified for In time plot, does not make sense
      else{
        
        
        output$thirdSelection <- renderUI({
          selectInput(inputId = "Dates_Barplot", "Date: ", choices = dates)
          
        
          
      })
        
        
        toListen <- reactive({
          list(input$Regions,input$Dates_Barplot)
        })
        
        observeEvent(toListen(), {
          
          # Getting data about selected regions
          selected_regions <- input$Regions
          
          # Getting dates
          selected_date <-  input$Dates_Barplot
          
          print(selected_date)
          ## Converting dates to vector and extracting min and max date for sql query
          
          
          ## This function is defined in separate file - plot_functions.R
          plt <- bar_plot(selected_date, selected_regions, 20)
          
          output$Plot <- renderPlot(plt)
          
          
          
          
        })  
      
        
      }
      
    }
    
    
    ## This condition is for map. The region does not matter, but the date does
    else{
      
      print("map")
      output$secondSelection <- renderUI({
        selectInput(inputId = "Date_Map", "Date: ", choices = dates)
      })
      
      output$thirdSelection <- renderUI(NULL)
      
      observeEvent(input$Date_Map, {
        
        
        selected_date <- input$Date_Map
        req(selected_date)
        map <- map_plot(selected_date, 20)
        output$Plot <- renderPlot({map})
        
      })
      
      
      
    }
    
    
  })
  
  ### Saving plot to HTML with markdown 
  app_directory <- getwd()
  
  output$SavePlot <- downloadHandler(
    filename = "report.html",
  
  # observeEvent(input$SavePlot, {
    
    content = function(file){
      
      if (input$plotType == 'Time Series Plot'){
      
      selected_regions <- input$Regions
      
      # Getting dates
      selected_dates <-  input$Dates_tsPlot
      
      ## Converting dates to vector and extracting min and max date for sql query
      selected_dates <- unlist(str_split(selected_dates, " "))
      min_selected_date <- selected_dates[1]
      max_selected_date <- selected_dates[2]
      
      ## This function is defined in separate file - plot_functions.R
      params <- list(min_date = min_selected_date, 
                     max_date = max_selected_date, 
                     regions = selected_regions, 
                     app_dir = app_directory, 
                     connection = con)
      
      # tempReport <- file.path(getwd(), "markdown/output.Rmd")
      # rmarkdown::render(tempReport, 
      #                  output_file = file, 
      #                  params = params,
      #                  envir = new.env(parent = globalenv())
      
      report_path <- tempfile(fileext = ".Rmd",tmpdir="/tmp")
      file.copy("markdown/markdown.css", "/tmp/markdown.css")
      file.copy("markdown/output.Rmd", report_path, overwrite = TRUE)
      
      rmarkdown::render(report_path, 
                        output_file = file, 
                        params = params,
                        envir = new.env(parent = globalenv())
      )
      
      
      
      
    } else if (input$plotType == 'Barplot daily'){
      
      selected_regions <- input$Regions
      
      # Getting dates
      selected_date <-  input$Dates_Barplot
      
    
      
      ## This function is defined in separate file - plot_functions.R
      params <- list(min_date = selected_date,
                     max_date = NA, 
                     regions = selected_regions, 
                     app_dir = app_directory, 
                     connection = con)
      
      # tempReport <- file.path(getwd(), "markdown/output.Rmd")
      # rmarkdown::render(tempReport, 
      #                  output_file = file, 
      #                  params = params,
      #                  envir = new.env(parent = globalenv())
      
      report_path <- tempfile(fileext = ".Rmd",tmpdir="/tmp")
      file.copy("markdown/markdown.css", "/tmp/markdown.css")
      file.copy("markdown/output.Rmd", report_path, overwrite = TRUE)
      
      rmarkdown::render(report_path, 
                        output_file = file, 
                        params = params,
                        envir = new.env(parent = globalenv())
      )
    } else{ 
      
      
      
      
      # Getting dates
      selected_date <-  input$Date_Map
      
      
      
      ## This function is defined in separate file - plot_functions.R
      params <- list(min_date = selected_date,
                     max_date = NA, 
                     regions = NA, 
                     app_dir = app_directory, 
                     connection = con)
      
      # tempReport <- file.path(getwd(), "markdown/output.Rmd")
      # rmarkdown::render(tempReport, 
      #                  output_file = file, 
      #                  params = params,
      #                  envir = new.env(parent = globalenv())
      
      report_path <- tempfile(fileext = ".Rmd",tmpdir="/tmp/R")
      file.copy("markdown/output.Rmd", report_path, overwrite = TRUE)
      
      rmarkdown::render(report_path, 
                        output_file = file, 
                        params = params,
                        envir = new.env(parent = globalenv())
      )
      
      
      
      }
    })
    
    
  # })
  
  
  
  
}
  
)  
