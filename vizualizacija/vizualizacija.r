# 3. faza: Vizualizacija podatkov

# Uvozimo zemljevid.
zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_IME) <- levels(zemljevid$OB_IME) %>%
  { gsub("SLOV\\.", "SLOVENSKIH", .) } %>% { gsub("-", " - ", .)} %>% {gsub("SV\\.", "SVETA", .)} 
zemljevid <- fortify(zemljevid)
