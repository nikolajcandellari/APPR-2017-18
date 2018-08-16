# 4. faza: Analiza podatkov

library(rvest)
library(dplyr)
library(tidyr)
library(readr)


# funkcija za izločanje podvojenih imen drustev, ki so nastala zaradi neskladanja mej obcin z mejami
#poštnih naslovov

for(i in 1:(length(osnovna$drustvo))){
  if(is.na(osnovna$obcina)[i]){osnovna$obcina[i] <- osnovna$OBCINA[i]}
}

osnovna.grp <- osnovna %>% group_by(drustvo)

osnovna.OK <- osnovna.grp %>% filter(n() == 1) %>% summarise(obcina = min(obcina))
osnovna.podvojene <- osnovna %>% filter(!drustvo %in% osnovna.OK, obcina == OBCINA) %>% select(drustvo, obcina)

napredna <- rbind(osnovna.OK, osnovna.podvojene) %>% na.omit()

obcine <- left_join(napredna, vrste.intervencij.po.drustvih.in.enotah, by=c("drustvo" = "enota")) %>% unique()

#grupiramo podatke po obcinah da jih bomo lahko predstavili v obliki zemljevida obcin

intervencije.po.obcinah <- obcine %>% group_by(obcina, aktivnost) %>% summarise(stevilo=sum(stevilo))

#izrišemo graf pravih dimenzij

  vrsta.intervencij <- function(kategorija){
    vrsta <-  filter(intervencije.po.obcinah, aktivnost == kategorija) %>% 
                    left_join(stevilo.prebivalcev.po.obcinah, by=c("obcina" = "obcina"))
    zemljevid.kategorije <- left_join(zemljevid, vrsta, by=c("OB_IME.x" = "obcina"))
    graf <- ggplot() + geom_polygon(data=zemljevid.kategorije, 
                          aes(long, lat, group=group, fill=stevilo))+ #fill=(stevilo*10^9/(POVRSINA*populacija)^(0.5)))) +
                          theme_bw() + labs(title="stevilo intervencij po kategorijah")
                          
    return(graf)
  }    

  vrsta.pozarov.po.letih <- group_by(pozari.vrsta, VrstaDogodka1, Leto1) %>% summarise(stevilo = sum(PKID2))
  vrsta.pozarov.po.letih$stevilo <- round(vrsta.pozarov.po.letih$stevilo)
  ggplot(vrsta.pozarov.po.letih, aes(x = Leto1, y = stevilo,  fill = VrstaDogodka1)) + geom_histogram(stat = "identity") +
    labs(title="stevilo pozarov skozi leta", x = "leta")
  
  
  spreminjanje.stevila.intervencij.skozi.leta <- group_by(intervencije.po.kategorijah.skozi.leta, Leto, VrstaDogodka) %>% 
    summarise(število = sum(Število))
  ggplot(spreminjanje.stevila.intervencij.skozi.leta, aes(x = Leto, y = število,  fill = VrstaDogodka)) + geom_histogram(stat = "identity")
  