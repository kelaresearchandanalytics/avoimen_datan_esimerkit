#' ---
#' title: ""
#' author: ""
#' output:
#'   md_document:
#'   variant: markdown_github
#'   highlight: tango
#' ---
#' 
#' 
#' 
#+ include = FALSE, eval = FALSE
# rmarkdown::render(input = "./2019-02-19-kelan-etuudet-ja-saajat/esimerkki_R.R", output_file = "./esimerkki_R.md")

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
ckanr_setup(url = "https://www.betaavoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
tibble(
  data = glue("<a href='https://www.betaavoindata.fi/data/fi/dataset/{x$results[[1]]$name}'>{x$results[[1]]$title}</a>"),
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
library(tidyr)
library(pxweb)


#' ## Resurssien lataaminen
#' 
#+ setup
ckanr_setup(url = "https://www.betaavoindata.fi/data/fi/")
x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
resources <- x$results[[1]]$resources
dat <- read.table(resources[[1]]$url, header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE) # Lataa data
meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

#' ## Datan ja metadatan kuvailu
#' 
#' **Datan kuvaustieto**
#+ print_description, results = "asis"
meta$description %>% cat()

#' **Datan muuttujatieto**
#+ print_metadata
meta$resources$schema$fields[[1]] %>%
  select(-values) %>% 
  kable(format = "markdown")

#' **Datan ensimmäiset rivit**
#+ print_data
head(dat)  %>% kable(format = "markdown")

#' 
#' ## Kuvio
#' 
#+ kuva1
dat %>% 
  as_tibble() %>% 
  filter(aikajakso == "vuosi",
         vuosi == 2018,
         etuus == "Lapsilisä") %>% 
  arrange(desc(euroa_per_saaja)) %>% 
  slice(1:20) %>% 
  mutate(kunta = forcats::fct_reorder(kunta, euroa_per_saaja)) %>% 
  ggplot(aes(x = kunta, y = euroa_per_saaja, label = euroa_per_saaja)) + 
  geom_col() + 
  coord_flip() + 
  theme_minimal() +
  geom_text(aes(y = 0), hjust = 0, color = "white") +
  labs(title = "Esimerkkikuvio")


#' 
#' ## Datan yhdistäminen Tilastokeskuksen kuntien avainlukuihin
#' 
#+ join
# PXWEB query 
pxweb_query_list <- 
  list("Alue 2019"=c("020","005","009","010","016","018","019","035","043","046","047","049","050","051","052","060","061",
  "062","065","069","071","072","074","075","076","077","078","079","081","082","086","111","090","091","097","098","099",
  "102","103","105","106","108","109","139","140","142","143","145","146","153","148","149","151","152","165","167","169",
  "170","171","172","176","177","178","179","181","182","186","202","204","205","208","211","213","214","216","217","218",
  "224","226","230","231","232","233","235","236","239","240","320","241","322","244","245","249","250","256","257","260",
  "261","263","265","271","272","273","275","276","280","284","285","286","287","288","290","291","295","297","300","301",
  "304","305","312","316","317","318","398","399","400","407","402","403","405","408","410","416","417","418","420","421",
  "422","423","425","426","444","430","433","434","435","436","438","440","441","475","478","480","481","483","484","489",
  "491","494","495","498","499","500","503","504","505","508","507","529","531","535","536","538","541","543","545","560",
  "561","562","563","564","309","576","577","578","445","580","581","599","583","854","584","588","592","593","595","598",
  "601","604","607","608","609","611","638","614","615","616","619","620","623","624","625","626","630","631","635","636",
  "678","710","680","681","683","684","686","687","689","691","694","697","698","700","702","704","707","729","732","734",
  "736","790","738","739","740","742","743","746","747","748","791","749","751","753","755","758","759","761","762","765",
  "766","768","771","777","778","781","783","831","832","833","834","837","844","845","846","848","849","850","851","853",
  "857","858","859","886","887","889","890","892","893","895","785","905","908","911","092","915","918","921","922","924",
  "925","927","931","934","935","936","941","946","976","977","980","981","989","992"),
       "Tiedot"=c("M408","M411","M476","M391","M421","M478","M404","M410","M303","M297","M302","M44","M62","M70","M488","M486","M137","M140","M130","M162","M78","M485","M152","M72","M84","M106","M499","M496","M495","M497","M498"))

# Download data 
tk_lst <- 
  pxweb_get(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Kuntien_avainluvut/2019/kuntien_avainluvut_2019_viimeisin.px",
            query = pxweb_query_list)
tk_avainluvut <- as.data.frame(tk_lst, column.name.type = "text", variable.value.type = "text") %>% 
  # levitetään data
  spread(key = Tiedot, value = `Kuntien avainluvut`)

df <- left_join(dat, tk_avainluvut, by = c("kunta" = "Alue 2019"))

# Piirretään hajontakuvio
df2 <- df %>% 
  filter(aikajakso == "vuosi",
         vuosi == 2018,
         etuus == "Lapsilisä")

ggplot(df2, 
       aes(x = `Alle 15-vuotiaiden osuus väestöstä, %, 2018`, 
           y = euroa_per_saaja, 
           size = `Väkiluku, 2018`)) + 
  geom_point(alpha = .3) +
  labs(y = "Lapsilisä - euroa_per_saaja") + 
  theme_light()


#' ## Datastore-api
#' 
#' Jos et tarvitse koko aineistoa, voit suodattaa siitä osio SQL:llä käyttäen CKAN:n DataStore-rajapintaa.
#' 
#' Alla olevassa esimerkissä tehdään rajaus `kunta`-muuttujasta ja siis etsitään vaan kuntaa *Veteli* koskevat tiedot.
#+
kunta <- "Veteli"
res <- ckanr::ds_search_sql(sql = glue("SELECT * from \"{resources[[1]]$id}\" WHERE kunta = '{kunta}'"), as = "table")
res$records %>% 
  select(-`_full_text`, -`_id`) %>% 
  kable(format = "markdown")

