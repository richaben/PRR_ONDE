##%###############################%##
#                                   #
#### Préparation des graphiques  ####
#                                   #
##%###############################%##

'%>%' <- dplyr::'%>%'

source("_config.R")

load("data/onde_data/to_update.rda")
# to_update <- TRUE
load("data/processed_data/donnees_pour_graphiques.rda")

if (to_update) {
  library(sf)
  
  ## Cartes
  ### Préparation données
  
  ### popups
  
  produire_graph_pour_une_station <- 
    function(station_vec, onde_df, type_mod, mod_levels, mod_colors){
      
      prov <- onde_df %>%
        dplyr::mutate(
          Annee = factor(Annee, levels = min(Annee):max(Annee))
        ) %>% 
      dplyr::filter(code_station == station_vec) %>% 
          dplyr::mutate(label_p = paste0(libelle_type_campagne,'\n',{{type_mod}},'\n',date_campagne),
                 label_sta = paste0(libelle_station,' (',code_station,')'),
                 label_png = paste0("ONDE_dpt",code_departement,"_",label_sta)) %>% 
          dplyr::rename(modalite = {{type_mod}}) %>% 
          (function(df_temp) {
            dplyr::bind_rows(
              df_temp %>% 
                dplyr::filter(libelle_type_campagne == "complémentaire"),
              df_temp %>% 
                dplyr::filter(
                  libelle_type_campagne == "usuelle"
                ) %>% 
                tidyr::complete(
                  code_station, 
                  libelle_station,
                  Annee, 
                  Mois,
                  fill = list(
                    libelle_type_campagne = "usuelle",
                    modalite = "Donnée manquante"
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
              )
            
          }) %>% 
          dplyr::mutate(
            modalite = stringr::str_wrap(modalite, 12) %>% 
              factor(levels = mod_levels)
          ) %>% 
        dplyr::mutate(Annee = Annee %>% 
                        as.character() %>% 
                        as.numeric())
      
      nom_station <- unique(prov$label_sta)
      nom_station_graph <- unique(prov$label_png)
      
      graph1 <- prov %>% 
        ggplot2::ggplot(
          mapping = ggplot2::aes(
            x = Annee,
            y = as.numeric(Mois)
            )
        ) +
        ggplot2::geom_point(
          mapping = ggplot2::aes(
            fill = stringr::str_wrap(modalite, 12),
            shape = libelle_type_campagne,
            size = libelle_type_campagne,
          ), 
          col='black'
            ) +
        ggplot2::coord_flip() +
        ggplot2::scale_fill_manual(
          values = mod_colors, 
          breaks = levels(prov$modalite), 
          name = 'Modalités'
          ) +
        ggplot2::scale_shape_manual(
          values = c(21,22),
          name = 'Type campagne'
          ) +
        ggplot2::scale_size_manual(
          values = c(5,10),
          name = 'Type campagne'
          ) +
        ggplot2::scale_y_continuous(
          breaks = 1:12, 
          labels = 1:12, 
          limits = c(1, 12)
          ) +
        ggplot2::scale_x_continuous(
          breaks = min(prov$Annee, na.rm = T):max(prov$Annee, na.rm = T),
          labels = min(prov$Annee, na.rm = T):max(prov$Annee, na.rm = T)
          ) +
        ggplot2::labs(
          x = "", y = "Mois", 
          title = unique(prov$libelle_station),
          subtitle = unique(prov$code_station)
          ) +
        ggplot2::theme_bw() +
        ggplot2::theme(
          title = ggplot2::element_text(face = 'bold'),
          axis.text.x = ggplot2::element_text(size=10),
          axis.text.y = ggplot2::element_text(size=10),
          panel.grid = ggplot2::element_blank()
        ) +
        ggplot2::guides(
          fill = ggplot2::guide_legend(override.aes=list(shape = 22, size = 5))
          )
      
      graph1
    }
  
  if (dir.exists("www/png"))
    unlink("www/png", recursive = TRUE)
  if (dir.exists("www/popups"))
    unlink("www/popups", recursive = TRUE)
  
  dir.create("www/popups/3mod", recursive = TRUE)
  dir.create("www/popups/4mod", recursive = TRUE)
  
  save_popups <- function(graphs, dir) {
    purrr::walk(
      names(graphs),
      function(station) {
        tmp <- tempfile(pattern = "popup", fileext = ".png")
        
        ggplot2::ggsave(
          plot = graphs[[station]],
          filename = tmp,
          width = 14,
          height = 10,
          units = "cm",
          dpi = 150
        )
        
        png::readPNG(tmp) %>% 
          webp::write_webp(target = paste0(dir, station, ".webp"))
      }
    )
  }
  
  ### -> graphiques 3modalités
  purrr::map(
      .x = stations_onde_geo_usuelles$code_station, 
      .f = produire_graph_pour_une_station, 
      type_mod = lib_ecoul3mod,
      onde_df = onde_periode,
      mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible", "Observation\nimpossible", "Donnée\nmanquante"),
      mod_colors = mes_couleurs_3mod
      ) %>% 
    purrr::set_names(stations_onde_geo_usuelles$code_station) %>% 
    save_popups(dir = "www/popups/3mod/")
  
  ### -> graphiques 4modalités
  purrr::map(
      .x = stations_onde_geo_usuelles$code_station, 
      .f = produire_graph_pour_une_station, 
      type_mod = lib_ecoul4mod,
      onde_df = onde_periode,
      mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible\nfaible", "Ecoulement\nvisible\nacceptable", "Observation\nimpossible", "Donnée\nmanquante"),
      mod_colors = mes_couleurs_4mod
      ) %>% 
    purrr::set_names(stations_onde_geo_usuelles$code_station) %>% 
    save_popups(dir = "www/popups/4mod/")
  
  ### -> graphiques 3modalités anciennes stations
  purrr::map(
      .x = stations_inactives_onde_geo$code_station, 
      .f = produire_graph_pour_une_station, 
      type_mod = lib_ecoul3mod,
      onde_df = onde_anciennes_stations,
      mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible", "Observation\nimpossible", "Donnée\nmanquante"),
      mod_colors = mes_couleurs_3mod
    ) %>% 
    purrr::set_names(stations_inactives_onde_geo$code_station) %>% 
    save_popups(dir = "www/popups/3mod/")

  ### -> graphiques 4modalités anciennes stations
  purrr::map(
      .x = stations_inactives_onde_geo$code_station, 
      .f = produire_graph_pour_une_station, 
      type_mod = lib_ecoul4mod,
      onde_df = onde_anciennes_stations,
      mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible\nfaible", "Ecoulement\nvisible\nacceptable", "Observation\nimpossible", "Donnée\nmanquante"),
      mod_colors = mes_couleurs_4mod
    ) %>% 
    purrr::set_names(stations_inactives_onde_geo$code_station) %>% 
    save_popups(dir = "www/popups/4mod/")

  ### -> graphiques 3modalités stations onde+
  purrr::map(
    .x = stations_onde_plus_geo$code_station, 
    .f = produire_graph_pour_une_station, 
    type_mod = lib_ecoul3mod,
    onde_df = onde_plus,
    mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible", "Observation\nimpossible", "Donnée\nmanquante"),
    mod_colors = mes_couleurs_3mod
  ) %>% 
    purrr::set_names(stations_onde_plus_geo$code_station) %>% 
    save_popups(dir = "www/popups/3mod/")
  
  ### -> graphiques 4modalités stations onde+
  purrr::map(
    .x = stations_onde_plus_geo$code_station, 
    .f = produire_graph_pour_une_station, 
    type_mod = lib_ecoul4mod,
    onde_df = onde_plus,
    mod_levels = c("Assec", "Ecoulement\nnon visible", "Ecoulement\nvisible\nfaible", "Ecoulement\nvisible\nacceptable", "Observation\nimpossible", "Donnée\nmanquante"),
    mod_colors = mes_couleurs_4mod
  ) %>% 
    purrr::set_names(stations_onde_plus_geo$code_station) %>% 
    save_popups(dir = "www/popups/4mod/")
  
  
  
  ## Conditions d'écoulement lors des campagnes usuelles de l'année en cours
plot_bilan_prop <- function(data_bilan, lib_ecoulement, regional = FALSE, modalites = ggplot2::waiver()) {
  data_bilan %>% 
    
    ggplot2::ggplot(
      mapping = ggplot2::aes(
        y = frq, 
        x = forcats::fct_rev(factor(Mois)),
        fill= forcats::fct_rev({{lib_ecoulement}}), 
        label=Label_p
        )
      ) +
    ggplot2::geom_bar(
      position = "stack", 
      stat = "identity",
      alpha = 0.7, 
      colour = 'black', 
      width = 0.7, 
      linewidth = 0.01
    ) +
    {
      if(regional == FALSE)
      ggplot2::facet_grid(~code_departement)
      } +
    ggrepel::geom_text_repel(
      size = 3,
      color = "black", 
      fontface = 'bold.italic',
      position = ggplot2::position_stack(vjust = 0.5)
    ) +
    ggplot2::coord_flip() +
    ggplot2::ylab("Pourcentage (%)") +
    ggplot2::xlab("Mois") +
    ggplot2::scale_fill_manual(
      name = "Situation stations",
      values = c("Donnée manquante" = "grey90",
                 "Observation impossible" = "grey50",
                 "Assec" = "#d73027",
                 "Ecoulement non visible" = "#fe9929",
                 "Ecoulement visible faible" = "#bdd7e7",
                 "Ecoulement visible acceptable" = "#4575b4",
                 "Ecoulement visible" = "#4575b4"
                 ),
      breaks = modalites,
      drop = FALSE
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      title = ggplot2::element_text(size = 11, face = "bold"), 
      legend.text = ggplot2::element_text(size = 11),
      legend.title = ggplot2::element_text(size = 11, face = 'bold'),
      axis.text.y = ggplot2::element_text(size = 11, colour = 'black'),
      axis.text.x = ggplot2::element_text(size = 11, colour = 'black'),
      strip.text.x = ggplot2::element_text(size = 11, color = "black", face = "bold"),
      strip.background = ggplot2::element_rect(
        color="black", fill="grey80", linewidth = 1, linetype="solid"
      ),
      panel.grid.major = ggplot2::element_line(colour = NA),
      panel.grid.minor = ggplot2::element_line(colour = NA),
      legend.position = "bottom",
      plot.background = ggplot2::element_blank(),
    ) +
    ggplot2::guides(
      fill = ggplot2::guide_legend(nrow = 2, byrow = FALSE)
      )
}

  bilan_cond_reg_typo_nat <- plot_bilan_prop(
    df_categ_obs_3mod_reg %>% 
      dplyr::mutate(lib_ecoul3mod = forcats::fct_rev(lib_ecoul3mod)),
    lib_ecoulement = lib_ecoul3mod, 
    regional = TRUE,
    modalites = c("Donnée manquante", "Observation impossible", "Assec", "Ecoulement non visible", "Ecoulement visible")
    )
  
  bilan_cond_reg_typo_dep <- plot_bilan_prop(
    df_categ_obs_4mod_reg %>% 
      dplyr::mutate(lib_ecoul4mod = forcats::fct_rev(lib_ecoul4mod)), 
    lib_ecoulement = lib_ecoul4mod, 
    regional = TRUE,
    modalites = c("Donnée manquante", "Observation impossible", "Assec", "Ecoulement non visible", "Ecoulement visible faible", "Ecoulement visible acceptable")
  )
  
  bilan_cond_dep <- conf_dep %>% 
    purrr::map(
      function(d) {
        if (d %in% df_categ_obs_4mod$code_departement) {
          plot_bilan_prop(
            df_categ_obs_4mod %>% 
              dplyr::filter(code_departement == d) %>% 
              dplyr::mutate(lib_ecoul4mod = forcats::fct_rev(lib_ecoul4mod)), 
            lib_ecoulement = lib_ecoul4mod,
            modalites = c("Donnée manquante", "Observation impossible", "Assec", "Ecoulement non visible", "Ecoulement visible faible", "Ecoulement visible acceptable")
          )
        }
      }
    ) %>% 
    purrr::set_names(conf_dep)
  
  ## Sévérité des assecs
  plot_heatmap <- function(df_heatmap) {
    df_heatmap %>% 
      ggplot2::ggplot(
        mapping = ggplot2::aes(
          x = Annee, 
          y = forcats::fct_rev(factor(Mois)),
          fill = pourcentage_assecs
          )
      ) + 
      ggplot2::geom_tile(col = 'white', linewidth = 0.5) +
      ggplot2::scale_fill_gradientn(
        "% d\'assecs",
        colors = adjustcolor(hcl.colors(10, "RdYlBu", rev = T),
                             alpha.f = 0.8),
        limits = c(0,100),
        na.value = adjustcolor("grey90", alpha.f = 0.7)
      ) +
      ggplot2::geom_text(
        mapping = ggplot2::aes(label = Label_p),
        size = 3.5,
        color = "black",
        fontface = 'bold.italic'
        ) +
      ggplot2::scale_size(guide = 'none') +
      ggplot2::scale_x_continuous(
        breaks = scales::breaks_width(1),
        expand = c(0,0)
        ) +
      ggplot2::ylab("Mois") + 
      ggplot2::xlab(NULL) +
      ggplot2::ggtitle(glue::glue("Proportion de stations en assec")) +
      ggplot2::theme_bw() +
      ggplot2::theme(
        title = ggplot2::element_text(size = 11,face = 'bold'), 
        axis.text.x = ggplot2::element_text(size=11,angle = 45,hjust = 1),
        axis.text.y = ggplot2::element_text(size=11),
        legend.position = 'right',
        axis.ticks = ggplot2::element_blank(),
        panel.grid = ggplot2::element_blank()
      )
  }
  
  severite_assecs_reg <- plot_heatmap(heatmap_df)
  
  severite_assecs_dep <- conf_dep %>% 
    purrr::map(
      function(d) {
        plot_heatmap(
          heatmap_df_dep %>% 
            dplyr::filter(code_departement == d)
          )
      }
    ) %>% 
    purrr::set_names(conf_dep)
  
  ## Des assecs qui se suivent
  plot_assecs_consecutifs <- function(df_assecs, round_prec = 1) {
    df_assecs %>%
      dplyr::ungroup() %>% 
      dplyr::filter(label != '0 mois') %>% 
      dplyr::mutate(label = factor(
        label, 
        levels = c(
          paste0(5:2, " mois consécutifs"), "1 mois"
        )
      )
      ) %>% 
      ggplot2::ggplot(
        mapping = ggplot2::aes(x = as.factor(Annee), y = pct, fill = label)
      ) + 
      ggplot2::geom_col(width = .95) +
      ggplot2::geom_text(
        mapping = ggplot2::aes(y = pct, label = nb_station), 
        fontface ="italic",
        size = 3.5,
        position = ggplot2::position_stack(vjust = 0.5),
        show.legend = FALSE
      ) +
      ggplot2::scale_fill_manual(
        values = c(
          "1 mois" = "#FFFFB2FF",
          "2 mois consécutifs" = "#FECC5CFF",
          "3 mois consécutifs" = "#FD8D3CFF",
          "4 mois consécutifs" = "#F03B20FF",
          "5 mois consécutifs" = "#BD0026FF"
        ),
        drop = FALSE
      ) +
      ggplot2::scale_y_continuous(labels = scales::percent_format(round_prec)) +
      ggplot2::scale_x_discrete(limits = factor(sort(unique(df_assecs$Annee)))) +
      ggplot2::ggtitle("Proportions et nombre de stations concernées") +
      ggplot2::theme_bw() +
      ggplot2::theme(
        title = ggplot2::element_text(size = 11,face = 'bold'), 
        axis.text.x = ggplot2::element_text(size = 11, angle = 45,hjust = 1),
        axis.text.y = ggplot2::element_text(size=11),
        panel.grid.major.x = ggplot2::element_blank(),
        panel.grid.minor = ggplot2::element_blank()
      ) +
      ggplot2::ylab(NULL) + 
      ggplot2::xlab(NULL)
  }
  
  assecs_consecutifs_reg <- plot_assecs_consecutifs(duree_assecs_df)
  
  assecs_consecutifs_dep <- conf_dep %>% 
    purrr::map(
      function(d) {
        plot_assecs_consecutifs(
          duree_assecs_df_dep %>% 
            dplyr::filter(code_departement == d),
          round_prec = .1
          )
      }
    ) %>% 
    purrr::set_names(conf_dep)

  ## Sauvegarde
  save(
    bilan_cond_reg_typo_nat,
    bilan_cond_reg_typo_dep,
    bilan_cond_dep,
    severite_assecs_reg,
    severite_assecs_dep,
    assecs_consecutifs_reg,
    assecs_consecutifs_dep,
    file = "data/processed_data/graphiques.rda"
    )
}
