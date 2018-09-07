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

napredna <- rbind(osnovna.OK, osnovna.podvojene) %>% na.omit()  %>%
  mutate(obcina = obcina %>% strapplyc("^([^\n]*)") %>% unlist()) 

obcine <- left_join(napredna, vrste.intervencij.po.drustvih.in.enotah, by=c("drustvo" = "enota")) %>% unique()

#grupiramo podatke po obcinah da jih bomo lahko predstavili v obliki zemljevida obcin

intervencije.po.obcinah <- obcine %>% group_by(obcina, aktivnost) %>% summarise(stevilo=sum(stevilo))

#izrišemo graf slovenskih občin pravih dimenzij

  vrsta.intervencij <- function(kategorija){
    vrsta <-  filter(intervencije.po.obcinah, aktivnost == kategorija)
    zemljevid.kategorije <- left_join(zemljevid, vrsta, by=c("OB_IME" = "obcina"))
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
    ggplot(., aes(x=Leto, y=Število)) + geom_area(fill="yellow") + scale_x_continuous(breaks = seq(2005, 2017, 3))

#Število intervencij po kategorijah skozi leta
  kategorije.skozi.leta <- intervencije.po.kategorijah.skozi.leta %>% group_by(., VrstaDogodka, Leto) %>% summarise(Število = sum(Število)) %>%
  ggplot(., aes(Leto, Število, color=VrstaDogodka)) + geom_line(size = 5) + theme(legend.key.width = unit(2, "cm")) + scale_x_continuous(breaks = seq(2005, 2017, 3)) + guides(color = guide_legend("Vrsta dogodka"))


#Požari skozi leta po vrstah
   vrsta.pozarov.po.letih <- group_by(pozari.vrsta, VrstaDogodka1, Leto1) %>% summarise(stevilo = sum(PKID2))
   vrsta.pozarov.po.letih$stevilo <- round(vrsta.pozarov.po.letih$stevilo)
   pozari.po.letih <-ggplot(vrsta.pozarov.po.letih, aes(x = Leto1, y = stevilo,  fill = VrstaDogodka1)) + geom_histogram(stat = "identity") +
                        labs(title="stevilo pozarov skozi leta", x = "leta") + guides(fill = guide_legend("Vrsta požara"))
   
   
#naprednejša analiza
#pridobivanje povprečnih vrednosti
   povprečna.poseljenost <- stevilo.prebivalcev.po.obcinah$populacija %>% mean() %>% round()
   povprečna.površina <- zemljevid$POVRSINA %>% unique() %>% mean() %>% round()

#popravljanje populacije in površine glede na povprečno vrednost   
   stevilo.prebivalcev.po.obcinah$populacija <- (1/stevilo.prebivalcev.po.obcinah$populacija) * povprečna.poseljenost
   zemljevid$POVRSINA <- (1/zemljevid$POVRSINA) * povprečna.površina 
   
#kreiranje tabele za analizo
   neki.neki <-left_join(intervencije.po.obcinah, stevilo.prebivalcev.po.obcinah, by=c("obcina" = "obcina")) %>% 
     left_join(., zemljevid, by=c("obcina" = "OB_IME"))
   neki.neki <- unique(data.frame(obcina=neki.neki$obcina, aktivnost=neki.neki$aktivnost, stevilo=neki.neki$stevilo, populacija=neki.neki$populacija, površina=neki.neki$POVRSINA))
   neki.neki$stevilo[is.na(neki.neki$stevilo)] <- 0
   
#izračun količnika ogroženosti posamezne občine z določeno vrsto nesreče
# stevilo_intervencij * razlika_populacije_občine_do_povprečne_vrednosti * razlika_površine_občine_do_povprečne_vrednosti
   količnik <- round(neki.neki$stevilo * neki.neki$populacija * neki.neki$površina)
   analizna <- bind_cols(obcina=neki.neki$obcina, aktivnost=neki.neki$aktivnost, količnik=količnik)
   analizna <- analizna[order(-količnik), ] 

#funkcija ki vrne prvih deset občin po količniku glede na kategorijo
   top5 <- function(kategorija){
            a<- filter(analizna, aktivnost == kategorija) %>% head(5)
            return(a$obcina)
   }
   