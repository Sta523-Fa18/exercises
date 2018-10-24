library(shiny)
library(ggplot2)
library(dplyr)

pal = c("#7fc97f", "#beaed4", "#fdc086")
pal_names = c("Green","Purple","Orange")

shinyApp(
  ui = fluidPage(
    titlePanel("Beta-Binomial App"),
    sidebarLayout(
      sidebarPanel = sidebarPanel(
        h4("Data:"),
        sliderInput("x", "# of heads", 0, 100, value = 8),
        sliderInput("n", "# of flips", 0, 100, value = 10),
        h4("Prior:"),
        sliderInput("alpha", "Prior number of successes", 0, 100, value = 5),
        sliderInput("beta", "Prior number of failures", 0, 100, value = 5),
        h4("Options:"),
        checkboxInput("facet", "Facet Distributions", value=FALSE),
        checkboxInput("bw", "Use theme_bw()", value=TRUE),
        checkboxInput("pick_colors", "Pick Distribution Colors", value=FALSE),
        conditionalPanel(
          "input.pick_colors == true",
          selectInput("prior", "Color for Prior", choices = pal_names, selected = pal_names[1]),
          selectInput("likelihood", "Color for Likelihood", choices = pal_names, selected = pal_names[2]),
          selectInput("posterior", "Color for Posterior", choices = pal_names, selected = pal_names[3])
        )
        
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
    
    observeEvent(
      input$prior,
      {
        if (input$prior == input$likelihood) {
          updateSelectInput(session, "likelihood", selected = setdiff(pal_names, c(input$prior, input$posterior)))
        } else if (input$prior == input$posterior) {
          updateSelectInput(session, "posterior", selected = setdiff(pal_names, c(input$prior, input$likelihood)))
        }
      }
    )
    
    observeEvent(
      input$likelihood,
      {
        if (input$likelihood == input$prior) {
          updateSelectInput(session, "prior", selected = setdiff(pal_names, c(input$likelihood, input$posterior)))
        } else if (input$likelihood == input$posterior) {
          updateSelectInput(session, "posterior", selected = setdiff(pal_names, c(input$prior, input$likelihood)))
        }
      }
    )
    
    observeEvent(
      input$posterior,
      {
        if (input$posterior == input$likelihood) {
          updateSelectInput(session, "likelihood", selected = setdiff(pal_names, c(input$prior, input$posterior)))
        } else if (input$posterior == input$prior) {
          updateSelectInput(session, "prior", selected = setdiff(pal_names, c(input$posterior, input$likelihood)))
        }
      }
    )
    
    
    output$dists = renderPlot({
      color_choices = c(
        which(pal_names == input$prior), 
        which(pal_names == input$likelihood),
        which(pal_names == input$posterior)
      )
      
      color_pal = pal[color_choices]
      
      d = data_frame(
        p = seq(0, 1, length.out = 1000)
      ) %>%
        mutate(
          prior = dbeta(p, input$alpha, input$beta),
          likelihood = dbinom(input$x, input$n, p),
          posterior = dbeta(p, input$alpha+input$x, input$beta+input$n-input$x)
        ) %>% 
        tidyr::gather(distribution, density, -p) %>%
        mutate(distribution = forcats::as_factor(distribution))
      
      g = ggplot(d, aes(x = p, y = density, color = distribution, fill=distribution)) +
        geom_line() +
        geom_ribbon(aes(ymax=density), ymin = 0, alpha=0.2, color=NA) +
        scale_color_manual(values = color_pal) +
        scale_fill_manual(values = color_pal)
      
      if (input$facet) {
        g = g +facet_wrap(~distribution, scale="free_y")
      }
      
      if (input$bw) {
        g = g + theme_bw()
      }
      
      g
    })
  }
)
