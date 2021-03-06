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
<td style="text-align: left;"><a href='https://www.betaavoindata.fi/data/fi/dataset/suomen-elakkeensaajat-ja-keskimaaraiset-elakkeet'>Suomen eläkkeensaajat ja keskimääräiset eläkkeet</a></td>
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
    library(pxweb)
    library(tidyr)

Resurssien lataaminen
---------------------

    ckanr_setup(url = "https://www.betaavoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:eläkkeensaajat")
    resources <- x$results[[1]]$resources
    dat <- read.table(resources[[1]]$url, header = TRUE, sep = ";", dec = ",", stringsAsFactors = FALSE) # Lataa data
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

    meta$resources$schema$fields[[1]] %>%
      select(-values) %>% 
      kable(format = "markdown")

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
<td style="text-align: left;">aikajakso</td>
<td style="text-align: left;">string</td>
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
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">keskimaarainen_kokonaiselake_e_kk</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">kuukausi</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table style="width:100%;">
<colgroup>
<col style="width: 8%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 6%" />
<col style="width: 15%" />
<col style="width: 6%" />
<col style="width: 4%" />
<col style="width: 22%" />
<col style="width: 4%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: right;">kuntanumero</th>
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">aikajakso</th>
<th style="text-align: left;">elakelaji</th>
<th style="text-align: left;">sukupuoli</th>
<th style="text-align: left;">ikaryhma</th>
<th style="text-align: left;">elakejarjestelma</th>
<th style="text-align: left;">asuinmaa</th>
<th style="text-align: right;">saajat</th>
<th style="text-align: right;">keskimaarainen_kokonaiselake_e_kk</th>
<th style="text-align: right;">vuosi</th>
<th style="text-align: left;">kuukausi</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">3177</td>
<td style="text-align: right;">821.59</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: right;">9</td>
<td style="text-align: left;">Alavieska</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">781</td>
<td style="text-align: right;">816.81</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: right;">10</td>
<td style="text-align: left;">Alavus</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">3823</td>
<td style="text-align: right;">865.13</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: right;">16</td>
<td style="text-align: left;">Asikkala</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">2580</td>
<td style="text-align: right;">975.58</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="odd">
<td style="text-align: right;">18</td>
<td style="text-align: left;">Askola</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">964</td>
<td style="text-align: right;">908.87</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
<tr class="even">
<td style="text-align: right;">19</td>
<td style="text-align: left;">Aura</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: right;">753</td>
<td style="text-align: right;">925.15</td>
<td style="text-align: right;">2003</td>
<td style="text-align: left;">NA</td>
</tr>
</tbody>
</table>

Kuvio
-----

    dat %>% 
      filter(aikajakso == "vuosi", 
             vuosi == "2017",
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
      labs(title = "Esimerkkikuvion esimerkkiotsikko")

![](esimerkki_R_files/figure-markdown_strict/kuva1-1.png)

Datan yhdistäminen Tilastokeskuksen kuntien avainlukuihin
---------------------------------------------------------

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
             vuosi == "2017",
             elakelaji == "Yhteensä",
             sukupuoli == "Yhteensä",
             ikaryhma == "Yhteensä",
             elakejarjestelma == "Kaikki eläkkeen saajat",
             asuinmaa == "Suomi")

    ggplot(df2, aes(x = `Yli 64-vuotiaiden osuus väestöstä, %, 2018`, 
                    y = keskimaarainen_kokonaiselake_e_kk, 
                    size = `Väkiluku, 2018`)) + 
      geom_point(alpha = .3) +
      labs(y = "keskimaarainen_kokonaiselake_e_kk") + 
      theme_light()

![](esimerkki_R_files/figure-markdown_strict/join-1.png)

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
<col style="width: 3%" />
<col style="width: 7%" />
<col style="width: 4%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 20%" />
<col style="width: 5%" />
<col style="width: 19%" />
<col style="width: 5%" />
<col style="width: 13%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">vuosi</th>
<th style="text-align: left;">kuntanumero</th>
<th style="text-align: left;">saajat</th>
<th style="text-align: left;">sukupuoli</th>
<th style="text-align: left;">asuinmaa</th>
<th style="text-align: left;">kuukausi</th>
<th style="text-align: left;">elakelaji</th>
<th style="text-align: left;">ikaryhma</th>
<th style="text-align: left;">keskimaarainen_kokonaiselake_e_kk</th>
<th style="text-align: left;">aikajakso</th>
<th style="text-align: left;">elakejarjestelma</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">2003</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1066</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">842,04</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">2003</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1029</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Omaeläkkeet (kaikki)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">857,68</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">2003</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">1019</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">Suomi</td>
<td style="text-align: left;">NA</td>
<td style="text-align: left;">Omaeläkkeet (pl. osa-aikaeläkkeet)</td>
<td style="text-align: left;">Yhteensä</td>
<td style="text-align: left;">861,56</td>
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">Kaikki eläkkeen saajat</td>
</tr>
</tbody>
</table>
