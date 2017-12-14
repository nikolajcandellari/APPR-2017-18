# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi stevilo intervencij po kategorijah ter po drustvih z
# ukazom za zapis teh podatkov v .csv obliko
write_csv(get.reports(), "podatki/vrste intervencij po drustvih.csv")

# Funkcije, ki uvozijo podatke iz datoteke druzine.csv
uvozi.pozari.po.urah <- function() {
  data.1 <- read_csv("podatki/pozari po urah.csv", skip = 10,
                    locale = locale(encoding = "UTF-8"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
                        value.name = "stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels = obcine)
  return(data)
}

uvozi.pozarne.intervencije <- function() {
  data.2 <- read_csv("podatki/pozarne intervencije.csv", skip = 7, n_max = 221,
                   locale = locale(encoding = "UTF-8"))
  data.2$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
                        value.name = "stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels = obcine)
  return(data)
}


# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
