library(sparklyr)
library(dplyr)
library(ggplot2)
library(stringr)


sc = spark_connect(master = "local[8]", 
                   spark_home = "/data/spark/spark-2.3.2-bin-hadoop2.7/")

## Text Data

### Shakespeare

hamlet = readLines("/data/shakespeare/hamlet.txt")

hamlet %>%
  data_frame(line = .) %>%
  mutate(
    line = tolower(line) %>%
      str_replace_all("[^a-z ]", "")
  ) %>%
  transmute(
    word = str_split(line," ")
  ) %>%
  tidyr::unnest() %>%
  filter(word != "") %>% 
  anti_join(tidytext::stop_words) %>%
  count(word) %>%
  arrange(desc(n))

hamlet %>%
  data_frame(line = .) %>%
  tidytext::unnest_tokens(line, word)


hamlet_sp = spark_read_text(sc, "hamlet", "/data/shakespeare/hamlet.txt")

hamlet_sp %>%
  mutate(
    line = lower(line) %>% regexp_replace("[^a-z ]", "")
  ) %>%
  ft_tokenizer("line", "words") %>%
  ft_stop_words_remover("words", "word") %>%
  transmute(
    word = explode(word)
  ) %>%
  filter(word != "") %>%
  count(word) %>%
  arrange(desc(n))
  
  
spark_read_text(sc, "hamlet", "/data/shakespeare/*.txt") %>%
  mutate(
    line = lower(line) %>% regexp_replace("[^a-z ]", "")
  ) %>%
  ft_tokenizer("line", "words") %>%
  ft_stop_words_remover("words", "word") %>%
  transmute(
    word = explode(word)
  ) %>%
  filter(word != "") %>%
  count(word) %>%
  arrange(desc(n))



### reddit

reddit = spark_read_json(sc, "reddit", "/data/reddit/RC_2009-02.bz2")

reddit %>% count()

reddit %>% count(subreddit) %>% arrange(desc(n))
reddit %>% count(author) %>% arrange(desc(n))

day_hour = reddit %>% 
  mutate(
    created_utc = from_unixtime(created_utc) %>%
      to_timestamp()
  ) %>%
  mutate(
    hour = hour(created_utc),
    day = dayofyear(created_utc)
  ) %>%
  select(created_utc, hour, day) %>% 
  collect()

day_hour %>%
  count(hour, day) %>%
  ggplot(aes(x = day+hour/24, y = n)) + 
    geom_line()

day_hour %>%
  count(hour, day) %>%
  ggplot(aes(x = hour, y = n, group=day)) + 
  geom_line(alpha=0.2)


### reddit - all of 2009 

config = spark_config()
config$`sparklyr.shell.driver-memory` = "8G"
config$`sparklyr.shell.executor-memory` = "8G"
sc = spark_connect(master = "local[4]", 
                   spark_home = "/data/spark/spark-2.3.2-bin-hadoop2.7/",
                   config = config)

reddit = spark_read_parquet(sc, "reddit", "/data/reddit/parquet/RC_2009.parquet")

reddit %>% count()

day_hour = reddit %>% 
  mutate(
    created_utc = from_unixtime(created_utc) %>%
      to_timestamp()
  ) %>%
  mutate(
    hour = hour(created_utc),
    day = dayofyear(created_utc)
  ) %>%
  select(created_utc, hour, day) %>% 
  collect()

day_hour %>%
  count(hour, day) %>%
  ggplot(aes(x = day+hour/24, y = n)) + 
  geom_line()

day_hour %>%
  count(hour, day) %>%
  ggplot(aes(x = hour, y = n, group=day)) + 
  geom_line(alpha=0.2)

