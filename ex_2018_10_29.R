library(shiny)
library(ggplot2)
library(dplyr)

#options(shiny.reactlog = TRUE) 

pal = c("#7fc97f", "#beaed4", "#fdc086")

shinyApp(
  ui = fluidPage(
    titlePanel("Beta-Binomial App"),
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        numericInput("sims","Number of prior draws:", value=1e5),
        actionButton("run", "Run ABC Simulation"),
        h4("Data:"),
        sliderInput("x", "# of heads", 0, 100, value = 8),
        sliderInput("n", "# of flips", 0, 100, value = 10),
        h4("Prior:"),
        sliderInput("alpha", "Prior number of successes", 0, 100, value = 5),
        sliderInput("beta", "Prior number of failures", 0, 100, value = 5),
        h4("Options:"),
        checkboxInput("facet", "Facet Distributions", value=FALSE),
        checkboxInput("bw", "Use theme_bw()", value=TRUE)
      ),
      mainPanel = mainPanel(
        plotOutput("dists")
      )
    )
  ),
  server = function(input, output, session) {
    
    observeEvent(
      input$n,
      {
        updateSliderInput(session, "x", max = input$n)
      }
    )
    
    prior = eventReactive(
      input$run,  
      {
        print("Generating Prior ...")
        rbeta(input$sims, input$alpha, input$beta)
      }
    )
    
    gen_process = eventReactive(
      prior(),
      {
        print("Generative Process ...")
        rbinom(input$sims, input$n, prior())
      }
    )
    
    posterior = eventReactive(
      gen_process(),
      {
        print("Subsetting Posterior draws ...")
        prior()[gen_process() == input$x]
      }
    )
    
    
    
    output$dists = renderPlot({
      
      #if (input$sims > 2e6 | input$sims < 1e3)
      #  return()
   
      req(input$sims)
      
      validate(
        need(input$sims <= 2e6, "Number of sims should be less than 2,000,000."),
        need(input$sims >= 1e3, "Number of sims should be more than 1000.")
      )
      
      #d = data_frame(
      #  p = seq(0, 1, length.out = 1000)
      #) %>%
      #  mutate(
      #    prior = dbeta(p, input$alpha, input$beta),
      #    likelihood = dbinom(input$x, input$n, p),
      #    posterior = dbeta(p, input$alpha+input$x, input$beta+input$n-input$x)
      #  ) %>% 
      #  mutate_at( # Normalize distributions
      #    vars(-p),
      #    function(x) { x / sum(x /length(x)) }
      #  ) %>%
      #  tidyr::gather(distribution, density, -p) %>%
      #  mutate(distribution = forcats::as_factor(distribution))
      
      abc_posterior = data_frame(
        posterior = posterior()
      )
      
      #g = ggplot(d, aes(x = p, color = distribution, fill=distribution)) +
      #  geom_line(aes(y = density)) +
      #  geom_ribbon(aes(ymax=density), ymin = 0, alpha=0.2, color=NA) +
      #  scale_color_manual(values = pal) +
      #  scale_fill_manual(values = pal) +
      g = ggplot() +
        geom_density(data = abc_posterior, aes(x = posterior), 
                     color = NA, fill = "blue", alpha=0.2)
      
      if (input$facet) 
        g = g + facet_wrap(~distribution, scale="free_y")
      if (input$bw) 
        g = g + theme_bw()
      
      g
    })
  }
)
