##%##################%##
#                      #
#### Vérifier MAJ   ####
#                      #
##%##################%##

import::from("dplyr", '%>%')

date_jour <- as.character(format(Sys.time(),"%Y-%m-%d"))
date_jour_heure <- as.character(format(Sys.time(),"%Y-%m-%d_%Hh%m"))

source("_config.R")

if (!file.exists("data/onde_data/onde.csv") | 
    !file.exists("data/processed_data/donnees_pour_graphiques.rda") |
    !file.exists("data/processed_data/graphiques.rda") |
    !file.exists("data/processed_data/donnees_cartes.rda")) {
  to_update <- TRUE
} else {
  old_data <- read.csv("data/onde_data/onde.csv", colClasses = "character") %>% 
      dplyr::mutate(date_campagne = lubridate::as_date(date_campagne, format = "%Y-%m-%d")) %>% 
      dplyr::group_by(code_departement) %>% 
      dplyr::filter(date_campagne == max(date_campagne)) %>%
      dplyr::ungroup() %>% 
      dplyr::distinct(code_departement, date_campagne) %>% 
      dplyr::rename(old = date_campagne)
  
  new_data <- purrr::map_df(
    .x = conf_dep,
    function(dep) {
      hubeau::get_ecoulement_campagnes(
        code_departement = dep,
        fields = "code_departement,date_campagne"
      )
    }
  ) %>% 
    dplyr::mutate(
      date_campagne = lubridate::as_date(date_campagne, format = "%Y-%m-%d")
    ) %>% 
    dplyr::group_by(code_departement) %>% 
    dplyr::filter(date_campagne == max(date_campagne)) %>% 
    dplyr::ungroup() %>% 
    dplyr::rename(new = date_campagne)
  
  if (
    any(! old_data$code_departement %in% new_data$code_departement) |
    any(! new_data$code_departement %in% old_data$code_departement)
    ) {
    to_update <- TRUE
  } else {
      to_update <- dplyr::left_join(
        x = old_data,
        y = new_data,
        by = "code_departement"
        ) %>% 
        dplyr::mutate(update = new > old) %>% 
        dplyr::pull(update) %>% 
        (function(x) {
          if (any(x)) {
            TRUE
            } else {
              FALSE
              }
          })
  }
}

save(to_update, date_jour, date_jour_heure, file = "data/onde_data/to_update.rda")
  
print(switch(as.character(to_update), `TRUE` = "Mise-à-jour requise", `FALSE` = "Pas de mise-à-jour requise"))

