ui <- shinyUI(

    
  navbarPage("Covid 19 in Poland", 
             theme = 'bootstrap.css', 
             
             
             
             tabPanel("Interactive Plots", 
                      fluid = TRUE, 
                      
                      
                      sidebarLayout(
                        
                        sidebarPanel(width = 4, 
                                     
                                     
                                     selectInput("plotType", "Type of plot: ", choices = c("Time Series Plot", "Barplot daily", "Map daily")),


                                     ## Different inputs, based on plot type selection

                                     uiOutput("secondSelection"),
                                     uiOutput("thirdSelection"),
                                     
                                     
                                     
                                     
      
                        ), 
                        
                        mainPanel(width = 8, 
                                  
                                  plotOutput("Plot", height= '630px'),
                                  
                                  ## Button with css styling
                                  downloadButton("SavePlot", "Save Plot as HTML", 
                                                 style = 'padding: 20px 20px; 
                                                 background-color: peru;
                                                 color: white;
                                                 font-size: 20px; 
                                                 font-weight: bold;
                                                 margin-top: 1em;
                                                 margin-left: 42%;
                                           '),
                                  
                                  # actionButton("SavePlot", "Save Plot as HTML", 
                                  # style = 'padding: 20px 20px; 
                                  #          background-color: peru;
                                  #          color: white;
                                  #          font-size: 20px; 
                                  #          font-weight: bold;
                                  #          margin-top: 1em;
                                  #          margin-left: 42%;
                                  #          ')
                                  
                        ) 
                        
                        
                      )
                      
              )
    )
  
  
)



