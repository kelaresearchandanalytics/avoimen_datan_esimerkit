<table style="width:38%;">
<colgroup>
<col width="13%" />
<col width="11%" />
<col width="12%" />
</colgroup>
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
<td><a href="https://beta.avoindata.fi/data/fi/dataset/kelan-yleisen-asumistuen-saajat">Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot</a></td>
<td>Markus Kainu</td>
</tr>
</tbody>
</table>

Käyttöesimerkkejä: Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot
=============================================================================================================

    # CRAN-paketit
    library(dplyr)
    library(ggplot2)
    library(jsonlite)
    library(ckanr)
    library(readr)
    library(knitr)
    library(glue)

Resurssien lataaminen
---------------------

    ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:yleisen")
    resources <- x$results[[1]]$resources

    dat <- readr::read_csv2(resources[[1]]$url) # data
    meta <- fromJSON(txt = resources[[2]]$url) # metadata

Resurssien kuvailu
==================

**Datan kuvaustieto**

    meta$description %>% cat()

Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja
ruokakunnan tulot. Cras neque odio, sollicitudin a porttitor id,
convallis ut nibh. Suspendisse vel purus nibh. Cras finibus dolor eu
justo vehicula dapibus. Mauris egestas finibus velit eget mattis.
Suspendisse sem nunc, vulputate eu lectus vitae, iaculis tempor augue.
Curabitur placerat risus magna, at mattis magna pharetra id. Etiam
ornare enim non sem suscipit egestas.

**Datan muuttujatieto**

    meta$resources$schema$fields[[1]] %>% kable(format = "markdown")

<table>
<colgroup>
<col width="40%" />
<col width="40%" />
<col width="9%" />
<col width="9%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">name</th>
<th align="left">title</th>
<th align="left">type</th>
<th align="left">format</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">kunta</td>
<td align="left">Kunnan nimi suomeksi</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">vuosi</td>
<td align="left">vuosi</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">ruokakuntatyyppi</td>
<td align="left">Ruokakuntatyyppi</td>
<td align="left">string</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">saajaruokakunnat</td>
<td align="left">Saajaruokakunnat</td>
<td align="left">number</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">asumistuki_keskim_euroa_kk</td>
<td align="left">Keskimääräinen asumistuki e/kk</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">asumismenot_keskim_euroa_kk</td>
<td align="left">Keskim. asumismenot e/kk</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">asumistukitulo_keskim_euroa_kk</td>
<td align="left">Keskim. asumistukitulo e/kk</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">asumismenot_ennen_asumistukea_pros</td>
<td align="left">Asumismenot ennen asumistukea %</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">asumismenot_asumistuen_jalkeen_pros</td>
<td align="left">Asumismenot asumistuen jälkeen %</td>
<td align="left">integer</td>
<td align="left">default</td>
</tr>
<tr class="even">
<td align="left">asumismenot_keskim_e_m2_kk</td>
<td align="left">Keskim. asumismenot e/m2/kk</td>
<td align="left">number</td>
<td align="left">default</td>
</tr>
<tr class="odd">
<td align="left">asunnon_keskim_pintaala_m2_asunto</td>
<td align="left">Asunnon keskim. pinta-ala m2/asunto</td>
<td align="left">number</td>
<td align="left">default</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat) %>% kable(format = "markdown")

<table>
<colgroup>
<col width="2%" />
<col width="2%" />
<col width="9%" />
<col width="6%" />
<col width="9%" />
<col width="10%" />
<col width="11%" />
<col width="12%" />
<col width="13%" />
<col width="9%" />
<col width="12%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">kunta</th>
<th align="right">vuosi</th>
<th align="left">ruokakuntatyyppi</th>
<th align="right">saajaruokakunnat</th>
<th align="right">asumistuki_keskim_euroa_kk</th>
<th align="right">asumismenot_keskim_euroa_kk</th>
<th align="right">asumistukitulo_keskim_euroa_kk</th>
<th align="right">asumismenot_ennen_asumistukea_pros</th>
<th align="right">asumismenot_asumistuen_jalkeen_pros</th>
<th align="right">asumismenot_keskim_e_m2_kk</th>
<th align="right">asunnon_keskim_pintaala_m2_asunto</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Yhteensä</td>
<td align="right">60400</td>
<td align="right">2796358</td>
<td align="right">5415889</td>
<td align="right">9667248</td>
<td align="right">56023</td>
<td align="right">27097</td>
<td align="right">91049</td>
<td align="right">59483</td>
</tr>
<tr class="even">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Yksin asuvat</td>
<td align="right">37900</td>
<td align="right">2337341</td>
<td align="right">4500426</td>
<td align="right">6716300</td>
<td align="right">67008</td>
<td align="right">32207</td>
<td align="right">94712</td>
<td align="right">47517</td>
</tr>
<tr class="odd">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Lapsettomat parit</td>
<td align="right">2700</td>
<td align="right">2688667</td>
<td align="right">6000330</td>
<td align="right">12090970</td>
<td align="right">49627</td>
<td align="right">27390</td>
<td align="right">95468</td>
<td align="right">62852</td>
</tr>
<tr class="even">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Lapsiperheet yhteensä</td>
<td align="right">18400</td>
<td align="right">3784205</td>
<td align="right">7194155</td>
<td align="right">15167695</td>
<td align="right">47431</td>
<td align="right">22482</td>
<td align="right">86399</td>
<td align="right">83266</td>
</tr>
<tr class="odd">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Kahden huoltajan perheet</td>
<td align="right">3800</td>
<td align="right">3875579</td>
<td align="right">8512903</td>
<td align="right">23076629</td>
<td align="right">36890</td>
<td align="right">20095</td>
<td align="right">87905</td>
<td align="right">96842</td>
</tr>
<tr class="even">
<td align="left">Akaa</td>
<td align="right">2018</td>
<td align="left">Yhden huoltajan perheet</td>
<td align="right">14600</td>
<td align="right">3760423</td>
<td align="right">6850919</td>
<td align="right">13109205</td>
<td align="right">52260</td>
<td align="right">23575</td>
<td align="right">85916</td>
<td align="right">79740</td>
</tr>
</tbody>
</table>

Kuvio
-----

    # valitaan ensin top 10 kuntaa, joissa korkeimmat keskimääräiset asumistukimenot
    dat %>% 
      filter(ruokakuntatyyppi == "Yhteensä",
             vuosi == 2018) %>% 
      arrange(desc(asumistuki_keskim_euroa_kk)) %>% 
      slice(1:10) %>% pull(kunta) -> kunnat

    # Piirretään kuva
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
      labs(title = "Esimerkkikuvion esimerkkiotsikko")

![](2019-02-19-kelan-yleisen-asumistuen-saajat_files/figure-markdown_strict/kuva1-1.png)

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
<col width="2%" />
<col width="10%" />
<col width="9%" />
<col width="2%" />
<col width="12%" />
<col width="12%" />
<col width="6%" />
<col width="11%" />
<col width="13%" />
<col width="9%" />
<col width="9%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">kunta</th>
<th align="left">asumismenot_keskim_euroa_kk</th>
<th align="left">asumismenot_keskim_e_m2_kk</th>
<th align="left">vuosi</th>
<th align="left">asunnon_keskim_pintaala_m2_asunto</th>
<th align="left">asumismenot_ennen_asumistukea_pros</th>
<th align="left">saajaruokakunnat</th>
<th align="left">asumistukitulo_keskim_euroa_kk</th>
<th align="left">asumismenot_asumistuen_jalkeen_pros</th>
<th align="left">ruokakuntatyyppi</th>
<th align="left">asumistuki_keskim_euroa_kk</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">439.4826</td>
<td align="left">6.6979</td>
<td align="left">2018</td>
<td align="left">65.615</td>
<td align="left">51.289</td>
<td align="left">39.00</td>
<td align="left">856.8792</td>
<td align="left">19.228</td>
<td align="left">Yhteensä</td>
<td align="left">274.7210</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">350.3112</td>
<td align="left">6.3167</td>
<td align="left">2018</td>
<td align="left">55.458</td>
<td align="left">49.534</td>
<td align="left">24.00</td>
<td align="left">707.2175</td>
<td align="left">20.689</td>
<td align="left">Yksin asuvat</td>
<td align="left">203.9958</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2018</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Lapsettomat parit</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">608.5755</td>
<td align="left">7.0171</td>
<td align="left">2018</td>
<td align="left">86.727</td>
<td align="left">45.060</td>
<td align="left">11.00</td>
<td align="left">1350.5882</td>
<td align="left">13.315</td>
<td align="left">Lapsiperheet yhteensä</td>
<td align="left">428.7482</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2018</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Kahden huoltajan perheet</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">549.8144</td>
<td align="left">6.9304</td>
<td align="left">2018</td>
<td align="left">79.333</td>
<td align="left">41.518</td>
<td align="left">9.00</td>
<td align="left">1324.2844</td>
<td align="left">13.123</td>
<td align="left">Yhden huoltajan perheet</td>
<td align="left">376.0311</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2018</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Muut</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">447.9392</td>
<td align="left">6.8914</td>
<td align="left">2017</td>
<td align="left">65.000</td>
<td align="left">42.946</td>
<td align="left">52.00</td>
<td align="left">1043.0344</td>
<td align="left">18.799</td>
<td align="left">Yhteensä</td>
<td align="left">251.8548</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">357.3679</td>
<td align="left">6.3775</td>
<td align="left">2017</td>
<td align="left">56.036</td>
<td align="left">51.577</td>
<td align="left">28.00</td>
<td align="left">692.8789</td>
<td align="left">22.537</td>
<td align="left">Yksin asuvat</td>
<td align="left">201.2125</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2017</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Lapsettomat parit</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">583.4906</td>
<td align="left">7.3704</td>
<td align="left">2017</td>
<td align="left">79.167</td>
<td align="left">37.411</td>
<td align="left">18.00</td>
<td align="left">1559.6767</td>
<td align="left">15.456</td>
<td align="left">Lapsiperheet yhteensä</td>
<td align="left">342.4228</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">716.1500</td>
<td align="left">7.5384</td>
<td align="left">2017</td>
<td align="left">95.000</td>
<td align="left">41.960</td>
<td align="left">6.00</td>
<td align="left">1706.7617</td>
<td align="left">16.536</td>
<td align="left">Kahden huoltajan perheet</td>
<td align="left">433.9167</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">517.1608</td>
<td align="left">7.2499</td>
<td align="left">2017</td>
<td align="left">71.333</td>
<td align="left">34.799</td>
<td align="left">12.00</td>
<td align="left">1486.1342</td>
<td align="left">14.836</td>
<td align="left">Yhden huoltajan perheet</td>
<td align="left">296.6758</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2017</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Muut</td>
<td align="left">NA</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">423.4747</td>
<td align="left">6.4390</td>
<td align="left">2016</td>
<td align="left">65.767</td>
<td align="left">35.753</td>
<td align="left">43.00</td>
<td align="left">1184.4426</td>
<td align="left">16.060</td>
<td align="left">Yhteensä</td>
<td align="left">233.2491</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">334.7079</td>
<td align="left">5.8721</td>
<td align="left">2016</td>
<td align="left">57.000</td>
<td align="left">44.965</td>
<td align="left">19.00</td>
<td align="left">744.3674</td>
<td align="left">18.686</td>
<td align="left">Yksin asuvat</td>
<td align="left">195.6126</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">2016</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">NA</td>
<td align="left">Lapsettomat parit</td>
<td align="left">NA</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">529.8811</td>
<td align="left">6.8302</td>
<td align="left">2016</td>
<td align="left">77.579</td>
<td align="left">31.234</td>
<td align="left">19.00</td>
<td align="left">1696.4737</td>
<td align="left">14.563</td>
<td align="left">Lapsiperheet yhteensä</td>
<td align="left">282.8316</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">558.7633</td>
<td align="left">6.7456</td>
<td align="left">2016</td>
<td align="left">82.833</td>
<td align="left">35.754</td>
<td align="left">6.00</td>
<td align="left">1562.7967</td>
<td align="left">16.514</td>
<td align="left">Kahden huoltajan perheet</td>
<td align="left">300.6833</td>
</tr>
<tr class="even">
<td align="left">Veteli</td>
<td align="left">516.5508</td>
<td align="left">6.8732</td>
<td align="left">2016</td>
<td align="left">75.154</td>
<td align="left">29.380</td>
<td align="left">13.00</td>
<td align="left">1758.1708</td>
<td align="left">13.762</td>
<td align="left">Yhden huoltajan perheet</td>
<td align="left">274.5923</td>
</tr>
<tr class="odd">
<td align="left">Veteli</td>
<td align="left">331.5550</td>
<td align="left">6.2558</td>
<td align="left">2016</td>
<td align="left">53.000</td>
<td align="left">42.310</td>
<td align="left">4.00</td>
<td align="left">783.6325</td>
<td align="left">17.530</td>
<td align="left">Muut</td>
<td align="left">194.1850</td>
</tr>
</tbody>
</table>
