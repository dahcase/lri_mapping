library(dplyr)
library(ggplot2)
library(plotly)

# define list of african countries
sssa_hi <- c('NAM','BWA','ZAF')
cssa <- c('CAF','GAB','GNQ','COD','COG','AGO','STP')
name_hi <- c('MAR','DZA','TUN','LBY','EGY')
essa_hilo <- c('SDN','ERI','DJI','SOM','ETH','SSD',
               'SSD','UGA','KEN','RWA','BDI','TZA',
               'MWI','MOZ','ZMB','MDG','ZWE','SWZ','LSO',
               'COM')
wssa <- c('CPV','SEN','GMB','GIN','GNB','SLE','MLI','LBR',
          'CIV','GHA','TGO','BEN','NGA','NER','TCD','CMR',
          'BFA','MRT')
africa <- c(sssa_hi, cssa, name_hi, essa_hilo, wssa)

setwd('/share/geospatial/mbg/input_data')
mydat <- read.csv('has_lri.csv')
mydat <- mutate(mydat, weighted_n = weight*N)

sumdat <- mydat %>% group_by(country,original_year) %>% 
        summarize(wm = weighted.mean(rate, weighted_n))

plotdat <-filter(sumdat, country %in% essa_hilo)
p <- ggplot(plotdat) + 
        geom_point(aes(x = original_year, y = wm, group = country, color = country)) + 
        geom_line(aes(x = original_year, y = wm, group = country, color = country)) + 
        xlab('year') + ylab('lri prevalence') + theme_bw()
ggplotly(p)