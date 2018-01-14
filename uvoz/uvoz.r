# 2. faza: Uvoz podatkov
library(httr)
library(rvest)
library(dplyr)

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi stevilo intervencij po kategorijah ter po drustvih z
# ukazom za zapis teh podatkov v .csv obliko

# Poišče vse značke tipa <input>, ki niso kljukice ali slike,
# in njihove privzete vrednosti spravi med podatke.
get.inputs <- function(session, html) {
  inputs <- html %>% html_nodes(xpath="//input[@type!='checkbox'][@type!='image']")
  session$data[inputs %>% html_attr("name")] <- inputs %>% html_attr("value")
  return(session)
}

# Iz vektorja naredi seznam, pri čemer vrednosti NA nadomesti s praznimi nizi
# in izpusti polja, podana z vektorjem exclude.
# Takšna oblika je primerna za uporabo s funkcijo POST.
make.list <- function(x, exclude = NULL) {
  x <- ifelse(is.na(x), "", x)
  return(as.list(x[! names(x) %in% exclude]))
}

# Naredi zahtevek POST na trenutni naslov.
# Odgovor je sestavljen iz polj, ločenih z znakom |.
# Vrne vektor polj.
get.fields <- function(session, exclude = NULL) {
  session$data["__ASYNCPOST"] <- "true"
  session$server %>% paste0(session$action) %>%
    POST(body = make.list(session$data, exclude = exclude), encode = "form",
         session$agent, set_cookies(.cookies = session$cookies)) %>%
    content() %>% strsplit("|", fixed = TRUE) %>% unlist()
}

# Iz podanega vektorja polj izlušči podatke, potrebne za naslednji zahtevek.
get.session <- function(session, fields) {
  hidden <- which(fields == "hiddenField")
  session$data[fields[hidden+1]] <- fields[hidden+2]
  session$action <- fields[which(fields == "formAction")+2]
  return(session)
}

# Prebere vsebino obrazca z danim imenom.
# Ker se lahko v HTML kodi obrazca pojavi znak |,
# jo sestavi iz toliko polj, da skupna dolžina ne preseže pričakovane.
read.panel <- function(fields, name) {
  w <- intersect(which(fields == "updatePanel") + 2, which(fields == name) + 1)
  l <- as.integer(fields[w-3])
  out <- fields[w]
  while (nchar(out) < l) {
    w <- w + 1
    out <- paste0(out, "|", fields[w])
  }
  return(read_html(out))
}

# Glavna funkcija za pridobivanje poročil.
#
# Parametri:
#   * type      Šifra vrste enote.
#               Privzeta vrednost 18 je za
#               Prostovoljna teritorialna gasilska društva
#   * year      Leto - šifra se izračuna tako,
#               da se od njega odšteje 1999.
#   * unit.ids  Vektor šifer enot.
#               Če ni podan, se uvozijo podatki za vse enote.
get.reports <- function(type = 18, year = 2017, unit.ids = NULL) {
  type.id <- as.character(type)
  year.id <- as.character(year - 2009)
  # Seznam z aktualnimi podatki o seji
  session <- list("server" = "http://spin.sos112.si",
                  # Spletna stran onemogoča delovanje avtomatiziranim programom,
                  # zato se predstavimo kot nek resen brskalnik.
                  "agent" = add_headers("User-Agent" = "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:57.0) Gecko/20100101 Firefox/57.0"))
  prva <- session$server %>% paste0("/SPIN2/Javno/Porocila/") %>% html_session(session$agent)
  # Preberemo piškotke, ki določajo trenutno sejo.
  session$cookies <- rvest:::cookies.session(prva) %>% { setNames(.$value, .$name) }
  # HTML obrazec, ki vsebuje vse potrebne podatke.
  form <- read_html(prva) %>% html_node(xpath="//form")
  # Pridobimo naslov, na katerega bomo naredili prvi zahtevek POST.
  # Z vsakim naslednjim zahtevkom se bo ta naslov spremenil.
  session$action <- form %>% html_attr("action")
  # Preberemo privzete vrednosti iz vhodnih polj obrazca.
  session <- session %>% get.inputs(form)
  # Potrebni parametri, da naložimo obrazec za poročila.
  session$data["__EVENTARGUMENT"] <- "s/Javno/Aktivnosti enot"
  session$data["__EVENTTARGET"] <- "ctl00$cphMain$trv"
  session$data["ctl00$scMain"] <- "ctl00$cphMain$up|ctl00$cphMain$trv"
  session$data["ctl00_cphMain_trv_SelectedNode"] <- "ctl00_cphMain_trvt0"
  session$data["ctl00$cphMain$rvMain$ctl11"] <- "standards"
  # Naredimo zahtevek, da pridobimo obrazec.
  fields <- get.fields(session)
  # Preberemo obrazec.
  form_html <- read.panel(fields, "ctl00_cphMain_up")
  # Preberemo seznam enot.
  units <- form_html %>%
    html_nodes(xpath="//select[@name='ctl00$cphMain$rvMain$ctl04$ctl09$ddValue']/option") %>%
    .[-1] %>% html_text()
  # Podatke za naslednji zahtevek pridobimo na novo.
  session$data <- NULL
  session <- session %>% get.inputs(form_html) %>% get.session(fields)
  # Nastavimo parametre za pridobivanje poročil.
  session$data["ctl00$cphMain$rvMain$ctl04$ctl07$ddValue"] <- type.id
  session$data["ctl00$cphMain$rvMain$ctl04$ctl11$ddValue"] <- year.id
  session$data["ctl00$cphMain$rvMain$ctl04$ctl13$txtValue"] <- "Poročilo ni večjega obsega"
  # Za vrsto dogodka, skupino dogodka, občino in aktivnost vzamemo vse vrednosti.
  for (id in c("03", "05", "15", "17")) {
    session$data[sprintf("ctl00$cphMain$rvMain$ctl04$ctl%s$txtValue", id)] <- form_html %>%
      html_nodes(xpath=sprintf("//div[@id='ctl00_cphMain_rvMain_ctl04_ctl%s_divDropDown']//label",
                               id)) %>%
      .[-1] %>% html_text() %>% { gsub(" +$", "", .) } %>% paste(collapse = "; ")
  }
  # Pripravimo seznam razpredelnic.
  tables <- list()
  # Če nismo podali seznama enot, vzamemo vse enote.
  if (is.null(unit.ids)) {
    unit.ids <- 1:length(units)
  }
  for (i in unit.ids) {
    # Nastavimo parametre za pridobivanje pregledovalnika poročil.
    session$data["ctl00$scMain"] <- "ctl00$scMain|ctl00$cphMain$rvMain$ctl04$ctl00"
    session$data["__EVENTTARGET"] <- NA
    session$data["ctl00$cphMain$rvMain$ctl10"] <- NA
    session$data["ctl00$cphMain$rvMain$ctl04$ctl09$ddValue"] <- as.character(i)
    # Pridobimo pregledovalnik poročil.
    fields <- get.fields(session)
    form_html <- read.panel(fields, "ctl00_cphMain_rvMain_ReportViewer")
    session <- session %>% get.inputs(form_html) %>% get.session(fields)
    # Nastavimo parametre za pridobivanje prve strani poročila.
    session$data["ctl00$scMain"] <- "ctl00$scMain|ctl00$cphMain$rvMain$ctl09$Reserved_AsyncLoadTarget"
    session$data["__EVENTTARGET"] <- "ctl00$cphMain$rvMain$ctl09$Reserved_AsyncLoadTarget"
    session$data["ctl00$cphMain$rvMain$ctl10"] <- "ltr"
    # Pridobimo prvo stran poročila.
    fields <- get.fields(session, exclude = "ctl00$cphMain$rvMain$ctl04$ctl00")
    session <- session %>% get.session(fields)
    # Preberemo prvo tabelo v poročilu.
    table <- read.panel(fields, "ctl00_cphMain_rvMain_ctl09_ReportArea") %>%
      html_nodes(xpath="//table[@cols='3']") %>% .[[1]] %>% html_table() %>% .[, 2:3]
    # Nastavimo imena stolpcev in enoto.
    colnames(table) <- c("aktivnost", "stevilo")
    table$enota <- units[i]
    # Pobrišemo odvečne vrstice.
    if (nrow(table) > 3) {
      table <- table[3:(nrow(table)-1), ]
    } else {
      table <- table[NULL, ]
    }
    # Dodamo razpredelnico v seznam.
    tables[[i]] <- table
  }
  # Vrnemo združeno razpredelnico.
  return(bind_rows(tables))
}
#write_csv(get.reports(), "podatki/vrste intervencij po drustvih.csv")

# Funkcija, ki uvozi občine iz Wikipedije
uvozi.obcine <- function() {
  link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
  stran <- html_session(link) %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
    .[[1]] %>% html_table(dec = ",")
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na = "-", locale = sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}



# Funkcije, ki uvozijo podatke iz datoteke pozari po urah.csv
uvozi.pozari.po.urah <- function() {
  pozari.cas <- read_csv("podatki/pozari po urah.csv", skip = 10,
                    locale = locale(encoding = "UTF-8")) 
  return(pozari.cas)
}

uvozi.pozarne.intervencije <- function() {
  pozari.vrsta <- read_csv("podatki/pozarne intervencije.csv", skip = 7, n_max = 221,
                   locale = locale(encoding = "UTF-8"))
  return(pozari.vrsta)
}


#SPODNJE VRSTICE NE POGANJAJ VEDNO, PORABI OGROMNO ČASA!!!!
#
#write_csv(get.reports(), "podatki/vrste intervencij po drustvih.csv")

# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
