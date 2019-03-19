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
#+ include = FALSE, eval = FALSE
rmarkdown::render(input = "./2019-03-19-suomen-elakkeensaajat-ja-keskimaaraiset-elakkeet/esimerkki_R.R", 
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
x <- package_search(q = "Kansaneläkelaitos", fq = "title:terveyspuntari")
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



#' ## Resurssien lataaminen
#' 
#+ setup
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:terveyspuntari")
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
  filter(vuosi == 2017,
         indeksi == "-kuolleisuusindeksi") %>% 
  arrange(desc(indeksin_arvo)) %>% 
  slice(1:20) %>% 
  mutate(kunta = forcats::fct_reorder(kunta, indeksin_arvo)) %>% 
  ggplot(aes(x = kunta, y = indeksin_arvo, label = indeksin_arvo)) + 
  geom_col() + 
  coord_flip() + 
  theme_minimal() +
  geom_text(aes(y = 0), hjust = 0, color = "white") +
  labs(title = "Esimerkkikuvion esimerkkiotsikko") +
  theme_light()


#' 
#' ## Datan yhdistäminen Tilastokeskuksen kuntien avainlukuihin
#' 
#+ join
library(pxweb)
tk_avainluvut <- 
  get_pxweb_data(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Kuntien_avainluvut/2018/kuntien_avainluvut_2018_viimeisin.px",
                 dims = list("Alue 2018" = c('*'),
                             Tiedot = c('*')),
                 clean = FALSE)
df <- left_join(dat, tk_avainluvut, by = c("kunta" = "Alue 2018"))
# Piirretään hajontakuvio
df2 <- df %>% 
  filter(vuosi == 2017,
         indeksi == "-kuolleisuusindeksi") 

ggplot(df2, aes(x = `Yli 64-vuotiaiden osuus väestöstä, %, 2017`, y = indeksin_arvo, size = `Väkiluku, 2017`)) + 
  geom_point(alpha = .3) +
  labs(y = "Kuolleisuusindeksi") + 
  theme_light()



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
