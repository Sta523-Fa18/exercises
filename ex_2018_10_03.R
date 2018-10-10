library(rvest)
library(dplyr)
library(stringr)

base_url = "https://www.rottentomatoes.com/"

page = read_html(base_url)


d = data_frame(
  name   = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_text(),
  url    = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_attr("href") %>% paste0(base_url, .),
  gross  = page %>% html_nodes("#Top-Box-Office .right a") %>% html_text() %>% str_replace_all("^\\$|M$","") %>% as.numeric(),
  tmeter = page %>% html_nodes("#Top-Box-Office .tMeterScore") %>% html_text() %>% str_replace("%$", "") %>% as.numeric(),
  fresh  = page %>% 
    html_nodes("#Top-Box-Office .tiny") %>% 
    html_attr("class") %>% 
    str_replace_all("icon|tiny","") %>% 
    str_trim() %>% 
    str_replace("_", " ")
)

urls = d$url
urls[5:9] = "http://google.com"


purrr::map_dfr(
  urls,
  function(url) {
    page = read_html(url)
    
    data_frame(
      url         = url,
      aud_score   = page %>% html_nodes(".meter-value .superPageFontColor") %>% html_text() %>% str_replace("%$", "") %>% as.numeric(),
      mpaa_rating = page %>% html_nodes(".clearfix:nth-child(1) .meta-value") %>% html_text() %>% str_replace("\\(.*\\)", "") %>% str_trim()
    )
  }
) %>%
  full_join(d, .)



