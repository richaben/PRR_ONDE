# ONDE_carto_mensuelle

Ce script permet de créer une cartographie interactive 🗺 de la situation mensuelle en région pour le dispositif [ONDE](https://onde.eaufrance.fr/) (Observatoire national des étiages de l'Office français de la biodiversité).

Cette carto est générée automatiquement avec les Github actions, de la phase de téléchargement des données ONDE (via le package R [`Hubeau`](https://github.com/inrae/hubeau) utilisant l'API Ecoulement sur https://hubeau.eaufrance.fr/) à la phase de création du fichier .html via le package R [`Rmarkdown`](https://github.com/rstudio/rmarkdown)).
