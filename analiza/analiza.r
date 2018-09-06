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

#izrišemo graf slovenskih občin pravih dimenzij

  vrsta.intervencij <- function(kategorija){
    vrsta <-  filter(intervencije.po.obcinah, aktivnost == kategorija)
    zemljevid.kategorije <- left_join(zemljevid, vrsta, by=c("OB_IME.x" = "obcina"))
    graf <- ggplot() + geom_polygon(data=zemljevid.kategorije, 
                          aes(long, lat, group=group, fill=stevilo))+
                          theme(axis.line=element_blank(),
                                axis.text.x=element_blank(),
                                axis.text.y=element_blank(),
                                axis.ticks=element_blank(),
                                plot.title=element_blank(),
                                axis.title.x=element_blank(),
                                axis.title.y=element_blank(),
                                panel.background=element_blank(),
                                panel.border=element_blank(),
                                panel.grid.major=element_blank(),
                                panel.grid.minor=element_blank(),
                                plot.background=element_blank())
                          
    return(graf)
  }    
  
# izdelava grafa za analizo števila intervencij skozi leta
  stevilo.skozi.leta <-intervencije.po.kategorijah.skozi.leta %>% group_by(., Leto) %>% summarise(Število = sum(Število)) %>% 
    ggplot(., aes(x=Leto, y=Število)) + geom_area(fill="white")

#Število intervencij po kategorijah skozi leta
  kategorije.skozi.leta <- intervencije.po.kategorijah.skozi.leta %>% group_by(., VrstaDogodka, Leto) %>% summarise(Število = sum(Število)) %>%
  ggplot(., aes(Leto, Število, color=VrstaDogodka)) + geom_line(size = 5) + theme(legend.key.width = unit(2, "cm"))


#Požari skozi leta po vrstah
   vrsta.pozarov.po.letih <- group_by(pozari.vrsta, VrstaDogodka1, Leto1) %>% summarise(stevilo = sum(PKID2))
   vrsta.pozarov.po.letih$stevilo <- round(vrsta.pozarov.po.letih$stevilo)
   pozari.po.letih <-ggplot(vrsta.pozarov.po.letih, aes(x = Leto1, y = stevilo,  fill = VrstaDogodka1)) + geom_histogram(stat = "identity") +
                        labs(title="stevilo pozarov skozi leta", x = "leta")
   