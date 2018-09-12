library(dplyr)
library(nycflights13)

# Example 1

# How many and what was their average duration?
flights %>%
  filter(dest == "LAX") %>%                        # flights to Los Angeles (LAX) 
  filter(carrier %in% c("AA","DL","UA","US"))  %>% # did each of the legacy carriers (AA, UA, DL or US) 
  filter(month == 5) %>%                           # have in May 
  filter(origin == "JFK") %>%                      # from JFK, 
  group_by(carrier) %>%  
  summarize(
    n = n(),
    avg_dur = mean(air_time, na.rm=TRUE)
  )
  

# Example 2
# What was the shortest flight out of each airport in terms of distance? In terms of duration?

flights %>%
  group_by(origin) %>%
  filter(distance == min(distance)) %>%
  select(origin, dest, carrier, distance) %>%
  arrange(origin, distance) %>%
  distinct()

?top_n

# Exercise 1
# Which plane (check the tail number) flew out of each New York airport the most?

flights %>%
  group_by(origin, tailnum) %>%
  filter(!is.na(tailnum)) %>%
  summarize(n = n()) %>%
  filter(n == max(n))

# Exercise 2
# Which date should you fly on if you want to have the lowest possible average departure delay? What about arrival delay?

flights %>%
  mutate(date = paste(year, month, day, sep="/")) %>%
  group_by(date) %>%
  mutate(dep_delay = ifelse(dep_delay < 0, 0, dep_delay)) %>%
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(avg_dep_delay == min(avg_dep_delay))

