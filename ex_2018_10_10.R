library(rvest)
library(dplyr)

## LQ Failure

url = "https://www.lq.com/en/hotel-list"

read_html(url) %>% html_nodes("a~ .landing-page-content__paragraph br+ a")

read_html(url) %>% html_nodes("a")

read_html(url) %>% html_node("body")

download.file(url, basename(url))



## Dennys

url = "https://www2.stat.duke.edu/~cr173/dennys/locations.dennys.com/index.html"

url = "https://locations.dennys.com/NC/WILMINGTON/249257"

get_restaurant = function(url) {
  page = read_html(url)
  
  data_frame(
    name    = html_nodes(page, "#location-name")         %>% html_text(),
    address = html_nodes(page, ".c-address-street-1")    %>% html_text(),
    city    = html_nodes(page, ".c-address-city")        %>% html_text(),
    state   = html_nodes(page, ".c-address-state")       %>% html_text(),
    zipcode = html_nodes(page, ".c-address-postal-code") %>% html_text(),
    phone   = html_nodes(page, "#telephone")             %>% html_text()
  )
}

library(purrr)
library(stringr)

is_restaurant = function(s) {
  str_detect(s, "[0-9]{6}$")
}

get_list_links = function(url) {
  res = read_html(url) %>% 
    html_nodes('.c-directory-list-content-item-link') %>%
    html_attr("href") %>%
    paste0(base_url, .)
  
  list(
    restaurants = keep(res, is_restaurant),
    groups = discard(res, is_restaurant)
  )
}

get_city_links = function(url) {
  read_html(url) %>% 
    html_nodes('.c-location-grid-item-title a') %>%
    html_attr("href") %>%
    paste0(base_url, .)
}


# Get state links

base_url = "https://locations.dennys.com/"
state_urls = get_list_links(base_url)


city_links = map(state_urls$groups[1:5], get_list_links)


cities = map(city_links, "groups") %>% flatten_chr()


restaurants = c(map(city_links, "restaurants") %>% flatten_chr(), 
                map(cities[1:5], get_city_links) %>% flatten_chr())


df = map_dfr(restaurants[1:10], get_restaurant)
df