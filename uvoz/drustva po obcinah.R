library(rvest)

uvoz.drustvenih.naslovov <- function(link){
  drustva.html <- html_session(link) %>% read_html() %>% 
    html_nodes(xpath ="//div[contains(@class, 'drustvo')]")
    drustva <- data.frame(drustvo= drustva.html %>% html_nodes(xpath = "./h2") %>% html_text(),
                          posta = drustva.html %>% html_nodes(xpath = "./div/text()[2]") %>% html_text(),
                          naselje = drustva.html %>% html_nodes(xpath = "./div/text()[2]") %>% html_text(),
                          stringsAsFactors = FALSE)
    
    posta.3 <- drustva.html %>% html_nodes(xpath = "./div/text()[3]") %>% html_text()
    posta.3 <- gsub("^[0-9][0-9]", NA, posta.3)
      
  for (i in 1:length(drustva$posta)){
    if(drustva$posta[i] == toupper(drustva$posta[i])){
                                                      drustva$posta[i] <- drustva$posta[i]
                                                      drustva$naselje[i] <- drustva$naselje[i]
                                                      }                                                      
    
    else{
      drustva$posta[i] <- posta.3[1]
      drustva$naselje[i] <- posta.3[1]
      posta.3 <- posta.3[2:length(posta.3)]
         }
    
    # vzemi string za štirimi črkami in presledkom(številka pošte)
    # dobimo ime pošte
    drustva$posta[i] <- tail(last(strsplit(drustva$posta, "[0-9][0-9][0-9][0-9] ")[i]), 1)
    drustva$naselje[i] <- head(first(strsplit(drustva$naselje, " [0-9]")[i]), 1)
  }
  return(drustva)
}

uvoz.naslovov.poklicnih.enot <- function(link){
  enote.html <- html_session(link) %>% read_html()
  drustvo = enote.html %>% html_nodes(xpath = "//td[(((count(preceding-sibling::*) + 1) = 1) and parent::*)]") %>% 
    html_text() %>% 
    gsub("Helios poslovne storitve d.o.o.,|Javni zavod za požarno, reševalno in tehnično službo |Center požarne varnosti |Gasilsko reševalna služba |Gasilsko reševalno služba |Javni zavod gasilska brigada |Poklicna gasilska enota | - poklicna Indust. gasilska enota|Gasilska brigada |Javni zavod za gasilsko in reševalno dejavnost - gasilska enota |Gasilsko reševalni center |Gasilski zavod |Zavod za gasilno in reševalno službo ", "", .) %>%
    gsub('[\t\n\r]', '',.) %>% gsub("^DOMŽALE", "DOMŽALE", .) %>%
    toupper()
  posta = enote.html %>% html_nodes(xpath = "//td[(((count(preceding-sibling::*) + 1) = 2) and parent::*)]") %>% html_text() %>% 
    gsub(".*\\s\\d\\d\\d\\d\\s", "", .) %>% toupper()
  naselje = posta
  enote <- data.frame(drustvo, posta, naselje, stringsAsFactors = FALSE)
  return(enote)
}


belokranjska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/belokranjska-regija")
celjska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/celjska-regija")
dolenjska.dustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/dolenjska-regija")
gorenjska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/gorenjska-regija")
koroska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/koroska-regija")
ljubljanska.i.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/ljubljanska-i-regija")
ljubljanska.ii.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/ljubljanska-ii-regija")
ljubljanska.iii.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/ljubljanska-iii-regija")
mariborska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/mariborska-regija")
notranjska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/notranjska-regija")
obalno.kraska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/obalno-kraska-regija")
podravska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/podravska-regija")
pomurska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/pomurska-regija")
posavska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/posavska-regija")
savinjsko.saleska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/savinjsko-saleska-regija")
severno.primorska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/severno-primorska-regija")
zasavska.drustva <- uvoz.drustvenih.naslovov("http://www.gasilec.net/zasavska-regija")
poklicne.enote <- uvoz.naslovov.poklicnih.enot("http://www.gasilec.net/organizacija/zanimive-povezave/poklicne-gasilske-enote")

drustva.po.naslovih <- bind_rows(belokranjska.drustva, celjska.drustva, dolenjska.dustva, gorenjska.drustva, koroska.drustva, ljubljanska.i.drustva, ljubljanska.ii.drustva, ljubljanska.iii.drustva, mariborska.drustva, notranjska.drustva, obalno.kraska.drustva, podravska.drustva, pomurska.drustva, posavska.drustva, savinjsko.saleska.drustva, severno.primorska.drustva, zasavska.drustva, poklicne.enote)
