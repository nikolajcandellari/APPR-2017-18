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


# funkcija za izločanje podvojenih imen drustev, ki so nastala zaradi neskladanja mej obcin z mejami
#poštnih naslovov

for(i in 1:(length(osnovna$drustvo))){
  if(is.na(osnovna$obcina)[i]){osnovna$obcina[i] <- osnovna$OBCINA[i]}
}

osnovna.grp <- osnovna %>% group_by(drustvo)

osnovna.OK <- osnovna.grp %>% filter(n() == 1) %>% summarise(obcina = min(obcina))
osnovna.podvojene <- osnovna %>% filter(!drustvo %in% osnovna.OK, obcina == OBCINA) %>% select(drustvo, obcina)

napredna <- rbind(osnovna.OK, osnovna.podvojene) %>% na.omit()

obcine <- left_join(napredna, vrste.intervencij.po.drustvih, by=c("drustvo" = "enota"))

#grupiramo podatke po obcinah da jih bomo lahko predstavili v obliki zemljevida obcin

intervencije.po.obcinah <- obcine %>% group_by(obcina, aktivnost) %>% summarise(stevilo=sum(stevilo))

#izrišemo graf pravih dimenzij

  vrsta.intervencij <- function(kategorija){
    vrsta <-  filter(intervencije.po.obcinah, aktivnost == kategorija) %>% 
                    left_join(stevilo.prebivalcev.po.obcinah, by=c("obcina" = "obcina"))
    zemljevid.kategorije <- left_join(zemljevid, vrsta, by=c("OB_IME" = "obcina"))
    graf <- ggplot() + geom_polygon(data=zemljevid.kategorije, 
                          aes(long, lat, group=group, fill=stevilo))+ #fill=(stevilo*10^9/(POVRSINA*populacija)^(0.5)))) +
                          theme_bw() + labs(title="stevilo intervencij po kategorijah")
                          
    return(graf)
  }    
  