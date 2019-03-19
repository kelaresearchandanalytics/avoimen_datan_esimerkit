<table>
<thead>
<tr class="header">
<th style="text-align: left;">data</th>
<th style="text-align: left;">julkaistu</th>
<th style="text-align: left;">ylläpitäjä</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;"><a href='https://beta.avoindata.fi/data/fi/dataset/suomen-elakkeensaajat-ja-keskimaaraiset-elakkeet'>Suomen eläkkeensaajat ja keskimääräiset eläkkeet</a></td>
<td style="text-align: left;">2019-03-19</td>
<td style="text-align: left;"><a href='mailto:markus.kainu@kela.fi'>Markus Kainu</a></td>
</tr>
</tbody>
</table>

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
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:eläkkeensaajat")
    resources <- x$results[[1]]$resources
    dat <- read_csv2(resources[[1]]$url) # Lataa data
    meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

Datan ja metadatan kuvailu
--------------------------

**Datan kuvaustieto**

    meta$description %>% cat()

Suomen eläketurva koostuu pääpiirteissään kahdesta lakisääteisestä
eläkejärjestelmästä, kansaneläkejärjestelmästä ja
työeläkejärjestelmästä. Lakisääteistä eläketurvaa ovat myös liikenne- ja
tapaturmavakuutuslakien sekä sotilasvamma- ja sotilastapaturmalakien
mukaiset eläkkeet, ns. SOLITA-eläkkeet. Tämä raportti sisältää tietoja
kansan- ja/tai työeläkejärjestelmän eläkkeensaajien lukumäärästä ja
keskimääräisistä kokonaiseläkkeistä. Mukana ovat myös ulkomaille
maksetut eläkkeet. Lakisääteisen eläketurvan osalta raportti on lähes
tyhjentävä, vain pelkkää SOLITA-eläkettä saavat henkilöt ja heidän
eläkkeensä eivät ole mukana. Vapaaehtoisesta eläketurvasta on mukana
vain työnantajan kustantama rekisteröity lisäeläketurva. Eri eläkelajeja
ei voi summata yhteen, sillä henkilö voi saada samanaikaisesti eläkettä
sekä kansan- että työeläkejärjestelmästä. Kelasta hänellä ei voi olla
yhtä aikaa eri eläkelajien mukaista eläkettä, mutta työeläkkeenä hän voi
saada samanaikaisesti sekä usean eläkelain että usean eläkelajin
mukaista eläkettä. Kokonaiseläke voi koostua Kelan eläkkeestä ja
työeläkkeestä sekä niihin liittyvistä SOLITA-eläkkeistä,
lapsikorotuksista, rintamalisästä ja ylimääräisestä rintamalisästä sekä
vuoteen 2007 saakka eläkkeensaajien asumistuesta ja hoitotuesta.

**Datan muuttujatieto**

    meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th style="text-align: left;">name</th>
<th style="text-align: left;">type</th>
<th style="text-align: left;">format</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">kuntanumero</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">kunta</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">elakelaji</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">sukupuoli</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">ikaryhma</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">elakejarjestelma</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">asuinmaa</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">saajat</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">keskimaarainen_kokonaiselake_e_kk</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table>
<colgroup>
<col style="width: 9%" />
<col style="width: 7%" />
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 7%" />
<col style="width: 6%" />
<col style="width: 17%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: right;">kuntanumero</th>
<th style="text-align: left;">kunta</th>
<th style="text-align: right;">vuosi</th>
<th style="text-align: left;">elakelaji</th>
<th style="text-align: left;">sukupuoli</th>
<th style="text-align: left;">ikaryhma</th>
<th style="text-align: left;">elakejarjestelma</th>
<th style="text-align: left;">asuinmaa</th>
<th style="text-align: right;">saajat</th>
<th style="text-align: right;">keskimaarainen_kokonaiselake_e_kk</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">3463</td>
<td style="text-align: right;">1253.347</td>
</tr>
<tr class="even">
<td style="text-align: right;">9</td>
<td style="text-align: left;">Alavieska</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">812</td>
<td style="text-align: right;">1263.518</td>
</tr>
<tr class="odd">
<td style="text-align: right;">10</td>
<td style="text-align: left;">Alavus</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">4116</td>
<td style="text-align: right;">1292.210</td>
</tr>
<tr class="even">
<td style="text-align: right;">16</td>
<td style="text-align: left;">Asikkala</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">3223</td>
<td style="text-align: right;">1528.110</td>
</tr>
<tr class="odd">
<td style="text-align: right;">18</td>
<td style="text-align: left;">Askola</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">1209</td>
<td style="text-align: right;">1533.034</td>
</tr>
<tr class="even">
<td style="text-align: right;">19</td>
<td style="text-align: left;">Aura</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">966</td>
<td style="text-align: right;">1454.336</td>
</tr>
</tbody>
</table>

Kuvio
-----

    dat %>% 
      filter(vuosi == 2017,
             elakelaji == "Yhteensä",
             sukupuoli == "Yhteensä",
             ikaryhma == "Yhteensä",
             elakejarjestelma == "Kaikki eläkkeen saajat",
             asuinmaa == "Suomi") %>% 
      arrange(desc(keskimaarainen_kokonaiselake_e_kk)) %>% 
      slice(1:20) %>% 
      mutate(kunta = forcats::fct_reorder(kunta, keskimaarainen_kokonaiselake_e_kk)) %>% 
      ggplot(aes(x = kunta, y = keskimaarainen_kokonaiselake_e_kk, label = keskimaarainen_kokonaiselake_e_kk)) + 
      geom_col() + 
      coord_flip() + 
      theme_minimal() +
      geom_text(aes(y = 0), hjust = 0, color = "white") +
      labs(title = "Esimerkkikuvion esimerkkiotsikko") +
      theme_ft_rc()

![](esimerkki_R_files/figure-markdown_strict/kuva1-1.png)

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
<colgroup>
<col style="width: 4%" />
<col style="width: 7%" />
<col style="width: 4%" />
<col style="width: 6%" />
<col style="width: 3%" />
<col style="width: 29%" />
<col style="width: 5%" />
<col style="width: 20%" />
<col style="width: 5%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">kuntanumero</th>
<th style="text-align: left;">saajat</th>
<th style="text-align: left;">sukupuoli</th>
<th style="text-align: left;">vuosi</th>
<th style="text-align: left;">elakelaji</th>
<th style="text-align: left;">ikaryhma</th>
<th style="text-align: left;">keskimaarainen_kokonaiselake_e_kk</th>
<th style="text-align: left;">asuinmaa</th>
<th style="text-align: left;">elakejarjestelma</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1155</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1261,4278</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1127</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Omaeläkkeet (kaikki)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1282,2545</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1118</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Omaeläkkeet (pl. osa-aikaeläkkeet)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1287,4961</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">4</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Osa-aikaeläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">662,6075</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1120</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Vanhuus-, työkyvyttömyys- ja työttömyyseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1284,6775</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">989</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">–Vanhuuseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1314,4711</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">141</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">–Työkyvyttömyyseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1063,5766</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">20</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Maatalouden erityiseläke</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1160,0215</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">225</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Perhe-eläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1192,3572</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">215</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Leskeneläke</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1231,4514</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">10</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">-Lapseneläke</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">351,8320</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1135</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1240,7380</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1103</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Omaeläkkeet (kaikki)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1265,6481</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1098</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">-Omaeläkkeet (pl. osa-aikaeläkkeet)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1268,4329</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">5</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">-Osa-aikaeläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">654,1220</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1094</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">-Vanhuus-, työkyvyttömyys- ja työttömyyseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1268,8667</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">956</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">–Vanhuuseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1298,7915</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">150</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">–Työkyvyttömyyseläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1074,2189</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">22</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">-Maatalouden erityiseläke</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1146,4827</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">230</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Perhe-eläkkeet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1172,2555</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">216</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">-Leskeneläke</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">1228,0493</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
</tbody>
</table>
