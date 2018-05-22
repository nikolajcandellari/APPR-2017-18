# 2. faza: Uvoz podatkov
library(httr)
library(rvest)
library(dplyr)
library(readr)

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")


#SPODNJE VRSTICE NE POGANJAJ VEDNO, PORABI OGROMNO ČASA!!!! 
#Drugače spodnja vrstica uvozi število intervencij po kategorijah za poklicne
#enote in prostovoljna drustva za leto 2016
#
#write_csv(get.reports(type = 18), "podatki/vrste intervencij po drustvih.csv")
#write_csv(get.reports(type = 16), "podatki/vrste intervencij po poklicnih enotah.csv")

# Zapišimo podatke v razpredelnice
  obcine <- uvozi.obcine()

  pozari.cas <- read_csv("podatki/pozari po urah.csv", skip = 10)

  pozari.vrsta <- read_csv("podatki/pozarne intervencije.csv", skip = 7, n_max = 221)
  for (i in length(pozari.vrsta$PKID2)){
    if (pozari.vrsta$PKID2[i] != round(pozari.vrsta$PKID2[i])){
        pozari.vrsta$PKID2[i] <- 1000 * pozari.vrsta$PKID2
    }
  }

  pozari.skoda.vrsta <- read_csv("podatki/pozari skoda.csv", skip = 93)
  pozari.skoda.cena <- read_csv("podatki/pozari skoda.csv", n_max = 91)
  
  pozari.vzrok.povzrocitev <- read_csv("podatki/pozari po vzroku.csv", skip = 3, n_max = 222)
  pozari.vzrok.vrsta.pozara <- read_csv("podatki/pozari po vzroku.csv", skip = 226)

  intervencije.po.kategorijah.skozi.leta <- read_csv("podatki/Pregled dogodkov po kategorijah od 2005-2017.csv",
                                                      skip = 5, n_max=559)
  
#število prebivalcev po občinah, uvoz iz spletne strani  
  
  stevilo.prebivalcev.po.obcinah <- read_csv2("podatki/stevilo prebivalcev po obcinah za leto 2016.csv",
                                              skip = 5, n_max = 212,
                                              locale = locale(encoding = "CP1250", grouping_mark=";"), 
                                              col_names = c("1", "obcina", "populacija"))
  
  for (i in 1:length(stevilo.prebivalcev.po.obcinah$obcina)) {
        stevilo.prebivalcev.po.obcinah$obcina[i] <- 
              head(first(strsplit(stevilo.prebivalcev.po.obcinah$obcina[i], "/"))[1]) %>% toupper()
      }
        
  stevilo.prebivalcev.po.obcinah <- data.frame(obcina = stevilo.prebivalcev.po.obcinah$obcina, 
                                               populacija = stevilo.prebivalcev.po.obcinah$populacija)

#podatki iz funkcije "vrste intervencij po drustvih.r", ki smo jih shranili v datoteko

  vrste.intervencij.po.drustvih <- read_csv("podatki/vrste intervencij po drustvih.csv") 
  
  poklicne <- function(link = "podatki/vrste intervencij po poklicnih enotah.csv"){
              vrste.intervencij.po.poklicnih.enotah <- read_csv(link)
              aktivnost <- vrste.intervencij.po.poklicnih.enotah$aktivnost
              stevilo <- vrste.intervencij.po.poklicnih.enotah$stevilo
              enota <- vrste.intervencij.po.poklicnih.enotah$enota 
              nbsp <- rawToChar(as.raw(160))
              enota <- gsub(nbsp, " ", enota) %>%
                        gsub("GARS |GB |GASILSKI ZAVOD |JZ GRS |JZGB |PGE |ZGRS |CZR |GRC |JZ GB |JZ GRD GE ", "", .) %>%
                        toupper()
              tabela <- data.frame(aktivnost, stevilo, enota)
  return(tabela)
  }
  
  vrste.intervencij.po.poklicnih.enotah <- poklicne()
  vrste.intervencij.po.drustvih.in.enotah <- bind_rows(vrste.intervencij.po.drustvih, vrste.intervencij.po.poklicnih.enotah)
  
  uvozi.poste <- function(crka) {
    link <- sprintf("https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(%s)", crka)
    stran <- html_session(link) %>% read_html()
    tabela <- stran %>% html_nodes(xpath = "//table[contains(@class, 'wikitable')]") %>% .[[1]] %>%
      html_table(fill = TRUE)
    `Pošta` <- NA # če nimamo stolpca `Pošta`, bomo uporabili NA
    tabela %>% transmute(posta = toupper(parse_character(`Pošta`)),
                        obcina = toupper(gsub("^(O|Mestna o)bčina ", "", `Občina`))) %>% drop_na(1)
  }

  abeceda <- "ABCČDEFGHIJKLMNOPRSŠTUVZŽ"
  poste <- bind_rows(lapply(1:25, . %>% { uvozi.poste(substr(abeceda, ., .)) })) %>%
    arrange(posta) %>% unique()

# v tem delu bomo najprej poizkusili razdeliti drustva po obcinah po naslovih vendar to nebo slo povsod
# saj so nekateri naslovi-imena ulic, zato bomo v takih primerih poizkusali drustva po obcinah razdeliti 
# se s pomocjo postnih naslovov

  tabela.toupper <- data.frame(NASELJE = tabela.naselji.toupper$NASELJE,
                              OBCINA = tabela.naselji.toupper$OBCINA)
  tabela.toupper$OBCINA <- gsub("^(OBČINA|MESTNA OBČINA) ", "", tabela.naselji.toupper$OBCINA)

  osnovna <- left_join(drustva.po.naslovih, poste, by=c("posta" = "posta")) %>%  
    left_join(tabela.toupper, by=c("naselje" = "NASELJE")) 
