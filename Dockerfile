# Utiliser rocker/geospatial comme image de base
FROM rocker/geospatial

# Mettre à jour les packages du système
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
  libxml2-dev \
  libcairo2-dev \
  libpq-dev \
  libssh2-1-dev \
  libcurl4-openssl-dev \
  libssl-dev

# Installer les packages R
RUN install2.r --error \
  renv \
  dplyr \
  lubridate \
  purrr \
  stringr \
  hubeau \
  data.table \
  forcats \
  glue \
  leaflet \
  sf \
  tidyr \
  ggplot2 \
  ggrepel \
  png \
  scales \
  webp \
  rmarkdown \
  shiny \
  knitr \
  leafem \
  mapview \
  htmltools \
  leafpop \
  tidyverse \
  leaflet.extras

# Installer ondetools depuis Github
RUN R -e "remotes::install_github('richaben/ondetools')"
