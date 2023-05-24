##%####################################%##
#                                        #
#### Téléchargement des données ONDE  ####
#                                        #
##%####################################%##

import::from("dplyr", '%>%')

source("_config.R")

load("data/onde_data/to_update.rda")
# to_update = TRUE

### Utilisation de l'API Hubeau ----

if (to_update) {
  #### infos campagnes
  campagnes <- purrr::map_df(.x = conf_dep,
                      function(x) hubeau::get_ecoulement_campagnes(
                        list(
                          code_departement = x,
                          date_campagne_min = "2012-01-01",
                          date_campagne_max = date_jour
                        )
                      )) %>% 
    dplyr::mutate(code_campagne = as.character(code_campagne)) %>% 
    dplyr::distinct()
  
  #### infos stations
  param_stations <- 
    hubeau::list_params(api = "ecoulement", endpoint = "stations") %>% 
    toString() %>% 
    gsub(pattern = " ",replacement = "")
  
  stations <- purrr::map_df(.x = conf_dep,
                     function(x) hubeau::get_ecoulement_stations(
                       list(code_departement = x,
                            fields = param_stations)
                     )) %>% 
    dplyr::distinct()
  
  #### infos observations
  param_obs <- 
    hubeau::list_params(api = "ecoulement", endpoint = "observations") %>% 
    toString() %>% 
    gsub(pattern = " ",replacement = "")
  
  observations <- purrr::map_df(.x = conf_dep,
                         function(x) hubeau::get_ecoulement_observations(
                           list(code_departement = x,
                                date_observation_min = "2012-01-01",
                                date_observation_max = date_jour,
                                fields = param_obs)
                         )) %>% 
    dplyr::mutate(code_campagne = as.character(code_campagne)) %>% 
    dplyr::distinct()
  
  ### Assemblage des données stations, observations, campagnes ----
  onde_df <- observations %>% 
    dplyr::left_join(campagnes) %>% 
    dplyr::left_join(stations) %>% 
    dplyr::mutate(
      date_campagne = lubridate::as_date(date_campagne, format = "%Y-%m-%d")
      ) %>% 
    dplyr::mutate(
      Annee = lubridate::year(date_campagne),
      libelle_ecoulement = dplyr::if_else(
             condition = is.na(libelle_ecoulement),
             true = "Donnée manquante",
             false = libelle_ecoulement
           )
      ) %>% 
    dplyr::arrange(code_station,code_departement,desc(Annee))
  
  
  ### Ecriture/Sauvegarde des données ----
  write.csv(onde_df, "data/onde_data/onde.csv")
  
}

