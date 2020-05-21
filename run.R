if(!require(shiny)){
  
  install.packages("shiny")
  library(shiny)
  
}

if(!require(RSQLite)){
  install.packages("RSQLite")
  library(RSQLite)
}


if(!require(DBI)){
  
  install.packages("DBI") 
  library(DBI)
}

if(!require(jsonlite)){
  
  install.packages("jsonlite")
  library(jsonlite)  
}


if(!require(tidyverse)){
  
  install.packages("tidyverse")
  library(tidyverse)
  
}

if(!require(rgdal)){
  
  install.packages("rgdal")
  library(rgdal)
  
}


## Connecting to database

# setwd("C:/Users/grzeg/Desktop/studia/Data Science/2 rok/semestr 2/Reproducible_Research/App")
runApp(appDir = getwd(),
       launch.browser = TRUE,
       port = 4201)

