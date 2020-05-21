update_data <- function(){
  
  
  
  regions_original <- read.csv('database/regions_original.csv')
  regions_original <- as.vector(unlist(regions_original$x, use.names = F))
  
  ## The names however are not formatted in polish, so they are converted with the list below
  regions_correct <- read.csv('database/regions_correct.csv')
  regions_correct <- as.vector(unlist(regions_correct$x, use.names = F))
  
  
  ## Getting maxdate
  con <- dbConnect(RSQLite::SQLite(), "database/covid_data.db")
  db_data <- dbReadTable(con, "Data")
  max_date <- db_data$Date %>% max()
  
  
  
  df <- fromJSON("https://api.apify.com/v2/key-value-stores/3Po6TV7wTht4vIEid/records/LATEST?disableRedirect=true")
  data <- df$infectedByRegion
  data["Date"] <- df$lastUpdatedAtApify
  data <- data %>% mutate(Date = as.Date(format(as.POSIXct(Date, "UTC", "%Y-%m-%d")), "%Y-%m-%d"))  
  
  if (data$Date %>% unique() != max_date) {
    data <- data %>% mutate(Date = as.character(Date))
    data$region <- plyr::mapvalues(data$region, regions_original, regions_correct)
    
    
    dbWriteTable(con, "Data", data, append = TRUE, row.names = FALSE)  
    dbDisconnect(con)  
  }
  
  else{
    
    dbDisconnect(con)
  }
  
}

