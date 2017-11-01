setwd('/share/geospatial/mbg/input_data')

library(dplyr); library(ggplot2)

mydat <- read.csv('has_lri.csv')
mydat <- mydat %>%
            mutate(weighted_n = N*weight) %>%
            rename(prop = rate, survey_series = source)

pdf(paste0('/home/j/WORK/11_geospatial/lri/plots/data_validation/',Sys.Date(),'.pdf'))
for (i in unique(mydat$country)) {
    plotdat <- filter(mydat, country == i)
    print(ggplot(plotdat) +
            geom_point(aes(x = weighted_n, y = prop, col = survey_series)) +
            ggtitle(i) +
            theme_bw()
         )
}
dev.off()