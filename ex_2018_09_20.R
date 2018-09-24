library(repurrrsive)
library(purrr)
library(dplyr)

## Example 1


### Viewing / structure

str(sw_people, max.level = 2)
View(sw_people)


### Extracting

map_chr(sw_people, "name")

map_chr(sw_people, "films")
sw_people[[1]]$films
map(sw_people, "films")[[1]]


all( map_chr(sw_people, 1) == map_chr(sw_people, "name") )


### Creating a tidy data frame

data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height") %>% as.integer(), 
  mass = map_chr(sw_people, "mass")
)

#### NA?

data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height") %>% {ifelse(. == "unknown", NA, .)} %>% as.integer(), 
  mass = map_chr(sw_people, "mass") %>% {ifelse(. == "unknown", NA, .)} %>% as.integer(), 
) %>% View()
  
#### Different bad inputs

sw_people_copy = sw_people
sw_people_copy[[87]]$mass = NULL

data_frame(
  name = map_chr(sw_people_copy, "name"),
  height = map_chr(sw_people_copy, "height"),
  mass = map_chr(sw_people_copy, "mass", .default=NA),
  bad_length = 1:2
)

#### Helper functions

fix_integers = function(v) {
  ifelse(v == "unknown", NA, v) %>% 
    stringr::str_replace_all(",","") %>%
    as.integer()
}

d = data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height") %>% fix_integers(), 
  mass = map_chr(sw_people, "mass") %>% fix_integers()
) 

#### gender

fix_gender = function(v) {
  ifelse(v %in% c("n/a","none"), NA, v)
}

d = data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height") %>% fix_integers(), 
  mass = map_chr(sw_people, "mass") %>% fix_integers(),
  gender = map_chr(sw_people, "gender") %>% fix_gender()
) 

View(d)


#### dplyr mutate

d = data_frame(
  name = map_chr(sw_people, "name"),
  height = map_chr(sw_people, "height"),
  mass = map_chr(sw_people, "mass"),
  gender = map_chr(sw_people, "gender")
) %>%
  mutate(
    height = fix_integers(height),
    mass   = fix_integers(mass),
    gender = fix_gender(gender)
  )

View(d)




### wesanderson

wesanderson

data_frame(
  movie = names(wesanderson),
  colors = wesanderson
) %>%
  mutate(
    n_colors = map_int(colors, length),
    n_colors2 = length(colors)
  )

#### Flatten list columns

data_frame(
  movie = names(wesanderson),
  colors = wesanderson
) %>%
  tidyr::unnest(color = colors) %>%
  tidyr::nest(color, .key = "colors") %>%
  as.data.frame()


#### Grouping without tidyr

data_frame(
  movie = names(wesanderson),
  colors = wesanderson
) %>%
  tidyr::unnest(color = colors) %>%
  group_by(movie) %>%
  summarize(
    colors = list(color)
  )
