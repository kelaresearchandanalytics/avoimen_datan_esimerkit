#' ---
#' title: ""
#' author: ""
#' output:
#'   md_document:
#'   variant: markdown_github
#' ---
#' 
#' 
#' 
#' 
#' 
#+ include = FALSE, eval = FALSE
rmarkdown::render(input = "./2019-03-06-opintotuen-saajat-ja-maksetut-tuet/esimerkki_R.R", 
                  output_file = "./esimerkki_R.md")

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

#+ metaboksi, echo = FALSE
library(ckanr)
library(dplyr)
library(knitr)
library(glue)
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:opintotuen")
tibble(
  data = glue("<a href='https://beta.avoindata.fi/data/fi/dataset/{x$results[[1]]$name}'>{x$results[[1]]$title}</a>"),
  julkaistu = substr(x$results[[1]]$metadata_created, start = 1, stop = 10),
  ylläpitäjä = glue("<a href='mailto:{x$results[[1]]$maintainer_email}'>{x$results[[1]]$maintainer}</a>")
) %>% 
  kable(format = "markdown", escape = TRUE)

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
x <- package_search(q = "Kansaneläkelaitos", fq = "title:opintotuen")
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
         etuus == "Opintoraha") %>% 
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
