##%######################################################%##
#                                                          #
####    Generer le fichier Rmarkdown au format html     ####
#                                                          #
##%######################################################%##

## version: 23-11-2022

print("Creation du fichier html !")

library(tidyverse)
library(rmarkdown)

source("_config.R")

rmarkdown::render("assets/template.Rmd", 
                  output_file = "../index.html",
                  params = list(
                    set_author = conf_auteur,
                    set_title = conf_titre
                  ),
                  quiet = T)
