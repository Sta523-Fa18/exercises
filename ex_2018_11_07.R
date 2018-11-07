library(dplyr)
library(ggplot2)

# nyc = readRDS("/data/nyc_parking/nyc_parking_2014.rds")
nyc_park = nyc %>% 
  transmute(violation_precinct, address = paste(number, street))

library(sf)

pluto = st_read("/data/nyc_parking/pluto_manhattan/", 
                quiet=TRUE, stringsAsFactors = FALSE) %>% 
  as_tibble() %>% st_as_sf() %>% select(address = Address) %>%
  st_centroid()
 
res = inner_join(nyc_park, pluto)

png("precincts.png", width=600, height=1200)
ggplot(res, aes(color=violation_precinct)) +
  geom_sf()
dev.off()