library(shiny)

# define functions, fixed data, etc here.


ui <- fluidPage(
  #title
  titlePanel("<<title here>>"),
  sidebarLayout(
    sidebarPanel(
      
      # first toggle bar code
      sliderInput(inputId = "<<id here>>",
                  label = "<<label here>>",
                  min = , max = ,
                  value = , step = ),
      
      # second toggle bar code
      sliderInput(inputId = "<<id here>>",
                  label = "<<label here>>",
                  min = , max = ,
                  value = , step = ) # add comma and more slider input if more toggles desired
    ),
    # output
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output){
  output$plot <- renderPlot({
    
    # code to produce plot goes here
    
  })
}

# launch the app
shinyApp(ui = ui, server = server)