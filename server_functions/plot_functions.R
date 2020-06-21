time_series_plot <- function(min_selected_date, max_selected_date, selected_regions, font_size){
  
  
  # Sql query
  query <- paste("SELECT * FROM data WHERE region IN (",
                 paste0("'",selected_regions, "'", collapse = ", "), ")",
                 "AND Date(Date) BETWEEN",
                 paste0("'", min_selected_date, "'"),
                 "AND",
                 paste0("'", max_selected_date, "'"))
  
  selected_data <- dbGetQuery(con, query)
  selected_data <- selected_data %>% mutate(Date = as.Date(Date))
  
  plt <- selected_data %>%
    ggplot() +
    geom_line(aes(x = Date,
                  y = infectedCount,
                  group = region,
                  color = region)) +
    theme(axis.text.x = element_text(angle = 90, size = 15), 
          axis.text.y = element_text(size = 20), 
          plot.title = element_text(hjust = 0.5, size = font_size), 
          plot.background = element_rect(fill = "#CD853F", colour = "#CD853F",
                                size = 2, linetype = "solid"), 
          axis.title=element_text(size=14,face="bold"), 
          legend.background = element_rect(fill = "#AFEEEE", color = "#AFEEEE", 
          size = 2, linetype = "solid")) + 
    ggtitle(paste("Count of diagnosed cases per voivodeship from", min_selected_date, "to", max_selected_date)) + 
    scale_x_date(date_breaks = "1 week") + ylab("Count of cases") + xlab("") + labs(color = "Region")
    
  
  
  return(plt)
}


bar_plot <- function(selected_date, selected_regions, font_size){
  
  
  # Sql query
  query <- paste("SELECT * FROM data WHERE region IN (",
                 paste0("'",selected_regions, "'", collapse = ", "), ")",
                 "AND Date(Date) = ",
                 paste0("'", selected_date, "'"))
                
  selected_data <- dbGetQuery(con, query)
  

  plt <- selected_data %>% 
    ggplot() + 
    geom_bar(aes(x = region, 
                 y = infectedCount), 
             stat = 'identity', 
             fill = "#AFEEEE", 
             color = "#CD853F",
             size = 1.5) + 
    theme(axis.text.x = element_text(angle = 90, size = 20, face = "bold"), 
          axis.text.y = element_text(size = 20), 
          plot.title = element_text(hjust = 0.5, size = font_size), 
          plot.background = element_rect(fill = "#CD853F", colour = "#CD853F",
                                size = 2, linetype = "solid"), 
          axis.title=element_text(size=14,face="bold")) + 
    scale_fill_brewer(palette="YlOrRd") + 
    ggtitle(paste("Count of diagnosed cases per voivodeship on", selected_date)) + 
    ylab("Count of cases") + xlab("")
  


  return(plt)
}



map_plot <- function(selected_date, font_size){
  
  
  query <- paste("SELECT * FROM data WHERE Date(Date) = ",
                 paste0("'", selected_date, "'"))
  
  
  data_day <- dbGetQuery(con, query)
  
  shp_day <- sp::merge(shp, data_day, by.x = "JPT_NAZWA_", by.y = "region")
  assign("shp", shp_day, globalenv())
  
  shp_day$infectedCount <- replace_na(shp_day$infectedCount,0)
  
  
  shp_day@data$id <- as.character(c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15))
  
  
  shp.df     <- fortify(shp_day)
  
  shp.df     <- left_join(shp.df,shp_day@data, by="id")
  
  # assign("shp", shp.df, globalenv())
  
  map <- ggplot() + 
    geom_polygon(data = shp.df, aes(x = long, y = lat, group = group, fill = infectedCount), colour = "black") + 
    scale_fill_continuous(limits = c(0, max(shp.df$infectedCount)), breaks = as.vector(quantile(shp.df$infectedCount))) + 
    guides(fill = guide_colourbar(ticks = FALSE, barheight = 15)) +
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          rect = element_blank(), 
          plot.title = element_text(hjust = 0.5, size = font_size)) + 
    ggtitle(paste("Count of diagnosed cases on", selected_date))
  
  
  
  return(map)
  
}

