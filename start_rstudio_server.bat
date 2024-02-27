@echo off
start "" "http://localhost:8787"
docker run --rm -p 8787:8787 -e PASSWORD=prr_onde -v C:\Users\cedri\Documents\PRR_ONDE:/home/rstudio ofbidf/rstudio_prr_onde:latest
