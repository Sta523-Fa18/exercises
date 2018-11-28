library(sparklyr)
library(dplyr)
library(ggplot2)
library(stringr)


sc = spark_connect(master = "local[4]", 
                    spark_home = "/data/spark/spark-2.3.2-bin-hadoop2.7/")


