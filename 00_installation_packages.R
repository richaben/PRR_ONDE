## Dépendances 

pkg_gh <- c("richaben/ondetools", "inrae/hubeau")
pkg_cran <- c("tidyverse", "purrr", "sf", "mapview", "leaflet", "leaflet.extras", "ggrepel", "glue", "forcats", "scales", "data.table", "lubridate", "stringr", "tidyr", "ggplot2", "knitr", "rmarkdown", "htmltools", "leafem", "png", "webp")

try(pak::pkg_install(c(pkg_gh, pkg_cran)))

sapply(
  X = pkg_cran,
  FUN = function(pkg) {
    if (!require(pkg, character.only = TRUE)) install.packages(pkg)
    }
  )
