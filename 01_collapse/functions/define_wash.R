define_indi <- function(mydat = ptdat, var_family = indi_fam, define = definitions,
                        define2 = definitions2,debug = F, sdg_indi = T) {
  if (debug) {browser()}
  
  if (var_family == 'hw') {
    message('Nothing to define! HW is numeric!')
  }

  if (var_family == 'water') {
    # Rename string to indicator name to merge on and merge
    # definition file to mydatset
    if (sdg_indi) {
      define$sdg <- ifelse(define$jmp == 'basic' & !(define$sdg %in% c('piped','imp')), 
                      'imp', define$sdg)
    }
    define <- rename(define, w_source_drink = string) 
    mydat <- left_join(mydat, define, by = "w_source_drink")
    
    if (!sdg_indi) {
      define2 <- rename(define2, w_source_other = string) 
      mydat <- left_join(mydat, define2, by = "w_source_other")
    }
  }  

  if (var_family == 'sani') {
    define <- rename(define, t_type = string) 
    mydat <- left_join(mydat, define, by = "t_type")
  }

  if (var_family == 'water') {
    mydat <- mydat %>%
            mutate(# Define straightforward water ladder
                   piped = ifelse(mydat$sdg == "piped", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   surface = ifelse(mydat$sdg == "surface", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   imp = ifelse(mydat$sdg == "imp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   unimp = ifelse(mydat$sdg == "unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   
                   #Define bottled and bottled crosswalks (REMOVED DUE TO SDGs)
                   #bottled = ifelse(mydat$sdg == "bottled" &
                   #                 !(mydat$sdg2 %in% c('imp','spring_imp','well_imp')), 1, 
                   #                 ifelse(is.na(mydat$sdg), NA, 0)),
                   #bottled_sp = ifelse(mydat$sdg == "bottled" & mydat$sdg2 == 'spring_cw', 1, 
                   #                    ifelse(is.na(mydat$sdg), NA, 0)),
                   #bottled_wl = ifelse(mydat$sdg == "bottled" & mydat$sdg2 == 'well_cw', 1, 
                   #                    ifelse(is.na(mydat$sdg), NA, 0)),
                   
                   # Define crosswalking indicators
                   well_cw = ifelse(mydat$sdg == "well_cw", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   well_imp = ifelse(mydat$sdg == "well_imp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   well_unimp = ifelse(mydat$sdg == "well_unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   
                   spring_cw = ifelse(mydat$sdg == "spring_cw", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   spring_imp = ifelse(mydat$sdg == "spring_imp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
                   spring_unimp = ifelse(mydat$sdg == "spring_unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)))
    
    # relic of mdg era
    #mydat <- mutate(mydat, imp = ifelse(mydat$imp == 1 | (mydat$sdg == "bottled" & (mydat$sdg2 %in% c('imp','spring_imp','well_imp'))),
    #                             1, ifelse(is.na(mydat$sdg), NA, 0)))
  }
  
  if (var_family == 'hw') {
    mydat <- mydat %>%
              mutate(hw_unimp = ifelse(is.na(mydat$hw_soap) & is.na(mydat$hw_water), NA,
                ifelse((is.na(mydat$hw_soap)|is.na(mydat$hw_water)),
                ifelse(mydat$hw_soap == 1|mydat$hw_water == 1, 1, NA),
                ifelse(mydat$hw_soap == 1|mydat$hw_water == 1, 1, 0)
                )
              ),
                hw_basic = ifelse(is.na(mydat$hw_soap) & is.na(mydat$hw_water), NA,
                  ifelse((is.na(mydat$hw_soap)|is.na(mydat$hw_water)),
                  ifelse(mydat$hw_soap == 0|mydat$hw_water == 0, 0, NA),
                  ifelse(mydat$hw_soap == 0|mydat$hw_water == 0, 0, 1)
                  )
              ))
  }
  
  if (var_family == 'sani') {
    mydat <- mydat %>%
    mutate(# Define straightforward sani ladder
           ### This was old way of doing it by including shared
           #imp = ifelse(mydat$sdg == "imp" & mydat$shared_san == 0, 1, ifelse(is.na(mydat$sdg), NA, 0)),
           #imp_cw = ifelse(mydat$sdg == "imp" & is.na(mydat$shared_san), 1, ifelse(is.na(mydat$sdg), NA, 0)),
           #shared = ifelse(mydat$sdg == "imp" & mydat$shared_san == 1, 1, ifelse(is.na(mydat$sdg), NA, 0)),
           #unimp = ifelse(mydat$sdg == "unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           #od = ifelse(mydat$sdg == "open", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           
           ### New Way of classifying not including shared
           imp = ifelse(mydat$sdg == "imp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           unimp = ifelse(mydat$sdg == "unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           od = ifelse(mydat$sdg == "open", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           shared = ifelse((mydat$sdg %in% c('imp','latrine_imp')),
                      ifelse(mydat$shared_san == 1, 1, ifelse(is.na(mydat$shared_san), NA, 0)), 0),

           # Define crosswalking indicators
           latrine_cw = ifelse(mydat$sdg == "latrine_cw", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           latrine_imp = ifelse(mydat$sdg == "latrine_imp", 1, ifelse(is.na(mydat$sdg), NA, 0)),
           latrine_unimp = ifelse(mydat$sdg == "latrine_unimp", 1, ifelse(is.na(mydat$sdg), NA, 0)))
  }
  return(mydat)
}