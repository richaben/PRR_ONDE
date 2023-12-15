##%##################################%##
#                                     #
#### Préparation des données ONDE  ####
#                                     #
##%#################################%##

'%>%' <- dplyr::'%>%'

source("_config.R")

load("data/onde_data/to_update.rda")
# to_update <- TRUE
load("data/raw_data/masks.Rdata")

if (to_update) {
  onde_df <- read.csv(
    file = "data/onde_data/onde.csv",
    colClasses = "character"
    ) %>% 
    dplyr::mutate(
      date_campagne = lubridate::as_date(date_campagne, format = "%Y-%m-%d")
      )
  
  # couleurs légendes
  mes_couleurs_3mod <- c(
    "Ecoulement\nvisible" = "#4575b4",
    "Ecoulement\nnon visible" = "#fe9929",
    "Assec" = "#d73027",
    "Observation\nimpossible" = "grey50",
    "Donnée\nmanquante" = "grey90"
      )
  
  # légende
  mes_couleurs_4mod <- c(
    #"Ecoulement\nvisible" = "#0570b0",
    "Ecoulement\nvisible\nacceptable" = "#4575b4",
    "Ecoulement\nvisible\nfaible" = "#bdd7e7",
    "Ecoulement\nnon visible" = "#fe9929",
    "Assec" = "#d73027",
    "Observation\nimpossible" = "grey50",
    "Donnée\nmanquante" = "grey90"
      )
  
  
  # toutes stations actives toutes annees
  onde_periode <- onde_df %>% 
    dplyr::select(-c(libelle_reseau, code_type_campagne)) %>% 
    dplyr::filter(etat_station == 'Active') %>% 
    dplyr::mutate(
      Annee = as.numeric(Annee),
      Mois = format(as.Date(date_campagne), "%m")
      ) %>% 
    dplyr::mutate(
      lib_ecoul3mod = dplyr::case_when(
        libelle_ecoulement == 'Ecoulement visible faible' ~ 'Ecoulement visible',
        libelle_ecoulement == 'Ecoulement visible acceptable' ~ 'Ecoulement visible',
        TRUE ~ libelle_ecoulement
      ),
      lib_ecoul4mod = dplyr::case_when(
        libelle_ecoulement == 'Ecoulement visible' ~ 'Ecoulement visible acceptable',
        TRUE ~ libelle_ecoulement
      )
    ) %>% 
    dplyr::select(
      code_station, libelle_station,
      date_campagne, Annee, Mois, 
      lib_ecoul3mod, lib_ecoul4mod,
      libelle_type_campagne,
      longitude, latitude,
      code_departement,
      etat_station
      ) %>% 
    (function(df_temp) {
      dplyr::bind_rows(
        df_temp %>% 
          dplyr::filter(libelle_type_campagne == "complémentaire"),
        df_temp %>% 
          dplyr::filter(
            libelle_type_campagne == "usuelle"
          ) %>% 
          tidyr::complete(
            tidyr::nesting(code_station, libelle_station, longitude, latitude, code_departement, etat_station),
            Annee, Mois,
            fill = list(
              libelle_type_campagne = "usuelle",
              lib_ecoul3mod = "Donnée manquante",
              lib_ecoul4mod = "Donnée manquante"
            )
          ) %>% 
          dplyr::mutate(
            date_campagne = dplyr::if_else(
              is.na(date_campagne),
              lubridate::as_date(paste0(Annee, "-", as.numeric(Mois), "-25")),
              date_campagne
            )
          ) %>% 
          dplyr::filter(
            date_campagne <= Sys.Date()
          )
      ) %>% 
        dplyr::arrange(
          Annee, Mois, dplyr::desc(libelle_type_campagne)
        ) %>% 
        dplyr::mutate(Mois_campagne = lubridate::ym(paste0(Annee,Mois,sep="-")))
      
    })

  onde_usuel <- onde_periode %>% 
    dplyr::filter(
      libelle_type_campagne == "usuelle",
      Mois %in% c("05", "06", "07", "08", "09")
    )
  
  # toutes stations abandonnees
  onde_anciennes_stations <- onde_df %>% 
    dplyr::select(-c(libelle_reseau, code_type_campagne)) %>% 
    dplyr::filter(etat_station != 'Active') %>% 
    dplyr::mutate(
      Annee = as.numeric(Annee),
      Mois = format(as.Date(date_campagne), "%m"), 
      Mois_campagne = lubridate::ym(paste0(Annee,Mois,sep="-"))
    ) %>% 
    dplyr::mutate(
      lib_ecoul3mod = dplyr::case_when(
        libelle_ecoulement == 'Ecoulement visible faible' ~ 'Ecoulement visible',
        libelle_ecoulement == 'Ecoulement visible acceptable' ~ 'Ecoulement visible',
        TRUE ~ libelle_ecoulement
      ),
      lib_ecoul4mod = dplyr::case_when(
        libelle_ecoulement == 'Ecoulement visible' ~ 'Ecoulement visible acceptable',
        TRUE ~ libelle_ecoulement
      )
    ) %>% 
    dplyr::select(
      code_station, libelle_station,
      date_campagne, Annee, Mois, Mois_campagne,
      lib_ecoul3mod, lib_ecoul4mod,
      libelle_type_campagne,
      longitude, latitude,
      code_departement,
      etat_station
    )
  
  ## selection sous tableau des dernieres campagnes
  selection_dernieres_campagnes <- function(df) {
    df %>% 
      dplyr::group_by(libelle_station) %>% 
      dplyr::slice(which.max(Mois_campagne)) %>% 
      dplyr::arrange(libelle_type_campagne, libelle_station, Mois_campagne) %>% 
      dplyr::ungroup() %>% 
      dplyr::mutate(
        Couleur_3mod = dplyr::recode(
          stringr::str_wrap(lib_ecoul3mod,12), !!!mes_couleurs_3mod),
        Couleur_4mod = dplyr::recode(
          stringr::str_wrap(lib_ecoul4mod,12), !!!mes_couleurs_4mod)
        ) %>% 
      dplyr::mutate(
        label_point_3mod = glue::glue('{libelle_station}: {lib_ecoul3mod} ({date_campagne})'),
        label_point_4mod = glue::glue('{libelle_station}: {lib_ecoul4mod} ({date_campagne})')
        )
  }
  
  onde_dernieres_campagnes <- onde_periode %>% 
    selection_dernieres_campagnes()
  
  onde_dernieres_campagnes_usuelles <- onde_periode %>% 
    dplyr::filter(libelle_type_campagne == 'usuelle') %>% 
    selection_dernieres_campagnes()
  
  onde_dernieres_campagnes_comp <-
    onde_periode %>% 
    dplyr::filter(libelle_type_campagne != 'usuelle') %>% 
    selection_dernieres_campagnes()
  
  onde_dernieres_campagnes_anciennes_stations <- onde_anciennes_stations %>% 
    selection_dernieres_campagnes()
  
  ## coordonnes stations actives EPSG 2154 RGF93
  stations_onde_geo <- onde_dernieres_campagnes_usuelles %>% 
    dplyr::ungroup() %>% 
    dplyr::select(
      code_station ,libelle_station,
      longitude, latitude,
      code_departement
      ) %>% 
    sf::st_as_sf(
      coords = c("longitude", "latitude"), 
      crs = 4326
      ) %>% 
    sf::st_transform(crs = 2154)
  
  ## coordonnes stations abandonnees EPSG 2154 RGF93
  stations_inactives_onde_geo <- onde_dernieres_campagnes_anciennes_stations %>% 
    dplyr::group_by(
      code_station ,libelle_station,
      longitude, latitude,
      code_departement
    ) %>% 
    dplyr::summarise(
      label_station = paste0(
        libelle_station, " (", code_station, ")<br>",
        "Abandonnée en ", lubridate::year(date_campagne)
        ),
      .groups = "drop"
    ) %>% 
    sf::st_as_sf(
      coords = c("longitude", "latitude"), 
      crs = 4326
    ) %>% 
    dplyr::mutate(label = paste0(libelle_station,' (',code_station,')'))
  
  ## calculs assecs periode ete sur campagnes usuelles
  assecs <- onde_usuel %>% 
    dplyr::group_by(code_station, libelle_station) %>%
    dplyr::summarise(
      n_donnees = dplyr::n(),
      n_assecs = length(lib_ecoul3mod[lib_ecoul3mod=='Assec']),
      .groups = "drop"
      ) %>%
    dplyr::mutate(
      pourcentage_assecs = round(n_assecs / n_donnees * 100, digits = 2),
      taille_point = sqrt(pourcentage_assecs)
      )
  
  ## jointure + reprojection WGS84
  stations_onde_geo_usuelles <- stations_onde_geo %>%
    dplyr::left_join(assecs) %>%
    dplyr::mutate(
      pourcentage_assecs = tidyr::replace_na(pourcentage_assecs, replace = 0)
      ) %>% 
    sf::st_transform(crs = 4326) %>% 
    dplyr::mutate(label = paste0(libelle_station,' (',code_station,')'))
  
  
  #####################################
  # Mise en forme des tableaux pour les graphiques bilan
  prep_data_bilan <- function(df, mod, mod_levels, ...) {
    df %>% 
      dplyr::filter(
        Annee == max(Annee)
        ) %>% 
      dplyr::group_by(Mois, Annee, ..., {{mod}}) %>% 
      dplyr::summarise(NB = dplyr::n(), .groups = "drop_last") %>% 
      dplyr::mutate(frq = NB / sum(NB) *100) %>% 
      dplyr::arrange(Mois, ...) %>% 
      dplyr::mutate(
        dplyr::across(
          {{mod}},
          function(x) {
            factor(x, levels = mod_levels, ordered = TRUE)
          }
          )
      ) %>% 
    dplyr::mutate(Label = ifelse(is.na(NB),"",glue::glue("{NB}"))) %>% 
    dplyr::mutate(Label_p = ifelse(is.na(frq),"",glue::glue("{round(frq,0)}%"))) 
  }
  
  df_categ_obs_3mod <- onde_usuel %>% 
    prep_data_bilan(
      mod = lib_ecoul3mod,
      mod_levels = c("Ecoulement visible",
                     "Ecoulement non visible",
                     "Assec",
                     "Observation impossible",
                     "Donnée manquante"),
      code_departement
    )

  df_categ_obs_3mod_reg <- onde_usuel %>% 
    prep_data_bilan(
      mod = lib_ecoul3mod,
      mod_levels = c("Ecoulement visible",
                     "Ecoulement non visible",
                     "Assec",
                     "Observation impossible",
                     "Donnée manquante")
    )
  
  df_categ_obs_4mod <- onde_usuel %>% 
    prep_data_bilan(
      mod = lib_ecoul4mod,
      mod_levels = c("Ecoulement visible acceptable",
                     "Ecoulement visible faible",
                     "Ecoulement non visible",
                     "Assec",
                     "Observation impossible",
                     "Donnée manquante"),
      code_departement
    )

  df_categ_obs_4mod_reg <- onde_usuel %>% 
    prep_data_bilan(
      mod = lib_ecoul4mod,
      mod_levels = c("Ecoulement visible acceptable",
                     "Ecoulement visible faible",
                     "Ecoulement non visible",
                     "Assec",
                     "Observation impossible",
                     "Donnée manquante")
    )
  
  ## Heatmap
  resumer_data_heatmap <- function(grouped_df) {
    grouped_df %>% 
      dplyr::summarise(n_donnees = dplyr::n(), 
                       n_assecs = length(lib_ecoul3mod[lib_ecoul3mod == 'Assec']),
                       .groups = "drop") %>% 
      dplyr::mutate(pourcentage_assecs = round(n_assecs / n_donnees * 100, digits = 2),
                    taille_point = sqrt(pourcentage_assecs+1)) %>% 
      dplyr::arrange(Annee,Mois) %>% 
      tidyr::complete(Annee,Mois) %>% 
      dplyr::mutate(Mois = factor(Mois)) %>%
      # label pourcentage
      dplyr::mutate(Label = ifelse(is.na(n_assecs),"",glue::glue("{n_assecs}/{n_donnees}"))) %>% 
      # label (nb stations / nb total)
      dplyr::mutate(Label_p = ifelse(is.na(n_assecs),"",glue::glue("{round(pourcentage_assecs,0)}%")))
  }
  
  
  heatmap_df <- onde_usuel %>% 
    dplyr::distinct(code_station, libelle_station, Annee, Mois, lib_ecoul3mod) %>% 
    dplyr::group_by(Mois,Annee) %>%
    resumer_data_heatmap()
  
  heatmap_df_dep <- onde_usuel %>% 
    dplyr::group_by(code_departement) %>% 
    dplyr::group_split(.keep = TRUE) %>% 
    purrr::map_df(
      function(df_dep) {
        df_dep %>% 
          dplyr::distinct(code_departement, code_station, libelle_station, Annee, Mois, lib_ecoul3mod) %>% 
          dplyr::group_by(code_departement, Mois,Annee) %>%
          resumer_data_heatmap()
      }
    )
  
  ## Récurrence assecs
  prep_data_recurrence <- function(df, ...) {
    df %>% 
      dplyr::distinct(..., code_station, libelle_station, Annee, Mois, lib_ecoul3mod) %>% 
      dplyr::mutate(mois_num = as.numeric(Mois)) %>% 
      dplyr::as_tibble() %>%
      dplyr::arrange(code_station, Annee, Mois) %>% 
      dplyr::group_by(
        code_station,Annee,
        ID = data.table::rleid(code_station,lib_ecoul3mod == 'Assec' )
        ) %>%
      dplyr::mutate(
        mois_assec_consec = ifelse(
          lib_ecoul3mod == 'Assec', 
          dplyr::row_number(), 0L
          )
        ) %>% 
      dplyr::group_by(..., Annee,code_station) %>% 
      dplyr::summarise(
        max_nb_mois_assec  = max(mois_assec_consec),
        .groups = "drop"
        ) %>% 
      dplyr::group_by(..., Annee, max_nb_mois_assec) %>%
      dplyr::summarise(nb_station = dplyr::n(), .groups = "drop_last") %>% 
      dplyr::mutate(pct = prop.table(nb_station)) %>% 
      dplyr::mutate(label = ifelse(max_nb_mois_assec == '1' | max_nb_mois_assec == '0',
                                   paste0(max_nb_mois_assec, " mois"),
                                   paste0(max_nb_mois_assec, " mois cons\u00e9cutifs"))) %>% 
      dplyr::ungroup()
  }
  
  order_fac_levels <- function(df) {
    df %>% 
      dplyr::mutate(
        max_nb_mois_assec = factor(max_nb_mois_assec,ordered = TRUE) %>% 
      forcats::fct_rev()
        )
  }
  
  duree_assecs_df <- onde_usuel %>% 
    prep_data_recurrence() %>% 
    order_fac_levels()
  
  duree_assecs_df_dep <- onde_usuel %>% 
    dplyr::group_by(code_departement) %>% 
    dplyr::group_split(.keep = TRUE) %>% 
    purrr::map_df(
      prep_data_recurrence,
      code_departement
    ) %>% 
    order_fac_levels()
  
  #####################################
  ## Donnees Propluvia
  load(file = 'data/raw_data/propluvia_zone.Rdata')
  
  propluvia <- propluvia_zone %>% 
    dplyr::filter(type == 'SUP') %>% 
    dplyr::filter(dpt %in% conf_dep)
  
  ## Dernières campagnes
  date_derniere_campagne_usuelle <- 
    unique(onde_dernieres_campagnes_usuelles$Mois_campagne) %>% 
    max() %>% 
    format("%m/%Y") 
  
  date_derniere_campagne_comp <- 
    unique(onde_dernieres_campagnes_comp$Mois_campagne) %>% 
    max() %>% 
    format("%m/%Y")
  
  # Données cartes
  stations_onde_geo_map1 <- onde_periode %>% 
    dplyr::group_by(code_station) %>% 
    dplyr::mutate(pourcentage_assecs = length(lib_ecoul3mod[lib_ecoul3mod=='Assec' & libelle_type_campagne == "usuelle"]) / length(lib_ecoul3mod[libelle_type_campagne == "usuelle"])) %>% 
    dplyr::group_by(code_station, libelle_type_campagne) %>% 
    dplyr::filter(date_campagne == max(date_campagne)) %>% 
    dplyr::group_by(code_station) %>% 
    dplyr::filter(
      libelle_type_campagne == "usuelle" | 
        date_campagne == max(date_campagne)
      ) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(id = paste0(code_station, '_', libelle_type_campagne)) %>%
    dplyr::mutate(
      icone_3mod = dplyr::case_when(
        libelle_type_campagne == "usuelle" &
          lib_ecoul3mod == "Assec" ~
          "../www/icons/usuelle_assec.png",
        libelle_type_campagne == "usuelle" &
          lib_ecoul3mod == "Ecoulement non visible" ~ 
          "../www/icons/usuelle_ecoulement_non_visible.png",
        libelle_type_campagne == "usuelle" &
          lib_ecoul3mod == "Ecoulement visible" ~
          "../www/icons/usuelle_ecoulement_visible.png",
        libelle_type_campagne == "usuelle" & 
          lib_ecoul3mod == "Observation impossible" ~ 
          "../www/icons/usuelle_observation_impossible.png",
        libelle_type_campagne == "usuelle" &
          lib_ecoul3mod == "Donnée manquante" ~ 
          "../www/icons/usuelle_donnee_manquante.png",
        libelle_type_campagne == "complémentaire" &
          lib_ecoul3mod == "Assec" ~ 
          "../www/icons/complementaire_assec.png",
        libelle_type_campagne == "complémentaire" &
          lib_ecoul3mod == "Ecoulement non visible" ~
          "../www/icons/complementaire_ecoulement_non_visible.png",
        libelle_type_campagne == "complémentaire" &
          lib_ecoul3mod == "Ecoulement visible" ~ 
          "../www/icons/complementaire_ecoulement_visible.png",
        libelle_type_campagne == "complémentaire" &
          lib_ecoul3mod == "Observation impossible" ~
          "../www/icons/complementaire_observation_impossible.png",
        libelle_type_campagne == "complémentaire" & 
          lib_ecoul3mod == "Donnée manquante" ~ 
          "../www/icons/complementaire_donnee_manquante.png"
      )
    ) %>% 
    dplyr::mutate(
      icone_4mod = dplyr::if_else(
        lib_ecoul4mod == "Ecoulement visible faible",
        stringr::str_replace_all(
          string = icone_3mod, 
          pattern = "ecoulement_visible", 
          replacement = "ecoulement_faible"
        ),
        icone_3mod
      )
    ) %>% 
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
  
  depts_sel <- depts %>%
    dplyr::filter(code_insee %in% conf_dep) %>% 
    sf::st_transform(crs = 4326)
  depts_sel_bbox <- sf::st_bbox(depts_sel)
  
  masque_eu <- other_eu_countries %>% 
    sf::st_transform(crs = 4326) %>% 
    sf::st_difference(
      depts_sel %>% 
        dplyr::summarise()
    )
  
  icones_3mod <- stations_onde_geo_map1  %>% 
    dplyr::rowwise() %>% 
    dplyr::group_split() %>% 
    purrr::map(
      function(df_i) {
        leaflet::makeIcon(
          iconUrl = df_i$icone_3mod,
          iconWidth = approx(x = c(0,1), y = c(8, 35), xout = df_i$pourcentage_assecs)$y + ifelse(df_i$libelle_type_campagne == "usuelle", 5, 0),
          iconHeight = approx(x = c(0,1), y = c(8, 35), xout = df_i$pourcentage_assecs)$y + ifelse(df_i$libelle_type_campagne == "usuelle", 5, 0)
        )
      }
    ) %>% 
    purrr::set_names(stations_onde_geo_map1$id) %>% 
    (function(l) {
      # code adapté de leaflet::iconList
      res <- structure(l, class = "leaflet_icon_set")
      cls <- unlist(lapply(res, inherits, "leaflet_icon"))
      if (any(!cls))
        stop("Arguments passed must be icon objects returned from makeIcon()")
      res
    })
  
  icones_4mod <- stations_onde_geo_map1  %>% 
    dplyr::rowwise() %>% 
    dplyr::group_split() %>% 
    purrr::map(
      function(df_i) {
        leaflet::makeIcon(
          iconUrl = df_i$icone_4mod,
          iconWidth = approx(x = c(0,1), y = c(8, 35), xout = df_i$pourcentage_assecs)$y + ifelse(df_i$libelle_type_campagne == "usuelle", 5, 0),
          iconHeight = approx(x = c(0,1), y = c(8, 35), xout = df_i$pourcentage_assecs)$y + ifelse(df_i$libelle_type_campagne == "usuelle", 5, 0)
        )
      }
    ) %>% 
    purrr::set_names(stations_onde_geo_map1$id) %>% 
    (function(l) {
      # code adapté de leaflet::iconList
      res <- structure(l, class = "leaflet_icon_set")
      cls <- unlist(lapply(res, inherits, "leaflet_icon"))
      if (any(!cls))
        stop("Arguments passed must be icon objects retruned from makeIcon()")
      res
    })
  
  
  
  stations_anciennes_onde_geo_map1 <-
    stations_inactives_onde_geo %>% 
    dplyr::left_join(
      onde_dernieres_campagnes_anciennes_stations %>% 
        dplyr::select(code_station, Couleur_3mod , Couleur_4mod, date_campagne, label_point_3mod , label_point_4mod)
    ) 
  
  ########################
  # Sauvegarde des objets 
  save(
    date_derniere_campagne_usuelle,
    date_derniere_campagne_comp,
    df_categ_obs_4mod,
    stations_onde_geo_map1,
    icones_3mod, icones_4mod,
    stations_inactives_onde_geo,
    stations_anciennes_onde_geo_map1,
    masque_eu,
    depts_sel,
    depts_sel_bbox,
    propluvia,
    file = "data/processed_data/donnees_cartes.rda"
  )
  
  save(stations_onde_geo_usuelles,
       stations_inactives_onde_geo, 
       onde_dernieres_campagnes,
       onde_dernieres_campagnes_usuelles, 
       onde_dernieres_campagnes_comp,
       onde_periode,
       onde_dernieres_campagnes_anciennes_stations,
       onde_anciennes_stations,
       df_categ_obs_3mod,
       df_categ_obs_3mod_reg,
       mes_couleurs_3mod,
       df_categ_obs_4mod,
       df_categ_obs_4mod_reg,
       mes_couleurs_4mod,
       heatmap_df,
       heatmap_df_dep,
       duree_assecs_df,
       duree_assecs_df_dep,
       file = "data/processed_data/donnees_pour_graphiques.rda")                     
  
}
