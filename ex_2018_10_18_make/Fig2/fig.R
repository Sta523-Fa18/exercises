png("fig.png", width=1000, height=1000)

library(ggplot2)
library(GGally)

ggpairs(mtcars[,1:4])

dev.off()