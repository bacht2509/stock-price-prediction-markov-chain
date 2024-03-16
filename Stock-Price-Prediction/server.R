#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)

# Define server logic required to draw a histogram
function(input, output, session) {
  output$stockTable <- renderTable({
    # Get the selected stock symbol
    symbol <- input$symbol
    # Get stock data
    data <- getSymbols(symbol, from = "2022-01-01", to = Sys.Date(), auto.assign = F)
    data <- na.omit(data)
    data_df <- as.data.frame(data)
    data_df$dates <- as.Date(index(data))
    rownames(data_df) <- NULL
    # Show data in a table
    return(head(rev(data_df), n = 15))
  })
}
