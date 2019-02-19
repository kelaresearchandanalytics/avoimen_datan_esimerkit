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

    library(tidyverse)
    library(jsonlite)
    library(ckanr)

Datan ja metadatan lataaminen
=============================

    ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:etuuksien")
    resources <- x$results[[1]]$resources
    # resources[[1]]$name
    # resources[[2]]$name

    dat <- readr::read_csv2(resources[[1]]$url)
    meta <- fromJSON(txt = resources[[2]]$url)

Datan ja metadatan kuvailu
==========================

    # Datan muuttujatieto
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

    # Datan ensimmäiset rivit 
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
=====

    library(ggplot2)
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
