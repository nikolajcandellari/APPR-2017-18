# Analiza posredovanj gasilskih enot na območju Slovenije

Gasilske enote so poleg ekip NMP-jev(nujne medicinske pomoči) ene izmed najpogosteje potrebovanih intervencijskih služb v Sloveniji. Z veliko znanja in dobro opremo so gasilske enote na pomoč poklicane na raznovrstne intervencije, kjer po svojih najboljših močeh rešujejo življenja, premoženja in naravo.


## Tematika

Cilj tega projekta bo torej analiza števila intervencij po posameznih društvih(npr. poklicnih enotah) za leto 2016, podrobnejša analiza požarov(število požarov po regijah, povzočena škoda, vzrok, čas nastanka, ... ) ter med letno primerjanje števila intervencij po posameznih kategorijah...

1.tabela: število intervencij po društvih (društvo, št.intervencij, vrsta intervencij,..)

2.tabela: med letno primerjanje št. intervencij po kategorijah(leto, kategorija, število)

3.tabela: analiza požarov v Sloveniji(društvo, vzrok, čas nastanka, povzročena škoda, vrsta požara(npr. požar stanovanjskega objekta, požar osebnega vozila, itd.))

Kot vir bom uporabljal spletne strani in sicer:


http://spin.sos112.si/SPIN2/Javno/

https://apl.gasilec.net/Vulkan/Login.aspx

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
