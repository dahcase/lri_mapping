library(feather)
library(dplyr)

setwd('/home/j/LIMITED_USE/LU_GEOSPATIAL/collapsed/wash')
ptdat <- read_feather('ptdat_water_unconditional_clean_2017_09_29.feather')

indi_fam <- 'water'
if (indi_fam == 'water') {
  w_piped <- ptdat
  w_piped <- dplyr::select(w_piped, -surface, -imp, -unimp)
  w_piped <- mutate(w_piped, point = 1, weight = 1, w_piped = round(piped*total_hh))
  w_piped <- rename(w_piped, country = iso3, year = year_start, prop = piped, N = total_hh, latitude = lat,
                  longitude = long)
  w_piped <- mutate(w_piped, N = round(N))
  write.csv(w_piped, file = '/home/j/WORK/11_geospatial/10_mbg/input_data/w_piped.csv')

  w_imp <- ptdat
  w_imp <- select(w_imp, -surface, -piped, -unimp)
  w_imp <- mutate(w_imp, point = 1, weight = 1, w_imp = round(imp*total_hh))
  w_imp <- rename(w_imp, country = iso3, year = year_start, prop = imp, N = total_hh, latitude = lat,
                  longitude = long)
  w_imp <- mutate(w_imp, N = round(N))
  write.csv(w_imp, '/home/j/WORK/11_geospatial/10_mbg/input_data/w_imp.csv')

  w_unimp <- ptdat
  w_unimp <- select(w_unimp, -surface, -imp, -piped)
  w_unimp <- mutate(w_unimp, point = 1, weight = 1, w_unimp = round(unimp*total_hh))
  w_unimp <- rename(w_unimp, country = iso3, year = year_start, prop = unimp, N = total_hh, latitude = lat,
                  longitude = long)
  w_unimp <- mutate(w_unimp, N = round(N))
  write.csv(w_unimp, '/home/j/WORK/11_geospatial/10_mbg/input_data/w_unimp.csv')

  w_surface <- ptdat
  w_surface <- select(w_surface, -piped, -imp, -unimp)
  w_surface <- mutate(w_surface, point = 1, weight = 1, w_surface = round(surface*total_hh))
  w_surface <- rename(w_surface, country = iso3, year = year_start, prop = surface, N = total_hh, latitude = lat,
                  longitude = long)
  w_surface <- mutate(w_surface, N = round(N))
  write.csv(w_surface, '/home/j/WORK/11_geospatial/10_mbg/input_data/w_surface.csv')
}
rm(list = ls())
  