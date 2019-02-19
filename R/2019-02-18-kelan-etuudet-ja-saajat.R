#' ---
#' title: Avoimen datan käyttöesimerkit
#' author: Markus Kainu
#' date: "Päivitetty: **`r Sys.time()`**"
#' output:
#'   md_document:
#'   variant: markdown_github
#' ---
#' 
#'  | pvm         | data        | tekijä   |
#'  | ---------   | -------     | -------- |
#'  | 2019-02-19  | [Kelan etuuksien saajat ja etuusmäärät](https://beta.avoindata.fi/data/fi/dataset/kelan-etuudet-ja-saajat) | Markus Kainu |
#' 
#' 
#' # Käyttöesimerkkejä: Kelan etuuksien saajat ja etuusmäärät
#' 
#+ include = FALSE, eval = FALSE
rmarkdown::render(input = "./R/2019-02-18-kelan-etuudet-ja-saajat.R", 
                  output_file = "../esimerkit/2019-02-18-kelan-etuudet-ja-saajat.md")

#+ knitr_setup, include=F
library(knitr)
knitr::opts_chunk$set(list(echo=TRUE, # printtaa koodi outputtiin
                           eval=TRUE, # evaluoi kaikki kimpaleet jos ei erikseen kielletty
                           cache=FALSE, # älä luo välimuistia (isoissa datoissa hyvin kätevä)
                           warning=FALSE, # älä printtaa varoituksia
                           message=FALSE, # älä printtaa pakettien viestejä
                           fig.width = 10, # kuvien oletusleveys
                           fig.heigth = 10)) # kuvien oletuskorkeus

#+ project_setup
library(tidyverse)
library(jsonlite)
library(ckanr)

#' # Datan ja metadatan lataaminen
#' 
#+ setup
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
resources <- x$results[[1]]$resources
resources[[1]]$name
resources[[2]]$name

dat <- readr::read_csv2(resources[[1]]$url)
meta <- fromJSON(txt = resources[[2]]$url)

#' # Datan ja metadatan kuvailu
#' 

#+ print_data
meta$profile
meta$name
meta$title
meta$description

# Datan muuttujatieto
meta$resources$schema$fields[[1]]

# Datan ensimmäiset rivit 
head(dat)

#'
#' # Kuvio1
#' 
#' 
#+ kuva1
library(ggplot2)
dat %>% 
  filter(vuosi == 2018,
         etuus == "Lapsilisä") %>% 
  arrange(desc(saajat)) %>% 
  slice(1:20) %>% 
  mutate(kunta = forcats::fct_reorder(kunta, saajat)) %>% 
  ggplot(aes(x = kunta, y = saajat, label = saajat)) + geom_col() + coord_flip() + theme_minimal() +
  geom_text(aes(y = 0), hjust = 0, color = "white")

