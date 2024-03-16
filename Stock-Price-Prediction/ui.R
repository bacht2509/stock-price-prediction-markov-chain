#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Stock Price Prediction"),

    sidebarLayout(
        sidebarPanel(
            selectInput("symbol", "Chọn mã cổ phiếu:",
                      c("BID - Joint Stock Commercial Bank for Investment and Development of Vietnam" = "BID.VN",
                        "VCB - Joint Stock Commercial Bank for Foreign Trade of Vietnam" = "VCB.VN",
                        "FPT - FPT Corporation" = "FPT.VN",
                        "TCB - Vietnam Technological and Commercial Joint Stock Bank" = "TCB.VN"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tableOutput("stockTable")
        )
    )
)
