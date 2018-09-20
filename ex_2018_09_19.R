## Exercise 1

library(coda)
data(line,package = "coda")
d = as_data_frame(line[["line1"]])

tidy_d = d %>% 
  mutate(
    iteration = 1:n()
  ) %>%
  gather(
    parameter, value,
    #alpha:sigma
    -iteration
  )
  
  
tidy_d %>%
  group_by(parameter) %>%
  summarize(
    post_mean = mean(value),
    post_med  = median(value)
  )

library(ggplot2)

ggplot(tidy_d, aes(x=iteration, y=value, color=parameter)) + 
  geom_line() + 
  facet_wrap(~parameter)


## Exercise 2

# View(sw_people)

library(repurrrsive)


sw_people = rep(sw_people, 10)

sw_for_loop = function() {
  res = c()
  for(char in sw_people) {
    res = c(res, char[["name"]])
  }
  res
}

sw_lapply = function() {
  lapply(sw_people, function(x) x[["name"]]) %>% unlist()
}

sw_sapply = function() {
  sapply(sw_people, function(x) x[["name"]])
}



bench::mark(
  sw_for_loop(),
  sw_lapply(),
  sw_sapply()
)


## Exercise 3

