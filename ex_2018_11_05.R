library(dplyr)
library(ggplot2)

nyc = readr::read_csv("/data/nyc_parking/nyc_parking_2014.csv") %>%
  janitor::clean_names() %>%
  select(registration_state:issuing_agency, 
         violation_location, violation_precinct, violation_time,
         number:intersecting_street, vehicle_color) %>%
  mutate(issue_date = mdy(issue_date)) %>% 
  mutate(issue_day = day(issue_date),
         issue_month = month(issue_date),
         issue_year = year(issue_date),
         issue_wday = wday(issue_date, label=TRUE)) %>%
  filter(issue_year %in% 2013:2014)

# 1. Create a plot of the weekly pattern (tickets issued per day of the week) - 
# When are you most likely to get a ticket and when are you least likely to 
# get a ticket?

nyc %>% 
  count(issue_wday) %>%
  ggplot(aes(x = issue_wday, y = n)) +
    geom_point()
  
# 2. Which precinct issued the most tickets to Toyotas?

nyc %>%
  count(violation_precinct, vehicle_make) %>%
  arrange(desc(n)) %>%
  filter(vehicle_make == "TOYOT") %>%
  filter(violation_precinct != 0)
 
