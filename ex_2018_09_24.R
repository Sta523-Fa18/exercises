library(ggplot2)

movies = readr::read_csv("https://www.stat.duke.edu/~cr173/Sta523_Fa18/slides/data/movies/movies.csv") 
movies

## Examples

ggplot(data = movies) +
  geom_point(aes(x = audience_score, y = critics_score), 
             alpha = 0.5, color = "blue")


ggplot(data = movies, aes(x = audience_score)) +
  geom_histogram(bins=5)


ggplot(data = movies, aes(y = genre, x = audience_score)) +
  geom_boxplot()


typeof(movies$genre)

## Exercise 1

ggplot(movies, aes(x=imdb_num_votes, y=imdb_rating, color=audience_rating)) + 
  geom_point() +
  facet_wrap(~mpaa_rating) +
  theme_bw() +
  labs(x="IMDB Number of Votes", y="IMDB Rating", 
       color="Audience Rating", 
       title="IMDB and RT scores, by MPAA rating")


## Exercise 2

ggplot(movies, aes(x=audience_score, y=critics_score)) +
  geom_point(aes(color=best_pic_nom)) +
  geom_smooth(method="lm", se=FALSE, color="black", size=0.25, fullrange=TRUE) +
  geom_abline(intercept=0, slope=1, color="grey", size=0.25) + 
  theme_bw() +
  facet_wrap(~ mpaa_rating) +
  xlim(0,100)
