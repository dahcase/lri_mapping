rundate <- '2017_10_18_00_37_07'

setwd(paste0('/share/geospatial/mbg/lri/has_lri/output/',rundate))
library(tidyr)

file_names <- list.files()[grep('has_lri_model_eb', list.files())]

model_list <- list()
for (i in file_names) {
    load(i)
    model_list[[length(model_list) + 1]] <- res_fit
    rm(res_fit)
}

par_list <- list()
for (i in 1:length(model_list)) {
    model <- model_list[[i]]
    pars <- rbind(model$summary.fixed[,1:2], model$summary.hyperpar[,1:2])
    pars$par <- rownames(pars)
    rownames(pars) <- NULL
    model_name <- gsub('has_lri_model_eb_bin0_', '', file_names[i])
    model_name <- gsub('.RData', '', model_name)
    pars$region_holdout <- model_name

    par_list[[i]] <- pars
}

parameters <- do.call(rbind, par_list)
write.csv(parameters, file = paste0('/home/j/WORK/11_geospatial/lri/data/parameters_',
    rundate,'.csv'))