rm(list = ls())
library(ggplot2)
library(ggpubr)
library(raster)
library(dplyr)

setwd('/share/geospatial/mbg/lri/has_lri/output/2017_10_18_00_47_50')
lri <- lapply(list.files()[grep('.gri', list.files())], brick)
lri <- do.call(raster::merge, lri)

lri_list <- list()
for (i in 1:nlayers(lri)) {
    
    lri_df <- rasterToPoints(lri[[i]])
    lri_df <- data.frame(lri_df)
    colnames(lri_df) <- c("long", 'lat', 'lri')
    lri_df$year <- 1999+i
    
    lri_list[[i]] <- lri_df
}

lri_df <- do.call(rbind, lri_list)
plot_list <- list()
for (i in c(2000,2005,2010,2015)) {
    plotdat <- filter(lri_df, year == i)
    
    plot_list[[length(plot_list) + 1]] <- ggplot(plotdat, aes(y = lat, x = long)) + 
        geom_raster(aes(fill = lri)) + 
        theme_classic() +
        theme(axis.line = element_blank(), axis.text = element_blank(),
                      axis.ticks = element_blank()) +
        xlab('') + ylab('') + ggtitle(i) +
        scale_fill_gradient2(midpoint = 0.05, low = "#91bfdb",
                             mid = '#ffffbf', high = "#fc8d59",
                             na.value = "#fc8d59", limits = c(0,0.1))
    

}

pdf('/home/j/WORK/11_geospatial/lri/plots/model/2017.10.18.pdf')
	print(ggarrange(plotlist = plot_list, common.legend = T, legend = 'right',
                    nrow = 2, ncol = 2))
dev.off()