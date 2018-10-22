## Get Denny's Lat and Long

library(rvest)
library(magrittr)

url = "https://locations.dennys.com/NC/DURHAM/248848"

p = read_html(url)

html_nodes(p, "#schema-location") %>% 
html_nodes("span.coordinates")  %>% 
  html_nodes("meta") %>%
  html_attr("content")

html_nodes(p, "#schema-location span.coordinates>meta") %>%
  html_attr("content")


## Progress Bars

for(i in 1:10) {
  print(i)
}


for(i in 1:10) {
  if (i %% 10 == 0)
    print(i)
}


library(dplyr)

p = dplyr::progress_estimated(10, min_time = 10)

for(i in 1:10) {
  Sys.sleep(2)
  p$tick()$print()
}

?dplyr::progress_estimated



## Web APIs

library(jsonlite)

### How many countries are in this data set?
  
fromJSON("https://restcountries.eu/rest/v2/all?fields=name") %>% nrow()


### Which countries are members of ASEAN (Association of Southeast Asian Nations)?

fromJSON("https://restcountries.eu/rest/v2/regionalbloc/ASEAN?fields=name")

  
### What are all of the currencies used in the Americas?

fromJSON("https://restcountries.eu/rest/v2/region/americas?fields=currencies", simplifyVector = FALSE) %>%
  str()



