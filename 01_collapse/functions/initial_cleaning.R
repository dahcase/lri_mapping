initial_cleaning <- function(mydat = pt_collapse, var_family = indi_fam, dat_type = data_type) {
  
  if (var_family == 'water') {
    message('Subset to relevant variables')
    ptdat_0 <- dplyr::select(mydat, nid, iso3, lat, long, survey_series, hhweight, urban, 
                             w_source_drink, w_source_other, hh_size, year_start,hhweight,
                             shapefile,location_code)
  } 

  if (var_family == 'sani') {
    ptdat_0 <- dplyr::select(mydat, nid, iso3, lat, long, survey_series, hhweight, urban, 
                             t_type, shared_san, hh_size, year_start,hhweight,
                             shapefile,location_code)

  }

  if (var_family == 'hw') {
    ptdat_0 <- dplyr::select(mydat, nid, iso3, lat, long, survey_series, hhweight, urban, 
                             hw_station, hw_soap, hw_water, hh_size, year_start,hhweight,
                             shapefile,location_code)

  }

  problem_list <- filter(ptdat_0, hh_size <= 0)
  
  message('Create a unique cluster id')
  if (dat_type == 'pt') {
    ptdat <- mutate(ptdat_0, cluster_id = paste(iso3, lat, long, nid, year_start, sep = "_"))
  } else {
    ptdat <- mutate(ptdat_0, cluster_id = paste(iso3, shapefile, location_code, nid, year_start, sep = "_"))  
  }

  message('Create a table which assigns numbers to unique IDs and merge it back to data to have shorter
          unique IDs')
  short_id <- data.frame(cluster_id = unique(ptdat$cluster_id), 
                         id_short = seq(1:length(unique(ptdat$cluster_id))),
                         stringsAsFactors = F)
  ptdat <- left_join(ptdat, short_id, by = 'cluster_id')
  rm(short_id)

  message('Remove longer cluster_ids')
  ptdat <- dplyr::select(ptdat, -cluster_id)

  message('Change weight to 1 if collapsing point data')
  if (dat_type == "pt" & agg_level != 'country') {ptdat$hhweight <- 1}

  message('Change shapefile and location code to missing if collapsing point data')
  if (dat_type == "pt") {ptdat$shapefile <- NA; ptdat$location_code <- NA}

  results <- list(ptdat, ptdat_0)
  return(results)
}

