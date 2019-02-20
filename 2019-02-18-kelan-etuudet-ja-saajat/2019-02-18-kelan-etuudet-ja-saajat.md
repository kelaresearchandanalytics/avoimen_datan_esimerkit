<table>
<thead>
<tr class="header">
<th>pvm</th>
<th>data</th>
<th>tekijä</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>2019-02-19</td>
<td><a href="https://beta.avoindata.fi/data/fi/dataset/kelan-etuudet-ja-saajat">Kelan etuuksien saajat ja etuusmäärät</a></td>
<td>Markus Kainu</td>
</tr>
</tbody>
</table>

Käyttöesimerkkejä: Kelan etuuksien saajat ja etuusmäärät
========================================================

    library(dplyr)
    library(ggplot2)
    library(jsonlite)
    library(ckanr)
    library(readr)
    library(knitr)

Resurssien lataaminen
---------------------

    ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
    resources <- x$results[[1]]$resources
    dat <- read_csv2(resources[[1]]$url) # Lataa data
    meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

Datan ja metadatan kuvailu
--------------------------

**Datan kuvaustieto**

    meta$description %>% cat()

Raportti sisältää kaikki Kelan maksamat keskeisimmät etuudet sekä tiedot
etuuksien saajista, maksetuista etuuksista ja keskimääräiset etuudet
(euroa/saaja). Eräistä etuuksista, esimerkiksi eläkkeet ja asumistuet,
ei ole tietoa vuoden aikana etuutta saaneista eikä keskimääräisistä
etuuksista. Niistä on vain poikkileikkaustiedot kuukausittain.

**Datan muuttujatieto**

    meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th align="left">name</th>
<th align="left">type</th>
<th align="left">format</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">vuosi</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">etuus</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">saajat</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">euroa_saaja</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">kunta</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th align="right">vuosi</th>
<th align="left">etuus</th>
<th align="right">saajat</th>
<th align="right">euroa_saaja</th>
<th align="left">kunta</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="right">2018</td>
<td align="left">Elatustuki</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="left">Akaa</td>
</tr>
<tr class="even">
<td align="right">2018</td>
<td align="left">Eläke-etuudet (pl. takuueläke)</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="left">Akaa</td>
</tr>
<tr class="odd">
<td align="right">2018</td>
<td align="left">Eläketuki</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="left">Akaa</td>
</tr>
<tr class="even">
<td align="right">2018</td>
<td align="left">Eläkkeensaajan asumistuki</td>
<td align="right">NA</td>
<td align="right">NA</td>
<td align="left">Akaa</td>
</tr>
<tr class="odd">
<td align="right">2018</td>
<td align="left">Erityishoitoraha</td>
<td align="right">22</td>
<td align="right">2.380646e+16</td>
<td align="left">Akaa</td>
</tr>
<tr class="even">
<td align="right">2018</td>
<td align="left">Koulumatkatuki</td>
<td align="right">434</td>
<td align="right">7.226750e+16</td>
<td align="left">Akaa</td>
</tr>
</tbody>
</table>

Kuvio
-----

    dat %>% 
      filter(vuosi == 2018,
             etuus == "Lapsilisä") %>% 
      arrange(desc(saajat)) %>% 
      slice(1:20) %>% 
      mutate(kunta = forcats::fct_reorder(kunta, saajat)) %>% 
      ggplot(aes(x = kunta, y = saajat, label = saajat)) + 
      geom_col() + 
      coord_flip() + 
      theme_minimal() +
      geom_text(aes(y = 0), hjust = 0, color = "white") +
      labs(title = "Esimerkkikuvion esimerkkiotsikko")

![](2019-02-18-kelan-etuudet-ja-saajat_files/figure-markdown_strict/kuva1-1.png)

Datastore-api
-------------

Jos et tarvitse koko aineistoa, voit suodattaa siitä osio SQL:llä
käyttäen CKAN:n DataStore-rajapintaa.

Alla olevassa esimerkissä tehdään rajaus `kunta`-muuttujasta ja siis
etsitään vaan kuntaa *Veteli* koskevat tiedot.

    kunta <- "Veteli"
    fromJSON(glue("https://beta.avoindata.fi/data/fi/data/api/3/action/datastore_search_sql?sql=SELECT * from \"{resources[[1]]$id}\" WHERE kunta LIKE '{kunta}'"), TRUE)
