##%##################%##
#                      #
#### Vérifier MAJ   ####
#                      #
##%##################%##

date_jour <- as.character(format(Sys.time(),"%Y-%m-%d"))
date_jour_heure <- as.character(format(Sys.time(),"%Y-%m-%d_%Hh%m"))

source("_config.R")

to_update <- TRUE

save(to_update, date_jour, date_jour_heure, file = "data/onde_data/to_update.rda")
  
print(switch(as.character(to_update), `TRUE` = "Mise-à-jour requise", `FALSE` = "Pas de mise-à-jour requise"))

