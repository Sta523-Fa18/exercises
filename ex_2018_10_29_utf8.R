library(rvest)
library(magrittr)
library(stringr)

d = read_html("https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population") %>%
  html_nodes("p+ .sortable tr:nth-child(2) td:nth-child(7)") %>%
  html_text()

str_replace(d, " ", "")

str_extract(d, "[0-9,]+\\.[0-9]")


### utf8splain

devtools::install_github( "ThinkRstat/utf8splain")

utf8splain::runes(d)
