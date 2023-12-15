##%##################%##
#                      #
#### Vérifier MAJ   ####
#                      #
##%##################%##

'%>%' <- dplyr::'%>%'

date_jour <- as.character(format(Sys.time(),"%Y-%m-%d"))
date_jour_heure <- as.character(format(Sys.time(),"%Y-%m-%d_%Hh%m"))

source("_config.R")

if (!file.exists("data/onde_data/onde.csv") | 
    !file.exists("data/onde_data/dernieres_obs.csv") |
    !file.exists("data/processed_data/donnees_pour_graphiques.rda") |
    !file.exists("data/processed_data/graphiques.rda") |
    !file.exists("data/processed_data/donnees_cartes.rda")) {
  to_update <- TRUE
} else {
  old_data <- read.csv2("data/onde_data/dernieres_obs.csv", colClasses = "character") %>% 
      dplyr::mutate(date_observation = lubridate::as_date(date_observation, format = "%Y-%m-%d")) %>% 
    dplyr::rename(old = date_observation)
  
  new_data <- purrr::map_df(
    .x = conf_dep,
    .f = function(d) {
      data.frame(
        code_departement = d,
        date_observation = readLines(
          paste0(
            "https://hubeau.eaufrance.fr/api/v1/ecoulement/observations?format=json&code_departement=",
            d, "&size=1&fields=date_observation&sort=desc"
          )
        ) %>%
          stringr::str_extract(pattern = "\\d{4}-\\d{2}-\\d{2}")
      )
      
    }
  ) %>% 
    dplyr::rename(new = date_observation)
  
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
        dplyr::select(old, new) %>% 
        t() %>% 
        duplicated() %>% 
        any() %>% 
        '!'()
  }
}

save(to_update, date_jour, date_jour_heure, file = "data/onde_data/to_update.rda")
  
print(switch(as.character(to_update), `TRUE` = "Mise-à-jour requise", `FALSE` = "Pas de mise-à-jour requise"))

