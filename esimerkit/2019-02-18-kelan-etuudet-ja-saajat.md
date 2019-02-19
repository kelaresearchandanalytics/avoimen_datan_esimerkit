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
    resources[[1]]$name

    ## [1] "Kelan etuudet ja saajat"

    resources[[2]]$name

    ## [1] "Metadata"

    dat <- readr::read_csv2(resources[[1]]$url)
    meta <- fromJSON(txt = resources[[2]]$url)

Datan ja metadatan kuvailu
==========================

    meta$profile

    ## [1] "data-package"

    meta$name

    ## [1] "Kelan etuudet ja saajat"

    meta$title

    ## [1] "Kelan etuuksien saajat ja etuusmäärät"

    meta$description

    ## [1] "Raportti sisältää kaikki Kelan maksamat keskeisimmät etuudet sekä tiedot etuuksien saajista, maksetuista etuuksista ja keskimääräiset etuudet (euroa/saaja).\nEräistä etuuksista, esimerkiksi eläkkeet ja asumistuet, ei ole tietoa vuoden aikana etuutta saaneista eikä keskimääräisistä etuuksista. Niistä on vain poikkileikkaustiedot kuukausittain.\n"

    # Datan muuttujatieto
    meta$resources$schema$fields[[1]]

    ##          name    type  format
    ## 1       vuosi integer default
    ## 2       etuus  string default
    ## 3      saajat  string default
    ## 4 euroa_saaja  string default
    ## 5       kunta  string default

    # Datan ensimmäiset rivit 
    head(dat)

    ## # A tibble: 6 x 5
    ##   vuosi etuus                          saajat euroa_saaja kunta
    ##   <dbl> <chr>                           <dbl>       <dbl> <chr>
    ## 1  2018 Elatustuki                         NA    NA       Akaa 
    ## 2  2018 Eläke-etuudet (pl. takuueläke)     NA    NA       Akaa 
    ## 3  2018 Eläketuki                          NA    NA       Akaa 
    ## 4  2018 Eläkkeensaajan asumistuki          NA    NA       Akaa 
    ## 5  2018 Erityishoitoraha                   22     2.38e16 Akaa 
    ## 6  2018 Koulumatkatuki                    434     7.23e16 Akaa

Kuvio1
======

    library(ggplot2)
    dat %>% 
      filter(vuosi == 2018,
             etuus == "Lapsilisä") %>% 
      arrange(desc(saajat)) %>% 
      slice(1:20) %>% 
      mutate(kunta = forcats::fct_reorder(kunta, saajat)) %>% 
      ggplot(aes(x = kunta, y = saajat, label = saajat)) + geom_col() + coord_flip() + theme_minimal() +
      geom_text(aes(y = 0), hjust = 0, color = "white")

![](/home/e275ceo/tekno/avoindata/avoimen_datan_kayttoesimerkit/esimerkit/2019-02-18-kelan-etuudet-ja-saajat_files/figure-markdown_strict/kuva1-1.png)
