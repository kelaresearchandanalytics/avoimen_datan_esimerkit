#' ---
#' title: "Käyttöesimerkkejä: Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot"
#' author: "Markus Koinu"
#' date: "Päivitetty: **`r Sys.time()`**"
#' output:
#'   md_document:
#'   variant: markdown_github
#' ---
#' 
#'  | pvm         | data        | tekijä   |
#'  | ---------   | -------     | -------- |
#'  | 2019-02-19  | [Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot](https://beta.avoindata.fi/data/fi/dataset/kelan-yleisen-asumistuen-saajat) | Markus Kainu |
#' 
#' #' # Käyttöesimerkkejä: Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot
#' 
#+ include = FALSE, eval = FALSE
rmarkdown::render(input = "./R/2019-02-19-kelan-yleisen-asumistuen-saajat.R", 
                  output_dir = "./2019-02-19-kelan-yleisen-asumistuen-saajat")

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
library(tidyverse)
library(jsonlite)
library(ckanr)

#' # Datan ja metadatan lataaminen
#' 
#+ setup
ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:yleisen")
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

#' # Kuvio
#' 
#+ kuva1
library(ggplot2)
# valitaan ensin top 10 kuntaa, joissa korkeimmat keskimääräiset asumistukimenot
dat %>% 
  filter(ruokakuntatyyppi == "Yhteensä",
         vuosi == 2018) %>% 
  arrange(desc(asumistuki_keskim_euroa_kk)) %>% 
  slice(1:10) %>% pull(kunta) -> kunnat

dat %>% 
  filter(ruokakuntatyyppi == "Yhteensä",
         kunta %in% kunnat) %>% 
  ggplot(aes(x = vuosi, y = asumistuki_keskim_euroa_kk, label = kunta,color = kunta)) + 
  geom_line() + 
  theme_minimal() +
  geom_text(data = dat %>% 
              filter(ruokakuntatyyppi == "Yhteensä",
                     kunta %in% kunnat,
                     vuosi == 2018), hjust = 0) +
  theme(legend.position = "none") +
  labs(title = "Keskimääräinen asumistuki kuukaudessa")
