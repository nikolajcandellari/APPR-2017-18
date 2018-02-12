library(rvest)

uvoz.drustvenih.naslovov <- function(link){
  drustva.html <- html_session(link) %>% read_html() %>% 
    html_nodes(xpath ="//div[contains(@class, 'drustvo')]")
    drustva <- data.frame(drustvo = drustva.html %>% html_nodes(xpath = "./h2") %>% html_text(),
                          naslov = drustva.html %>% html_nodes(xpath = "./div/text()[2]") %>% html_text(),
                          posta = drustva.html %>% html_nodes(xpath = "./div/text()[2]") %>% html_text(),
                          stringsAsFactors = FALSE)
    
    naslov.1 <- drustva.html %>% html_nodes(xpath = "./div/text()[3]") %>% html_text()
    posta.1 <- drustva.html %>% html_nodes(xpath = "./div/text()[3]") %>% html_text()
    
  for (i in 1:length(drustva$naslov)){
    
    #generiranje vektorja z pravimi naslovi
    if(drustva$naslov[i] == toupper(drustva$naslov[i])){drustva$naslov[i] <- drustva$naslov[i]}
    
    else{drustva$naslov[i] <- naslov.1[1]
          naslov.1 <- naslov.1[2:length(naslov.1)]
          }
  for (i in 1:length(drustva$naslov)){
    
    if(drustva$posta[i] == toupper(drustva$posta[i])){drustva$posta[i] <- drustva$posta[i]}
    
    else{drustva$posta[i] <- posta.1[1]
          posta.1 <- posta.1[2:length(posta.1)]
          }
    
    # vzemi string za štirimi črkami in presledkom(številka pošte)
    # dobimo ime pošte
    drustva$naslov[i] <- head(first(strsplit(drustva$naslov, " [0-9]")[i]), 1)
    drustva$posta[i] <- tail(last(strsplit(drustva$posta, "[0-9][0-9][0-9][0-9] ")[i]), 1)
  }
  return(drustva)
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

drustva.po.naslovih.in.postah <- bind_rows(belokranjska.drustva, celjska.drustva, dolenjska.dustva, gorenjska.drustva, koroska.drustva, ljubljanska.i.drustva, ljubljanska.ii.drustva, ljubljanska.iii.drustva, mariborska.drustva, notranjska.drustva, obalno.kraska.drustva, podravska.drustva, pomurska.drustva, posavska.drustva, savinjsko.saleska.drustva, severno.primorska.drustva, zasavska.drustva)
