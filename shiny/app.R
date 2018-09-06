library(shiny)

ui <- fluidPage(
  
  sidebarPanel(selectInput("kat", "kategorije", 
                           choices = c("DRUGE NESREČE", "NESREČE V PROMETU", "POŽARI IN EKSPLOZIJE", "JEDRSKI IN DRUGI DOGODKI", "NARAVNE NESREČE", "ONESNAŽENJA, NESREČE Z NEVARNIMI SNOVMI", "TEHNIČNA IN DRUGA POMOČ", "NAJDBE NUS, MOTNJE OSKRBE IN POŠKODBE OBJEKTOV"))),
  
  mainPanel(
    plotOutput("plot")
    )
)

server <- function(input, output, session){
  output$plot <- renderPlot({vrsta.intervencij(input$kat)})
}

shinyApp(ui, server)
