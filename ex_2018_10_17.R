library(rvest)
library(stringr)
library(dplyr)
library(purrr)

## LQ - Get Hotel URLs

url = "https://www.lq.com/content/laquinta/en/hotel-list.partials.content.html"

read_html(url) %>% html_nodes("a~ .landing-page-content__paragraph br+ a")

hotel_url = read_html(url) %>%
  html_nodes("br+ a , h3+ p a") %>% 
  html_attr("href") %>%
  paste0("http://www.lq.com/", .)


## LQ - Get Hotel Details

url = hotel_url[1]

read_html(url) %>% html_nodes(".property-info-address")

#cat(paste0(readLines(url), collapse="\n"))

### Doesn't work

base_url = "http://www2.stat.duke.edu/~cr173/lq/www.lq.com/bin/lq/"
data_dir = "data/"

safe_download_file = safely(download.file)
possibly_download_file = possibly(download.file, otherwise = NA, quiet = TRUE)

dir.create(data_dir, showWarnings = FALSE)

purrr::walk(
  (0:10) + 1000, #0:9999,
  function(id) {
    print(id)
    file_name = paste0("hotel-summary.", sprintf("%04d", id), ".en.json") 
    url = file.path(base_url, file_name)
    
    possibly_download_file(url, file.path(data_dir, file_name), quiet = TRUE)
  }
)

## Error handling

?try
?tryCatch

?safely
?quietly
