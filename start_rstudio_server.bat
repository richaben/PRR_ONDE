@echo off
setlocal

:: Récupère le chemin du dossier contenant le fichier .bat
set "chemin_du_script=%~dp0"

start "" "http://localhost:8787"
docker run --rm -p 8787:8787 -e PASSWORD=prr_onde -v %chemin_du_script%:/home/rstudio ofbidf/rstudio_prr_onde:latest

endlocal