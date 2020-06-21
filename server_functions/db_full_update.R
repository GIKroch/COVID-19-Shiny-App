if(!require(RSQLite)){
  install.packages("RSQLite")
  library(RSQLite)
}
library(DBI)
library(jsonlite)
library(tidyverse)


## Reading JSON
df <- fromJSON("https://api.apify.com/v2/datasets/L3VCmhMeX0KUQeJto/items?format=json&clean=1")




for (i in 1:nrow(df)){
  
  
  
  data <- df[i,"infectedByRegion"][[1]]
  data <- data %>% select(region, infectedCount, deceasedCount)
  data["Date"] <- df[i, "lastUpdatedAtApify"]
  
  
  ## Converting Date column to proper format
  
  data <- data %>% mutate(Date = as.Date(format(as.POSIXct(Date, "UTC", "%Y-%m-%d")), "%Y-%m-%d"))
  # max_hour <- data$Date %>% max()
  # data <- data %>% filter(Date == max_hour)
  # 
  if (i == 1){
    long_df <- data 
    
  }
  else{
    long_df <- rbind(long_df, data)  
  }
  
  
}


long_df

regions <- long_df$region %>% unique()
regions <- regions[1:17]
regions
# write.csv(regions, "regions_original.csv", row.names = FALSE)
regions <- regions[regions != "Cala Polska"]

regions
regions_correct <- c("Œl¹skie", "Dolnoœl¹skie", "Pomorskie", "Lubelskie", "Ma³opolskie", "Podkarpackie", "£ódzkie", 
                     "Warmiñsko-Mazurskie", "Œwiêtokrzyskie", "Mazowieckie", "Zachodniopomorskie", "Wielkopolskie", 
                     "Lubuskie", "Opolskie", "Kujawsko-Pomorskie", "Podlaskie"
                     )


long_df <- long_df %>% filter(region %in% regions)


long_df$region <- plyr::mapvalues(long_df$region, regions, regions_correct)
long_data <- as.data.frame(long_df %>% group_by(Date, region) %>% summarise(
                                      infectedCount = max(infectedCount), 
                                      deceasedCount = max(deceasedCount)))

                                         
long_data <- long_data %>% filter(Date != '2020-05-12')
long_data["ID"] <- row.names(long_data)
long_data <- long_data %>% mutate(Date = as.character(Date))
long_data <- long_data %>% select(ID, Date, region, infectedCount, deceasedCount)




con <- dbConnect(RSQLite::SQLite(), "C:/Users/grzeg/Desktop/covid_data.db")
dbWriteTable(con, "Data", long_data, field.types = c(ID = "Integer Primary Key"))
dbDisconnect(con)


###

df <- fromJSON("https://api.apify.com/v2/key-value-stores/3Po6TV7wTht4vIEid/records/LATEST?disableRedirect=true")


update_db <- function(con){
  
  df <- fromJSON("https://api.apify.com/v2/datasets/L3VCmhMeX0KUQeJto/items?format=json&clean=1")
  
  
  
}