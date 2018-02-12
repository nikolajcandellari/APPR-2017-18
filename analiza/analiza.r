# 4. faza: Analiza podatkov

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
analiza.naslovov <- function(){
                    po.naslovih <- left_join(drustva.po.naslovih.in.postah, tabela.naselji.toupper,
                                             by= c("naslov" = "NASELJE"))
                    po.postah <- left_join(drustva.po.naslovih.in.postah, tabela.naselji.toupper,
                                           by=c("posta" = "NASELJE"))

                    drustvo <- po.naslovih$drustvo
                    obcina  <- vector()

                    for (i in 1:length(drustvo)){
                          if(is.na(po.postah$OBCINA[i])){
                            obcina[i] <- (po.naslovih$OBCINA)[i]
                            }
                            else{
                                obcina[i] <- (po.postah$OBCINA)[i]
                                }
                            }
                    return(data_frame(drustvo, obcina))
                    }
drustva.z.obcinami <- analiza.naslovov()
