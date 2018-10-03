library(rvest)
library(dplyr)
library(stringr)

base_url = "https://www.rottentomatoes.com/"

page = read_html(base_url)


data_frame(
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
