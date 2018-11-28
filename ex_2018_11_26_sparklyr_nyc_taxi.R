library(sparklyr)
library(dplyr)
library(ggplot2)

#sparklyr::spark_install()
#sparklyr::spark_available_versions()

sc = spark_connect(master = "local[4]", 
                    spark_home = "/data/spark/spark-2.3.2-bin-hadoop2.7/")

fs::dir_ls("/data/nyc-taxi-data/data/", regexp="green")
fs::dir_ls("/data/nyc-taxi-data/parquet/", regexp="green")

#green = spark_read_csv(sc, "green", "/data/nyc-taxi-data/data/green_tripdata_2018-01.csv")
green = spark_read_parquet(sc, "green", "/data/nyc-taxi-data/parquet/green_tripdata_2018*")

green %>% count() %>% collect()

green = fix_names(green)


fix_names = function(df) {
  colnames(df) %>%
    tolower() %>%
    stringr::str_replace("[lt]pep_", "") %>%
    setNames(df, .)
}

green %>%
  mutate(
    store_and_fwd_flag  = stringr::str_replace(store_and_fwd_flag, "N", "n")
  )

library(stringr)

green %>%
  mutate(
    store_and_fwd_flag  = str_replace(store_and_fwd_flag, "N", "n")
  ) %>%
  show_query()

green %>%
  mutate(
    store_and_fwd_flag  = tolower(store_and_fwd_flag)
  ) %>%
  show_query()


green %>% count(vendorid)
green %>% count(vendorid) %>% collect()
green %>% count(vendorid) %>% compute(name = "green_vendors")

green %>% count(pulocationid, dolocationid)
green %>% count(pulocationid, dolocationid) %>% collect()


## wday & hour data

wday_summary = green %>%
  select(pickup_datetime, dropoff_datetime, trip_distance, 
         fare_amount, tip_amount) %>%
  mutate(
    hour = hour(pickup_datetime),
    wday = date_format(pickup_datetime, "EEEEE"),
    trip_duration = (unix_timestamp(dropoff_datetime) - unix_timestamp(pickup_datetime))/60
  ) %>%
  group_by(hour, wday) %>%
  summarize(
    n = n(),
    avg_dur  = mean(trip_duration, na.rm=TRUE),
    avg_dist = mean(trip_distance, na.rm=TRUE),
    avg_fare = mean(fare_amount, na.rm=TRUE),
    avg_tip_perc = mean(tip_amount/fare_amount, na.rm=TRUE)
  ) %>%
  collect()

wday_summary %>%
  tidyr::gather(param, value, -hour, -wday) %>%
ggplot() +
  geom_line(aes(x=hour, y=value)) +
  facet_grid(param~wday, scale="free_y")



### zones

zones = sf::st_read("/data/nyc-taxi-data/taxi_zones/")
plot(sf::st_geometry(zones))
 
