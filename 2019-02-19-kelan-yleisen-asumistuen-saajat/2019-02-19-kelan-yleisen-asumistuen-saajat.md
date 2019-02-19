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
    library(tidyverse)
    library(jsonlite)
    library(ckanr)

Datan ja metadatan lataaminen
=============================

    ckanr_setup(url = "https://beta.avoindata.fi/data/fi/")
    x <- package_search(q = "Kansaneläkelaitos", fq = "title:yleisen")
    resources <- x$results[[1]]$resources
    resources[[1]]$name

    ## [1] "Kelan yleisen asumistuen saajat"

    resources[[2]]$name

    ## [1] "Metadata"

    dat <- readr::read_csv2(resources[[1]]$url)
    meta <- fromJSON(txt = resources[[2]]$url)

Datan ja metadatan kuvailu
==========================

    meta$profile

    ## [1] "data-package"

    meta$name

    ## [1] "Kelan yleisen asumistuen saajat"

    meta$title

    ## [1] "Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot"

    meta$description

    ## [1] "Yleisen asumistuen saajaruokakunnat, keskimääräiset tuet, asumismenot ja ruokakunnan tulot.\n Cras neque odio, sollicitudin a porttitor id, convallis ut nibh. Suspendisse vel purus nibh. Cras finibus dolor eu justo vehicula dapibus. Mauris egestas finibus velit eget mattis. Suspendisse sem nunc, vulputate eu lectus vitae, iaculis tempor augue. Curabitur placerat risus magna, at mattis magna pharetra id. Etiam ornare enim non sem suscipit egestas. \n"

    # Datan muuttujatieto
    meta$resources$schema$fields[[1]]

    ##                                   name                               title
    ## 1                                kunta                Kunnan nimi suomeksi
    ## 2                                vuosi                               vuosi
    ## 3                     ruokakuntatyyppi                    Ruokakuntatyyppi
    ## 4                     saajaruokakunnat                    Saajaruokakunnat
    ## 5           asumistuki_keskim_euroa_kk      Keskimääräinen asumistuki e/kk
    ## 6          asumismenot_keskim_euroa_kk            Keskim. asumismenot e/kk
    ## 7       asumistukitulo_keskim_euroa_kk         Keskim. asumistukitulo e/kk
    ## 8   asumismenot_ennen_asumistukea_pros     Asumismenot ennen asumistukea %
    ## 9  asumismenot_asumistuen_jalkeen_pros   Asumismenot asumistuen  jälkeen %
    ## 10          asumismenot_keskim_e_m2_kk         Keskim. asumismenot e/m2/kk
    ## 11   asunnon_keskim_pintaala_m2_asunto Asunnon keskim. pinta-ala m2/asunto
    ##       type  format
    ## 1   string default
    ## 2  integer default
    ## 3   string default
    ## 4   number default
    ## 5  integer default
    ## 6  integer default
    ## 7  integer default
    ## 8  integer default
    ## 9  integer default
    ## 10  number default
    ## 11  number default

    # Datan ensimmäiset rivit 
    head(dat)

    ## # A tibble: 6 x 11
    ##   kunta vuosi ruokakuntatyyppi saajaruokakunnat asumistuki_kesk…
    ##   <chr> <dbl> <chr>                       <dbl>            <dbl>
    ## 1 Akaa   2018 Yhteensä                    60400          2796358
    ## 2 Akaa   2018 Yksin asuvat                37900          2337341
    ## 3 Akaa   2018 Lapsettomat par…             2700          2688667
    ## 4 Akaa   2018 Lapsiperheet yh…            18400          3784205
    ## 5 Akaa   2018 Kahden huoltaja…             3800          3875579
    ## 6 Akaa   2018 Yhden huoltajan…            14600          3760423
    ## # … with 6 more variables: asumismenot_keskim_euroa_kk <dbl>,
    ## #   asumistukitulo_keskim_euroa_kk <dbl>,
    ## #   asumismenot_ennen_asumistukea_pros <dbl>,
    ## #   asumismenot_asumistuen_jalkeen_pros <dbl>,
    ## #   asumismenot_keskim_e_m2_kk <dbl>,
    ## #   asunnon_keskim_pintaala_m2_asunto <dbl>

Kuvio
=====

    library(ggplot2)
    # valitaan ensin top 10 kuntaa, joissa korkeimmat keskimääräiset asumistukimenot
    dat %>% 
      filter(ruokakuntatyyppi == "Yhteensä",
             vuosi == 2018) %>% 
      arrange(desc(asumistuki_keskim_euroa_kk)) %>% 
      slice(1:10) %>% pull(kunta) -> kunnat

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
      labs(title = "Keskimääräinen asumistuki kuukaudessa")

![](2019-02-19-kelan-yleisen-asumistuen-saajat_files/figure-markdown_strict/kuva1-1.png)
