library(shiny)
library(ggplot2)

# define functions, fixed data, etc here.

# Make simulation for reproductive isolation based on distance
# Start by creating two populations


ui <- fluidPage(
  #title
  titlePanel("<<title here>>"),
  sidebarLayout(
    sidebarPanel(
      
      # first toggle bar code
      sliderInput(inputId = "pop1",
                  label = "Population 1 Mean Flowering Day",
                  min = 0, max = 365,
                  value = 150, step = 5),
      
      # second toggle bar code
      sliderInput(inputId = "pop2",
                  label = "Population 2 Mean Flowering Day",
                  min = 0, max = 365,
                  value = 150, step = 5)
    ),
    # output
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
)

server <- function(input, output){
  output$plot <- renderPlot({
    
    # bring in the variables
    pop1 <- input$pop1
    pop2 <- input$pop2
    sd <- 10
    
    # simulate 1000 individuals in each population
    n <- 1000
    population_1 <- rnorm(n, mean = pop1, sd=sd)
    population_2 <- rnorm(n, mean = pop2, sd=sd)
    
    overlap_1 <- sum(population_1 >= min(population_2) & population_1 <= max(population_2))/n
    overlap_2 <- sum(population_2 >= min(population_1) & population_2 <= max(population_1))/n
    
    prob_1m2 <- overlap_1*n/(overlap_1*n/n)
    prob_1m1 <- n/(overlap_1*n + n)
    
    one_mates <- sample(c(1,2), size=n, replace=T, prob=c(prob_1m1, prob_1m2))
    heterospecific <- sum(one_mates == 2)/n
    conspecific <- 1-heterospecific
    
    # code for the plot
    p1 <- hist(population_1)
    p2 <- hist(population_2)
    plot(p1, col= rgb(0,0,1,.6), xlim=c(0,365), ylim=c(0,225), xlab = "flowering time",
         main = paste0("Overlap 1 = ", overlap_1,
                       " Overlap 2 = ", overlap_2))
    plot(p2, col= rgb(.8,.7,1,.6), add = T)
    
  })
}

# launch the app
shinyApp(ui = ui, server = server)