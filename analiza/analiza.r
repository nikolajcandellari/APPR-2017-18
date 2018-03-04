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


osnovna <- left_join(drustva.po.naslovih, poste, by=c("posta" = "posta")) %>%  
left_join(., gsub("^(O|Mestna o)bčina ", "", tabela.naselji.toupper), by=c("naselje" = "NASELJE"))
