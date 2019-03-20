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
<td style="text-align: left;"><a href='https://beta.avoindata.fi/data/fi/dataset/terveyspuntarin-sairastavuusindeksi'>Terveyspuntarin sairastavuusindeksi</a></td>
<td style="text-align: left;">2019-03-15</td>
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

    ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:terveyspuntari")
    resources <- x$results[[1]]$resources
    dat <- read_csv2(resources[[1]]$url) # Lataa data
    meta <- fromJSON(txt = resources[[2]]$url) # Lataa metadata

Datan ja metadatan kuvailu
--------------------------

**Datan kuvaustieto**

    meta$description %>% cat()

Jokaiselle Suomen kunnalle lasketun indeksin avulla pyritään
havainnollistamaan sitä, miten tervettä tai sairasta alueen väestö on
suhteessa koko maan väestön keskiarvoon (= 100). Indeksi ilmoitetaan
sekä sellaisenaan että ikä- ja sukupuolivakioituna. Vakioinnilla ikä- ja
sukupuolirakenteen vaikutus indeksilukuun voidaan poistaa, mikä
mahdollista alueittaisen vertailun alueiden välisistä ikä- ja
sukupuolirakenteen eroista huolimatta. Sairastavuusindeksi perustuu
kolmeen tilastomuuttujaan: kuolleisuuteen, työkyvyttömyyseläkkeellä
olevien osuuteen työikäisistä (16–64-vuotiaat) sekä lääkkeiden ja
ravintovalmisteiden korvausoikeuksien haltijoiden osuuteen väestöstä.
Niistä kukin on suhteutettu maan väestön keskiarvoon.
Sairastavuusindeksi on näiden kolmen osaindeksin keskiarvo. Yhden
osaindeksin laskentatapaa muutettiin vuonna 2012:
erityiskorvausoikeusindeksi laajennettiin kattamaan myös rajoitetusti
peruskorvattavien lääkkeiden korvausoikeudet sekä kliinisten
ravintovalmisteiden korvausoikeudet. Muutoksen yhteydessä osaindeksin
nimi muutettiin lääkekorvausoikeusindeksiksi. Vuonna 2013 ikä- ja
sukupuoliryhmittäistä laskentaa tarkennettiin. Kaikki Terveyspuntarin
sarastavuusindeksit on päivitetty takautuvasti nykyisen laskentatavan
mukaisiksi. Vuonna 2013 ikä- ja sukupuoliryhmittäistä laskentaa
tarkennettiin ja kaikki Terveyspuntarin sairastavuusindeksit
päivitettiin takautuvasti nykyisen laskentatavan mukaisiksi.

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
<td style="text-align: left;">indeksi</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">vuosi</td>
<td style="text-align: left;">integer</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="odd">
<td style="text-align: left;">vakioitu</td>
<td style="text-align: left;">string</td>
<td style="text-align: left;">default</td>
</tr>
<tr class="even">
<td style="text-align: left;">indeksin_arvo</td>
<td style="text-align: left;">number</td>
<td style="text-align: left;">default</td>
</tr>
</tbody>
</table>

**Datan ensimmäiset rivit**

    head(dat)  %>% kable(format = "markdown")

<table>
<thead>
<tr class="header">
<th style="text-align: right;">kuntanumero</th>
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">indeksi</th>
<th style="text-align: right;">vuosi</th>
<th style="text-align: left;">vakioitu</th>
<th style="text-align: right;">indeksin_arvo</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2017</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">93.8</td>
</tr>
<tr class="even">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2016</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">91.9</td>
</tr>
<tr class="odd">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2015</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">92.9</td>
</tr>
<tr class="even">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2014</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">89.5</td>
</tr>
<tr class="odd">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2013</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">102.7</td>
</tr>
<tr class="even">
<td style="text-align: right;">5</td>
<td style="text-align: left;">Alajärvi</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: right;">2012</td>
<td style="text-align: left;">Vakioitu</td>
<td style="text-align: right;">104.7</td>
</tr>
</tbody>
</table>

Kuvio
-----

    dat %>% 
      filter(vuosi == 2017,
             indeksi == "kuolleisuusindeksi") %>% 
      arrange(desc(indeksin_arvo)) %>% 
      slice(1:20) %>% 
      mutate(kunta = forcats::fct_reorder(kunta, indeksin_arvo)) %>% 
      ggplot(aes(x = kunta, y = indeksin_arvo, label = indeksin_arvo)) + 
      geom_col() + 
      coord_flip() + 
      geom_text(aes(y = 0), hjust = 0, color = "white") +
      labs(title = "Esimerkkikuvion esimerkkiotsikko") +
      theme_light()

![](esimerkki_R_files/figure-markdown_strict/kuva1-1.png)

Datan yhdistäminen Tilastokeskuksen kuntien avainlukuihin
---------------------------------------------------------

    # PXWEB query 
    pxweb_query_list <- 
      list("Alue 2018"=c("SSS","020","005","009","010","016","018","019","035","043","046","047","049","050","051","052","060","061","062","065","069","071","072","074","075","076","077","078","079","081","082","086","111","090","091","097","098","099","102","103","105","106","108","109","139","140","142","143","145","146","153","148","149","151","152","165","167","169","170","171","172","176","177","178","179","181","182","186","202","204","205","208","211","213","214","216","217","218","224","226","230","231","232","233","235","236","239","240","320","241","322","244","245","249","250","256","257","260","261","263","265","271","272","273","275","276","280","284","285","286","287","288","290","291","295","297","300","301","304","305","312","316","317","318","398","399","400","407","402","403","405","408","410","416","417","418","420","421","422","423","425","426","444","430","433","434","435","436","438","440","441","475","478","480","481","483","484","489","491","494","495","498","499","500","503","504","505","508","507","529","531","535","536","538","541","543","545","560","561","562","563","564","309","576","577","578","445","580","581","599","583","854","584","588","592","593","595","598","601","604","607","608","609","611","638","614","615","616","619","620","623","624","625","626","630","631","635","636","678","710","680","681","683","684","686","687","689","691","694","697","698","700","702","704","707","729","732","734","736","790","738","739","740","742","743","746","747","748","791","749","751","753","755","758","759","761","762","765","766","768","771","777","778","781","783","831","832","833","834","837","844","845","846","848","849","850","851","853","857","858","859","886","887","889","890","892","893","895","785","905","908","911","092","915","918","921","922","924","925","927","931","934","935","936","941","946","976","977","980","981","989","992","MK01","MK02","MK04","MK05","MK06","MK07","MK08","MK09","MK10","MK11","MK12","MK13","MK14","MK15","MK16","MK17","MK18","MK19","MK21","SK011","SK014","SK015","SK016","SK021","SK022","SK023","SK024","SK025","SK041","SK043","SK044","SK051","SK052","SK053","SK061","SK063","SK064","SK068","SK069","SK071","SK081","SK082","SK091","SK093","SK101","SK103","SK105","SK111","SK112","SK113","SK114","SK115","SK122","SK124","SK125","SK131","SK132","SK133","SK134","SK135","SK138","SK141","SK142","SK144","SK146","SK151","SK152","SK153","SK154","SK161","SK162","SK171","SK173","SK174","SK175","SK176","SK177","SK178","SK181","SK182","SK191","SK192","SK193","SK194","SK196","SK197","SK211","SK212","SK213","2020MK01","2020MK02","2020MK04","2020MK05","2020MK06","2020MK07","2020MK08","2020MK09","2020MK10","2020MK11","2020MK12","2020MK13","2020MK14","2020MK15","2020MK16","2020MK17","2020MK18","2020MK19","2020MK21","2020SK011","2020SK014","2020SK015","2020SK016","2020SK021","2020SK022","2020SK023","2020SK024","2020SK025","2020SK041","2020SK043","2020SK044","2020SK051","2020SK052","2020SK053","2020SK061","2020SK063","2020SK064","2020SK068","2020SK069","2020SK071","2020SK081","2020SK082","2020SK091","2020SK093","2020SK101","2020SK103","2020SK105","2020SK111","2020SK112","2020SK113","2020SK114","2020SK115","2020SK122","2020SK124","2020SK125","2020SK131","2020SK132","2020SK133","2020SK134","2020SK135","2020SK138","2020SK141","2020SK142","2020SK144","2020SK146","2020SK151","2020SK152","2020SK153","2020SK154","2020SK161","2020SK162","2020SK171","2020SK173","2020SK174","2020SK175","2020SK176","2020SK177","2020SK178","2020SK181","2020SK182","2020SK191","2020SK192","2020SK193","2020SK194","2020SK196","2020SK197","2020SK211","2020SK212","2020SK213"),
           "Tiedot"=c("M408","M411","M476","M391","M421","M478","M404","M410","M303","M297","M302","M44","M62","M70","M488","M486","M137","M140","M130","M162","M78","M485","M152","M72","M84","M106","M499","M496","M495","M497","M498"))

    # Download data 
    tk_lst <- 
      pxweb_get(url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Kuntien_avainluvut/2018/kuntien_avainluvut_2018_viimeisin.px",
                query = pxweb_query_list)
    tk_avainluvut <- as.data.frame(tk_lst, column.name.type = "text", variable.value.type = "text") %>% 
      # levitetään data
      spread(key = Tiedot, value = `Kuntien avainluvut`)

    df <- left_join(dat, tk_avainluvut, by = c("kunta" = "Alue 2018"))
    # Piirretään hajontakuvio
    df2 <- df %>% 
      filter(vuosi == 2017,
             indeksi == "kuolleisuusindeksi") 

    ggplot(df2, aes(x = `Yli 64-vuotiaiden osuus väestöstä, %, 2017`, 
                    y = indeksin_arvo, 
                    size = `Väkiluku, 2017`)) + 
      geom_point(alpha = .3) +
      labs(y = "Kuolleisuusindeksi") + 
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
<thead>
<tr class="header">
<th style="text-align: left;">kunta</th>
<th style="text-align: left;">indeksin_arvo</th>
<th style="text-align: left;">kuntanumero</th>
<th style="text-align: left;">indeksi</th>
<th style="text-align: left;">vuosi</th>
<th style="text-align: left;">vakioitu</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">105,5</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2013</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">104,0</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2012</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">102,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2011</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">102,0</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2010</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">87,8</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">85,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">81,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">88,4</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">98,8</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2013</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">92,1</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2012</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">85,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2011</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">84,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">kuolleisuusindeksi</td>
<td style="text-align: left;">2010</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">105,4</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">105,4</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">106,9</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">106,1</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">107,7</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2013</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">109,0</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2012</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">110,6</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2011</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">112,1</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">lääkekorvausoikeusindeksi</td>
<td style="text-align: left;">2010</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">116,5</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">112,8</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">105,8</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">108,1</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">109,9</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2013</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">110,9</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2012</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">110,9</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2011</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">109,8</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">työkyvyttömyysindeksi</td>
<td style="text-align: left;">2010</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">103,2</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2017</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">101,1</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2016</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">98,0</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2015</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
<tr class="even">
<td style="text-align: left;">Veteli</td>
<td style="text-align: left;">100,9</td>
<td style="text-align: left;">924</td>
<td style="text-align: left;">Sairastavuusindeksi</td>
<td style="text-align: left;">2014</td>
<td style="text-align: left;">Vakioitu</td>
</tr>
</tbody>
</table>
