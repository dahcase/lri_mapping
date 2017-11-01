# load libraries and set working directory
if(Sys.info()[1]!="Windows") {
  root <- "/home/j/"
  package_lib <- ifelse(grepl("geos", Sys.info()[4]),
                        paste0(root,'temp/geospatial/geos_packages'),
                        paste0(root,'temp/geospatial/packages'))
  .libPaths(package_lib)
} else {
  package_lib <- .libPaths()
  root <- 'J:/'
}

library('dplyr'); library('ggplot2'); library('feather')
setwd('/share/geospatial/mbg/input_data')

# read data
inputdat <- read.csv('has_lri_nodrop.csv')
xtract <- read.csv('/home/j/LIMITED_USE/LU_GEOSPATIAL/collapsed/lri/coverage_data.csv')

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

# Create prop and weighted N
mydat_mod <- inputdat %>% mutate(weighted_n = N*weight) %>% rename(prop = rate, survey_series = source)

# loop over countries and output scatter plot of input data
setwd('/home/j/WORK/11_geospatial/lri/plots/data_validation')
pdf(paste0(Sys.Date(),'.pdf'))
for (i in africa) {
    message(i)
    plotdat <- filter(mydat_mod, country %in% i)

    print(
        ggplot(plotdat) +
            geom_point(aes(x = weighted_n, y = prop, col = survey_series)) +
            ggtitle(paste0('has_lri_nodrop input data: ',i)) +
            theme_bw()
    )
}
dev.off()