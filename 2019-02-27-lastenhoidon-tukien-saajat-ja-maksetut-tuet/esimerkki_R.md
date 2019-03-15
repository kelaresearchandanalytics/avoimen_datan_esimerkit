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
<td style="text-align: left;"><a href='https://beta.avoindata.fi/data/fi/dataset/lastenhoidon-tukien-saajat-ja-maksetut-tuet'>Lastenhoidon tukien saajat ja maksetut tuet</a></td>
<td style="text-align: left;">2019-02-27</td>
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
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:lastenhoidon")
    resources <- x$results[[1]]$resources
    dat <- read_csv2(resources[[1]]$url) # Lataa data
    meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

Datan ja metadatan kuvailu
--------------------------

**Datan kuvaustieto**

    meta$description %>% cat()

Lastenhoidon tukia tilastointiajanjakson aikana saaneet perheet ja
lapset, joista tukia on maksettu, maksetut tuet, keskimääräinen tuki
sekä yksityisen päivähoidon tuottajan perimä hoitomaksu kuukaudessa.
Lakisääteisten tukien lisäksi raportilta saa tiedot kuntien Kelan kautta
maksamista kuntalisistä. Aluetiedot voi valita raportille joko tuen
saajan asuinkunnan tai tuen maksaneen kunnan mukaan.Lastenhoidon tuilla
tarkoitetaan taloudellista tukea lasten hoidon järjestämiseksi.
Tukimuotoja ovat kotihoidon tuki, yksityisen hoidon tuki, osittainen
hoitoraha ja joustava hoitoraha.

**Datan muuttujatieto**

    meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

<table>
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
<td style="text-align: left;">kunta</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tukien_sisalto</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">tukimuoto</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">saajat</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">lapset</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">maksetut_etuudet_euroa</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">tuki_per_saaja_e_kk</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">tuki_per_lapsi_e_kk</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="even">
<td style="text-align: left;">hoitomaksu_per_saaja_e_kk</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
<tr class="odd">
<td style="text-align: left;">hoitomaksu_per_lapsi_e_kk</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
<td style="text-align: left;">kuvaus</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table>
<colgroup>
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 12%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 14%" />
<col style="width: 14%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: right;">vuosi</th>
<th style="text-align: left;">tukien_sisalto</th>
<th style="text-align: left;">tukimuoto</th>
<th style="text-align: right;">saajat</th>
<th style="text-align: right;">lapset</th>
<th style="text-align: right;">maksetut_etuudet_euroa</th>
<th style="text-align: right;">tuki_per_saaja_e_kk</th>
<th style="text-align: right;">tuki_per_lapsi_e_kk</th>
<th style="text-align: right;">hoitomaksu_per_saaja_e_kk</th>
<th style="text-align: right;">hoitomaksu_per_lapsi_e_kk</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: right;">355</td>
<td style="text-align: right;">462</td>
<td style="text-align: right;">805236.55</td>
<td style="text-align: right;">312.1573</td>
<td style="text-align: right;">251.4208</td>
<td style="text-align: right;">489.5714</td>
<td style="text-align: right;">428.3750</td>
</tr>
<tr class="even">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: right;">264</td>
<td style="text-align: right;">365</td>
<td style="text-align: right;">686767.42</td>
<td style="text-align: right;">401.0870</td>
<td style="text-align: right;">297.5806</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: right;">20</td>
<td style="text-align: right;">26</td>
<td style="text-align: right;">31247.01</td>
<td style="text-align: right;">189.7857</td>
<td style="text-align: right;">166.0625</td>
<td style="text-align: right;">489.5714</td>
<td style="text-align: right;">428.3750</td>
</tr>
<tr class="even">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: right;">56</td>
<td style="text-align: right;">57</td>
<td style="text-align: right;">33290.33</td>
<td style="text-align: right;">96.9032</td>
<td style="text-align: right;">96.9032</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2018</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: right;">50</td>
<td style="text-align: right;">49</td>
<td style="text-align: right;">53931.79</td>
<td style="text-align: right;">188.9500</td>
<td style="text-align: right;">188.9500</td>
<td style="text-align: right;">0.0000</td>
<td style="text-align: right;">0.0000</td>
</tr>
<tr class="even">
<td style="text-align: left;">Akaa</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: right;">396</td>
<td style="text-align: right;">513</td>
<td style="text-align: right;">924225.26</td>
<td style="text-align: right;">338.6630</td>
<td style="text-align: right;">258.5643</td>
<td style="text-align: right;">511.0000</td>
<td style="text-align: right;">397.4444</td>
</tr>
</tbody>
</table>

Kuvio
-----

    dat %>% 
      filter(vuosi == 2018,
             tukimuoto == "Kotihoidon tuki") %>% 
      arrange(desc(tuki_per_saaja_e_kk)) %>% 
      slice(1:20) %>% 
      mutate(kunta = forcats::fct_reorder(kunta, tuki_per_saaja_e_kk)) %>% 
      ggplot(aes(x = kunta, y = tuki_per_saaja_e_kk, label = round(tuki_per_saaja_e_kk,1))) + 
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
<col style="width: 3%" />
<col style="width: 3%" />
<col style="width: 12%" />
<col style="width: 3%" />
<col style="width: 14%" />
<col style="width: 10%" />
<col style="width: 14%" />
<col style="width: 10%" />
<col style="width: 10%" />
<col style="width: 12%" />
<col style="width: 3%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">saajat</th>
<th style="text-align: left;">tukimuoto</th>
<th style="text-align: left;">vuosi</th>
<th style="text-align: left;">hoitomaksu_per_lapsi_e_kk</th>
<th style="text-align: left;">tukien_sisalto</th>
<th style="text-align: left;">hoitomaksu_per_saaja_e_kk</th>
<th style="text-align: left;">tuki_per_lapsi_e_kk</th>
<th style="text-align: left;">tuki_per_saaja_e_kk</th>
<th style="text-align: left;">maksetut_etuudet_euroa</th>
<th style="text-align: left;">lapset</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">56</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">390,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">390,0000</td>
<td style="text-align: left;">224,5000</td>
<td style="text-align: left;">374,1667</td>
<td style="text-align: left;">150534,92</td>
<td style="text-align: left;">95</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">47</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">227,0698</td>
<td style="text-align: left;">443,8182</td>
<td style="text-align: left;">139619,70</td>
<td style="text-align: left;">87</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">8</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">121,0000</td>
<td style="text-align: left;">96,8000</td>
<td style="text-align: left;">5274,69</td>
<td style="text-align: left;">7</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">4</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: left;">2018</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">201,0000</td>
<td style="text-align: left;">201,0000</td>
<td style="text-align: left;">4434,78</td>
<td style="text-align: left;">4</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">65</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">248,9189</td>
<td style="text-align: left;">383,7500</td>
<td style="text-align: left;">155272,37</td>
<td style="text-align: left;">103</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">54</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">262,3529</td>
<td style="text-align: left;">424,7619</td>
<td style="text-align: left;">142743,52</td>
<td style="text-align: left;">93</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">6</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">97,0000</td>
<td style="text-align: left;">97,0000</td>
<td style="text-align: left;">4976,03</td>
<td style="text-align: left;">5</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">6</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">4909,89</td>
<td style="text-align: left;">5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">64</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">350,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">700,0000</td>
<td style="text-align: left;">239,4576</td>
<td style="text-align: left;">381,8378</td>
<td style="text-align: left;">200385,10</td>
<td style="text-align: left;">118</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">58</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">244,3846</td>
<td style="text-align: left;">409,9355</td>
<td style="text-align: left;">181036,46</td>
<td style="text-align: left;">111</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">9</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">182,5000</td>
<td style="text-align: left;">182,5000</td>
<td style="text-align: left;">12402,20</td>
<td style="text-align: left;">10</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">71</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">225,8448</td>
<td style="text-align: left;">374,2571</td>
<td style="text-align: left;">177698,44</td>
<td style="text-align: left;">131</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">61</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">230,2600</td>
<td style="text-align: left;">411,1786</td>
<td style="text-align: left;">159095,34</td>
<td style="text-align: left;">121</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">8</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">98,0000</td>
<td style="text-align: left;">98,0000</td>
<td style="text-align: left;">2944,66</td>
<td style="text-align: left;">7</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">10</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">189,8333</td>
<td style="text-align: left;">189,8333</td>
<td style="text-align: left;">11473,32</td>
<td style="text-align: left;">9</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">80</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">231,5714</td>
<td style="text-align: left;">385,9524</td>
<td style="text-align: left;">215483,56</td>
<td style="text-align: left;">139</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">72</td>
<td style="text-align: left;">Kotihoidon tuki</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">233,6563</td>
<td style="text-align: left;">404,1622</td>
<td style="text-align: left;">204291,25</td>
<td style="text-align: left;">131</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yksityisen hoidon tuki</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">5</td>
<td style="text-align: left;">Osittainen hoitoraha</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">98,0000</td>
<td style="text-align: left;">98,0000</td>
<td style="text-align: left;">2512,07</td>
<td style="text-align: left;">5</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">8</td>
<td style="text-align: left;">Joustava hoitoraha</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">0,0000</td>
<td style="text-align: left;">202,5000</td>
<td style="text-align: left;">202,5000</td>
<td style="text-align: left;">6554,89</td>
<td style="text-align: left;">8</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Lakisääteiset tuet</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">NA</td>
</tr>
</tbody>
</table>
