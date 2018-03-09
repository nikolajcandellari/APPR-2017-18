# 4. faza: Analiza podatkov

library(rvest)
library(dplyr)
library(tidyr)
library(readr)

podatki <- obcine %>% transmute(obcina, povrsina, gostota,
                                gostota.naselij = naselja/povrsina) %>%
  left_join(povprecja, by = "obcina")
row.names(podatki) <- podatki$obcina
podatki$obcina <- NULL

# Število skupin
n <- 5
skupine <- hclust(dist(scale(podatki))) %>% cutree(n)


# v tem delu bomo najprej poizkusili razdeliti drustva po obcinah po naslovih vendar to nebo slo povsod
# saj so nekateri naslovi imena ulic, zato bomo v takih primerih poizkusali drustva po obcinah razdeliti 
# se s pomocjo postnih naslovov

tabela.toupper <- data.frame(NASELJE = tabela.naselji.toupper$NASELJE,
                             OBCINA = tabela.naselji.toupper$OBCINA)
tabela.toupper$OBCINA <- gsub("^(OBČINA|MESTNA OBČINA) ", "", tabela.naselji.toupper$OBCINA)

osnovna <- left_join(drustva.po.naslovih, poste, by=c("posta" = "posta")) %>%  
  left_join(tabela.toupper, by=c("naselje" = "NASELJE")) 

# funkcija za izločanje podvojenih imen drustev, ki so nastala zaradi neskladanja mej obcin z mejami
#poštnih naslovov

for(i in 1:(length(osnovna$drustvo))-1){
  
  if(duplicated(osnovna$drustvo)[i+1]){
    
    if(is.na(osnovna$obcina)[i]){
      
      if(is.na(osnovna$OBCINA)[i]){
        osnovna <- osnovna[-i, ]
      }
      else {osnovna$obcina[i] <- osnovna$OBCINA[i]}
      
    }
    if(is.na(osnovna$OBCINA)[i]){
      osnovna$OBCINA[i] <- osnovna$obcina[i]
    }
    if(osnovna$obcina[i] == osnovna$OBCINA[i]){osnovna <- osnovna[i+1, ]}
    
    else {osnovna <- osnovna[-i, ]}
  }
}

napredna.tabela <- data.frame(drustvo = osnovna$drustvo, obcina = osnovna$obcina)
