#' ---
#' title: "Käyttöesimerkkejä: Lapsilisän saajat ja maksetut lapsilisät"
#' author: "Markus Koinu"
#' date: "Päivitetty: **`r Sys.time()`**"
#' output:
#'   md_document:
#'   variant: markdown_github
#' ---
#' 
#'  | pvm         | data        | tekijä   |
#'  | ---------   | -------     | -------- |
#'  | 2019-02-27  | [Lapsilisän saajat ja maksetut lapsilisät ](https://beta.avoindata.fi/data/fi/dataset/lapsilisan-saajat-ja-maksetut-lapsilisat) | Markus Kainu |
#' 
#' # Käyttöesimerkkejä: Lapsilisän saajat ja maksetut lapsilisät
#' 
#+ include = FALSE, eval = FALSE
rmarkdown::render(input = "./2019-02-27-lapsilisän-saajat-ja-maksetut-lapsilisät/2019-02-27-lapsilisän-saajat-ja-maksetut-lapsilisät.R", 
                  output_file = "./2019-02-27-lapsilisän-saajat-ja-maksetut-lapsilisät.md")

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
# CRAN-paketit
library(dplyr)
library(ggplot2)
library(jsonlite)
library(ckanr)
library(readr)
library(knitr)
library(glue)

#' ## Resurssien lataaminen
#' 
#+ setup
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:lapsilisän saajat")
resources <- x$results[[1]]$resources

dat <- readr::read_csv2(resources[[1]]$url) # data
meta <- fromJSON(txt = resources[[2]]$url) # metadata

#' # Resurssien kuvailu
#' 
#' **Datan kuvaustieto**
#' 
#+ print_description, results = "asis"
meta$description %>% cat()

#' **Datan muuttujatieto**
#+ print_metadata
meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

#' **Datan ensimmäiset rivit**
#+ print_data
head(dat) %>% kable(format = "markdown")

#' ## Kuvio
#' 
#+ kuva1
# valitaan ensin top 10 kuntaa, joissa korkeimmat keskimääräiset asumistukimenot
dat %>% 
  filter(vuosi == 2018) %>% 
  arrange(desc(lapsilisat_euroa_perhe)) %>% 
  slice(1:10) %>% pull(kunta) -> kunnat

# Piirretään kuva
dat %>% 
  filter(kunta %in% kunnat) %>% 
  ggplot(aes(x = kunta, y = lapsilisat_euroa_perhe, label = round(lapsilisat_euroa_perhe))) + 
  geom_col() + 
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Esimerkkikuvion esimerkkiotsikko")

#' ## Datastore-api
#' 
#' Jos et tarvitse koko aineistoa, voit suodattaa siitä osio SQL:llä käyttäen CKAN:n DataStore-rajapintaa.
#' 
#' Alla olevassa esimerkissä tehdään rajaus `kunta`-muuttujasta ja siis etsitään vaan kuntaa *Veteli* koskevat tiedot.
#+
kunta <- "Veteli"
res <- ckanr::ds_search_sql(sql = glue("SELECT * from \"{resources[[1]]$id}\" WHERE kunta LIKE '{kunta}'"), as = "table")
res$records %>% 
  # select(-`_full_text`, -`_id`) %>% 
  kable(format = "markdown")


