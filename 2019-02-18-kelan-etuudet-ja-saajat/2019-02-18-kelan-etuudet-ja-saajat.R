#' ---
#' title: "Käyttöesimerkkejä: Kelan etuuksien saajat ja etuusmäärät"
#' author: "Markus Kainu"
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
rmarkdown::render(input = "./2019-02-18-kelan-etuudet-ja-saajat/2019-02-18-kelan-etuudet-ja-saajat.R", 
                  output_file = "./2019-02-18-kelan-etuudet-ja-saajat.md")

#+ knitr_setup, include=F
library(knitr)
knitr::opts_chunk$set(list(echo=TRUE, # printtaa koodi outputtiin
                           eval=TRUE, # evaluoi kaikki kimpaleet jos ei erikseen kielletty
                           cache=FALSE, # älä luo välimuistia (isoissa datoissa hyvin kätevä)
                           warning=FALSE, # älä printtaa varoituksia
                           message=FALSE, # älä printtaa pakettien viestejä
                           fig.width = 10, # kuvien oletusleveys
                           fig.heigth = 10)) # kuvien oletuskorkeus
options(scipen = 999)

#+ project_setup
library(dplyr)
library(ggplot2)
library(jsonlite)
library(ckanr)
library(readr)
library(knitr)
library(glue)
library(hrbrthemes)

#' ## Resurssien lataaminen
#' 
#+ setup
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
resources <- x$results[[1]]$resources
dat <- read_csv2(resources[[1]]$url) # Lataa data
meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

#' ## Datan ja metadatan kuvailu
#' 
#' **Datan kuvaustieto**
#+ print_description, results = "asis"
meta$description %>% cat()

#' **Datan muuttujatieto**
#+ print_metadata
meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

#' **Datan ensimmäiset rivit**
#+ print_data
head(dat)  %>% kable(format = "markdown")

#' 
#' ## Kuvio
#' 
#+ kuva1
dat %>% 
  filter(vuosi == 2018,
         etuus == "Lapsilisä") %>% 
  arrange(desc(maksetut_etuudet_euroa)) %>% 
  slice(1:20) %>% 
  mutate(kunta = forcats::fct_reorder(kunta, maksetut_etuudet_euroa)) %>% 
  ggplot(aes(x = kunta, y = maksetut_etuudet_euroa, label = maksetut_etuudet_euroa)) + 
  geom_col() + 
  coord_flip() + 
  theme_minimal() +
  geom_text(aes(y = 0), hjust = 0, color = "white") +
  labs(title = "Esimerkkikuvion esimerkkiotsikko") +
  theme_ft_rc()

#' ## Datastore-api
#' 
#' Jos et tarvitse koko aineistoa, voit suodattaa siitä osio SQL:llä käyttäen CKAN:n DataStore-rajapintaa.
#' 
#' Alla olevassa esimerkissä tehdään rajaus `kunta`-muuttujasta ja siis etsitään vaan kuntaa *Veteli* koskevat tiedot.
#+
kunta <- "Veteli"
res <- ckanr::ds_search_sql(sql = glue("SELECT * from \"{resources[[1]]$id}\" WHERE kunta LIKE '{kunta}'"), as = "table")
res$records %>% 
  select(-`_full_text`, -`_id`) %>% 
  kable(format = "markdown")
