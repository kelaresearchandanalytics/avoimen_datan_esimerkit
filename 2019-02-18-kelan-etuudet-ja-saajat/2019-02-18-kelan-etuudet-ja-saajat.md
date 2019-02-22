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
    library(glue)
    library(hrbrthemes)

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
<colgroup>
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 78%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">name</th>
<th style="text-align: left;">type</th>
<th style="text-align: left;">format</th>
<th style="text-align: left;">title</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">Vuosimuuttuja on kokonaisluku ie. integer</td>
</tr>
<tr class="even">
<td style="text-align: left;">etuus</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">Etuusmuuttuja on string eli tekstiä</td>
</tr>
<tr class="odd">
<td style="text-align: left;">saajat</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">Saajat on yhtä kuin saajien määrä. Se on kokonaisluku eli integer</td>
</tr>
<tr class="even">
<td style="text-align: left;">euroa_saaja</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">euroa_saaja on euromääräinen ja saattaa sisältää desimaaleja. Luokka siksi number eli numeric R:ssä</td>
</tr>
<tr class="odd">
<td style="text-align: left;">kunta</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">Kunta on kunnan nimi suomeksi ja siten tekstiä</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th style="text-align: right;">vuosi</th>
<th style="text-align: left;">etuus</th>
<th style="text-align: right;">saajat</th>
<th style="text-align: right;">euroa_saaja</th>
<th style="text-align: left;">kunta</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Elatustuki</td>
<td style="text-align: right;">NA</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">Akaa</td>
</tr>
<tr class="even">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Eläke-etuudet (pl. takuueläke)</td>
<td style="text-align: right;">NA</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">Akaa</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Eläketuki</td>
<td style="text-align: right;">NA</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">Akaa</td>
</tr>
<tr class="even">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Eläkkeensaajan asumistuki</td>
<td style="text-align: right;">NA</td>
<td style="text-align: right;">NA</td>
<td style="text-align: left;">Akaa</td>
</tr>
<tr class="odd">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Erityishoitoraha</td>
<td style="text-align: right;">22</td>
<td style="text-align: right;">2380.646</td>
<td style="text-align: left;">Akaa</td>
</tr>
<tr class="even">
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Koulumatkatuki</td>
<td style="text-align: right;">434</td>
<td style="text-align: right;">722.675</td>
<td style="text-align: left;">Akaa</td>
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
      labs(title = "Esimerkkikuvion esimerkkiotsikko") +
      theme_ft_rc()

![](2019-02-18-kelan-etuudet-ja-saajat_files/figure-markdown_strict/kuva1-1.png)

Datastore-api
-------------

Jos et tarvitse koko aineistoa, voit suodattaa siitä osio SQL:llä
käyttäen CKAN:n DataStore-rajapintaa.

Alla olevassa esimerkissä tehdään rajaus `kunta`-muuttujasta ja siis
etsitään vaan kuntaa *Veteli* koskevat tiedot.

    kunta <- "Veteli"
    res <- ckanr::ds_search_sql(sql = glue("SELECT * from \"{resources[[1]]$id}\" WHERE kunta LIKE '{kunta}'"), as = "table")
    res$records %>% 
      select(-`_full_text`, -`_id`) %>% 
      kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">saajat</th>
<th style="text-align: left;">vuosi</th>
<th style="text-align: left;">euroa_saaja</th>
<th style="text-align: left;">etuus</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Elatustuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläke-etuudet (pl. takuueläke)</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläketuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläkkeensaajan asumistuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">6</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">720,4217</td>
<td style="text-align: left;">Erityishoitoraha</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">78</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">1169,4550</td>
<td style="text-align: left;">Koulumatkatuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">69</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">4396,6304</td>
<td style="text-align: left;">Kuntoutus</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">15</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">1742,3827</td>
<td style="text-align: left;">Kuntoutusraha</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">286</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">2737,9693</td>
<td style="text-align: left;">Lapsilisä</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">56</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">2688,1236</td>
<td style="text-align: left;">Lastenhoidon tuet</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Opintolainahyvitys</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Opintolainavähennys</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">105</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">3668,8578</td>
<td style="text-align: left;">Opintotuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">10</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">2500,0000</td>
<td style="text-align: left;">Perhevapaakorvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Perustoimeentulotuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">2107</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">569,6079</td>
<td style="text-align: left;">Sairaanhoitokorvaukset</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">188</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">2715,9276</td>
<td style="text-align: left;">Sairauspäivärahat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Sotilasavustus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Takuueläke</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">109</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">5008,3770</td>
<td style="text-align: left;">Työttömyysturva</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Vammaisetuudet</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">68</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">6475,2490</td>
<td style="text-align: left;">Vanhempainpäiväraha</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">13</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">1426,2923</td>
<td style="text-align: left;">Vuosilomakustannuskorvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yleinen asumistuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">18</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">202,3989</td>
<td style="text-align: left;">Äitiysavustus</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Elatustuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläke-etuudet (pl. takuueläke)</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläketuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Eläkkeensaajan asumistuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Erityishoitoraha</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">81</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">991,2342</td>
<td style="text-align: left;">Koulumatkatuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">63</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">3663,2610</td>
<td style="text-align: left;">Kuntoutus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">23</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">872,1291</td>
<td style="text-align: left;">Kuntoutusraha</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">293</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">2745,0531</td>
<td style="text-align: left;">Lapsilisä</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">65</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">2388,8057</td>
<td style="text-align: left;">Lastenhoidon tuet</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Opintolainavähennys</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">112</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">3318,0358</td>
<td style="text-align: left;">Opintotuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">4</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">2500,0000</td>
<td style="text-align: left;">Perhevapaakorvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Perustoimeentulotuki</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">2143</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">581,0930</td>
<td style="text-align: left;">Sairaanhoitokorvaukset</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">181</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">2716,7817</td>
<td style="text-align: left;">Sairauspäivärahat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">7</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">2326,6329</td>
<td style="text-align: left;">Sotilasavustus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Takuueläke</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">122</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">5731,9712</td>
<td style="text-align: left;">Työttömyysturva</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Vammaisetuudet</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">65</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">6983,9569</td>
<td style="text-align: left;">Vanhempainpäiväraha</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">11</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">1250,1909</td>
<td style="text-align: left;">Vuosilomakustannuskorvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yleinen asumistuki</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">28</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">200,2686</td>
<td style="text-align: left;">Äitiysavustus</td>
</tr>
</tbody>
</table>
