library(rvest)

# A
uvozi.naselja.na.A <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(A)"
  stran <- html_session(link) %>% read_html()
  tabela.A <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
      html_text()
  naselja <- tabela.A[c(TRUE, FALSE)]
  obcine <- tabela.A[c(FALSE, TRUE)]
  tabela.AA <- data.frame(naselja, obcine)
  tabela.AAA <- mutate_all(tabela.AA, funs(toupper))
  return(tabela.AAA)
}
tabela.A = uvozi.naselja.na.A()

# B
uvozi.naselja.na.B <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(B)"
  stran <- html_session(link) %>% read_html()
  tabela.B <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.B[c(TRUE, FALSE)]
  obcine <- tabela.B[c(FALSE, TRUE)]
  tabela.BB <- data.frame(naselja, obcine)
  tabela.BBB <- mutate_all(tabela.BB, funs(toupper))
  return(tabela.BBB)
}
tabela.B = uvozi.naselja.na.B()

# C
uvozi.naselja.na.C <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(C)"
  stran <- html_session(link) %>% read_html()
  tabela.C <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.C[c(TRUE, FALSE)]
  obcine <- tabela.C[c(FALSE, TRUE)]
  tabela.CC <- data.frame(naselja, obcine)
  tabela.CCC <- mutate_all(tabela.CC, funs(toupper))
  return(tabela.CCC)
}
tabela.C = uvozi.naselja.na.C()

# Č
uvozi.naselja.na.Č <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(Č)"
  stran <- html_session(link) %>% read_html()
  tabela.Č <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.Č[c(TRUE, FALSE)]
  obcine <- tabela.Č[c(FALSE, TRUE)]
  tabela.ČČ <- data.frame(naselja, obcine)
  tabela.ČČČ <- mutate_all(tabela.ČČ, funs(toupper))
  return(tabela.ČČČ)
}
tabela.Č = uvozi.naselja.na.Č()

# D
uvozi.naselja.na.D <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(D)"
  stran <- html_session(link) %>% read_html()
  tabela.D <- stran %>% html_nodes(css =  'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)') %>%
    html_text()
  naselja <- tabela.D[c(TRUE, FALSE)]
  obcine <- tabela.D[c(FALSE, TRUE)]
  tabela.DD <- data.frame(naselja, obcine)
  tabela.DDD <- mutate_all(tabela.DD, funs(toupper))
  return(tabela.DDD)
}
tabela.D = uvozi.naselja.na.D()

# E
uvozi.naselja.na.E <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(E)"
  stran <- html_session(link) %>% read_html()
  tabela.E <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.E[c(TRUE, FALSE)]
  obcine <- tabela.E[c(FALSE, TRUE)]
  tabela.EE <- data.frame(naselja, obcine)
  tabela.EEE <- mutate_all(tabela.EE, funs(toupper))
  return(tabela.EEE)
}
tabela.E = uvozi.naselja.na.E()

# F
uvozi.naselja.na.F <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(F)"
  stran <- html_session(link) %>% read_html()
  tabela.F <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.F[c(TRUE, FALSE)]
  obcine <- tabela.F[c(FALSE, TRUE)]
  tabela.FF <- data.frame(naselja, obcine)
  tabela.FFF <- mutate_all(tabela.FF, funs(toupper))
  return(tabela.FFF)
}
tabela.F = uvozi.naselja.na.F()

# G
uvozi.naselja.na.G <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(G)"
  stran <- html_session(link) %>% read_html()
  tabela.G <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.G[c(TRUE, FALSE)]
  obcine <- tabela.G[c(FALSE, TRUE)]
  tabela.GG <- data.frame(naselja, obcine)
  tabela.GGG <- mutate_all(tabela.GG, funs(toupper))
  return(tabela.GGG)
}
tabela.G = uvozi.naselja.na.G()

# H
uvozi.naselja.na.H <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(H)"
  stran <- html_session(link) %>% read_html()
  tabela.H <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.H[c(TRUE, FALSE)]
  obcine <- tabela.H[c(FALSE, TRUE)]
  tabela.HH <- data.frame(naselja, obcine)
  tabela.HHH <- mutate_all(tabela.HH, funs(toupper))
  return(tabela.HHH)
}
tabela.H = uvozi.naselja.na.H()

# I
uvozi.naselja.na.I <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(I)"
  stran <- html_session(link) %>% read_html()
  tabela.I <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.I[c(TRUE, FALSE)]
  obcine <- tabela.I[c(FALSE, TRUE)]
  tabela.II <- data.frame(naselja, obcine)
  tabela.III <- mutate_all(tabela.II, funs(toupper))
  return(tabela.III)
}
tabela.I = uvozi.naselja.na.I()

# J
uvozi.naselja.na.J <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(J)"
  stran <- html_session(link) %>% read_html()
  tabela.J <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.J[c(TRUE, FALSE)]
  obcine <- tabela.J[c(FALSE, TRUE)]
  tabela.JJ <- data.frame(naselja, obcine)
  tabela.JJJ <- mutate_all(tabela.JJ, funs(toupper))
  return(tabela.JJJ)
}
tabela.J = uvozi.naselja.na.J()

# K
uvozi.naselja.na.K <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(K)"
  stran <- html_session(link) %>% read_html()
  tabela.K <- stran %>% html_nodes(css =  'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)') %>%
    html_text()
  naselja <- tabela.K[c(TRUE, FALSE)]
  obcine <- tabela.K[c(FALSE, TRUE)]
  tabela.KK <- data.frame(naselja, obcine)
  tabela.KKK <- mutate_all(tabela.KK, funs(toupper))
  return(tabela.KKK)
}
tabela.K = uvozi.naselja.na.K()

# L
uvozi.naselja.na.L <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(L)"
  stran <- html_session(link) %>% read_html()
  tabela.L <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.L[c(TRUE, FALSE)]
  obcine <- tabela.L[c(FALSE, TRUE)]
  tabela.LL <- data.frame(naselja, obcine)
  tabela.LLL <- mutate_all(tabela.LL, funs(toupper))
  return(tabela.LLL)
}
tabela.L = uvozi.naselja.na.L()

# M
uvozi.naselja.na.M <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(M)"
  stran <- html_session(link) %>% read_html()
  tabela.M <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.M[c(TRUE, FALSE)]
  obcine <- tabela.M[c(FALSE, TRUE)]
  tabela.MM <- data.frame(naselja, obcine)
  tabela.MMM <- mutate_all(tabela.MM, funs(toupper))
  return(tabela.MMM)
}
tabela.M = uvozi.naselja.na.M()

# N
uvozi.naselja.na.N <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(N)"
  stran <- html_session(link) %>% read_html()
  tabela.N <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.N[c(TRUE, FALSE)]
  obcine <- tabela.N[c(FALSE, TRUE)]
  tabela.NN <- data.frame(naselja, obcine)
  tabela.NNN <- mutate_all(tabela.NN, funs(toupper))
  return(tabela.NNN)
}
tabela.N = uvozi.naselja.na.N()

# O
uvozi.naselja.na.O <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(O)"
  stran <- html_session(link) %>% read_html()
  tabela.O <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.O[c(TRUE, FALSE)]
  obcine <- tabela.O[c(FALSE, TRUE)]
  tabela.OO <- data.frame(naselja, obcine)
  tabela.OOO <- mutate_all(tabela.OO, funs(toupper))
  return(tabela.OOO)
}
tabela.O = uvozi.naselja.na.O()

# P
uvozi.naselja.na.P <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(P)"
  stran <- html_session(link) %>% read_html()
  tabela.P <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.P[c(TRUE, FALSE)]
  obcine <- tabela.P[c(FALSE, TRUE)]
  tabela.PP <- data.frame(naselja, obcine)
  tabela.PPP <- mutate_all(tabela.PP, funs(toupper))
  return(tabela.PPP)
}
tabela.P = uvozi.naselja.na.P()

# R
uvozi.naselja.na.R <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(R)"
  stran <- html_session(link) %>% read_html()
  tabela.R <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.R[c(TRUE, FALSE)]
  obcine <- tabela.R[c(FALSE, TRUE)]
  tabela.RR <- data.frame(naselja, obcine)
  tabela.RRR <- mutate_all(tabela.RR, funs(toupper))
  return(tabela.RRR)
}
tabela.R = uvozi.naselja.na.R()

# S
uvozi.naselja.na.S <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(S)"
  stran <- html_session(link) %>% read_html()
  tabela.S <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.S[c(TRUE, FALSE)]
  obcine <- tabela.S[c(FALSE, TRUE)]
  tabela.SS <- data.frame(naselja, obcine)
  tabela.SSS <- mutate_all(tabela.SS, funs(toupper))
  return(tabela.SSS)
}
tabela.S = uvozi.naselja.na.S()

# Š
uvozi.naselja.na.Š <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(Š)"
  stran <- html_session(link) %>% read_html()
  tabela.Š <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.Š[c(TRUE, FALSE)]
  obcine <- tabela.Š[c(FALSE, TRUE)]
  tabela.ŠŠ <- data.frame(naselja, obcine)
  tabela.ŠŠŠ <- mutate_all(tabela.ŠŠ, funs(toupper))
  return(tabela.ŠŠŠ)
}
tabela.Š = uvozi.naselja.na.Š()

# T
uvozi.naselja.na.T <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(T)"
  stran <- html_session(link) %>% read_html()
  tabela.T <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.T[c(TRUE, FALSE)]
  obcine <- tabela.T[c(FALSE, TRUE)]
  tabela.TT <- data.frame(naselja, obcine)
  tabela.TTT <- mutate_all(tabela.TT, funs(toupper))
  return(tabela.TTT)
}
tabela.T = uvozi.naselja.na.T()

# U
uvozi.naselja.na.U <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(U)"
  stran <- html_session(link) %>% read_html()
  tabela.U <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.U[c(TRUE, FALSE)]
  obcine <- tabela.U[c(FALSE, TRUE)]
  tabela.UU <- data.frame(naselja, obcine)
  tabela.UUU <- mutate_all(tabela.UU, funs(toupper))
  return(tabela.UUU)
}
tabela.U = uvozi.naselja.na.U()

# V
uvozi.naselja.na.V <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(V)"
  stran <- html_session(link) %>% read_html()
  tabela.V <- stran %>% html_nodes(css = 'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.V[c(TRUE, FALSE)]
  obcine <- tabela.V[c(FALSE, TRUE)]
  tabela.VV <- data.frame(naselja, obcine)
  tabela.VVV <- mutate_all(tabela.VV, funs(toupper))
  return(tabela.VVV)
}
tabela.V = uvozi.naselja.na.V()

# Z
uvozi.naselja.na.Z <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(Z)"
  stran <- html_session(link) %>% read_html()
  tabela.Z <- stran %>% html_nodes(css =  'td:nth-child(2) , td:nth-child(2) , td:nth-child(1)') %>%
    html_text()
  naselja <- tabela.Z[c(TRUE, FALSE)]
  obcine <- tabela.Z[c(FALSE, TRUE)]
  tabela.ZZ <- data.frame(naselja, obcine)
  tabela.ZZZ <- mutate_all(tabela.ZZ, funs(toupper))
  return(tabela.ZZZ)
}
tabela.Z = uvozi.naselja.na.Z()

# Ž
uvozi.naselja.na.Ž <- function(){
  link <- "https://sl.wikipedia.org/wiki/Seznam_naselij_v_Sloveniji_(Ž)"
  stran <- html_session(link) %>% read_html()
  tabela.Ž <- stran %>% html_nodes(css = 'td:nth-child(4) , td:nth-child(1)' ) %>%
    html_text()
  naselja <- tabela.Ž[c(TRUE, FALSE)]
  obcine <- tabela.Ž[c(FALSE, TRUE)]
  tabela.ŽŽ <- data.frame(naselja, obcine)
  tabela.ŽŽŽ <- mutate_all(tabela.ŽŽ, funs(toupper))
  return(tabela.ŽŽŽ)
}
tabela.Ž = uvozi.naselja.na.Ž()

# tabela naselji in občin ki jo bomo potrebovali za grafično analizo
tabela.naselji =bind_rows(tabela.A, tabela.B, tabela.C, tabela.Č, tabela.D, tabela.E, tabela.F, tabela.G, tabela.H, tabela.I, tabela.J, tabela.K, tabela.L, tabela.M, tabela.N, tabela.O, tabela.P, tabela.R, tabela.S, tabela.Š, tabela.T, tabela.U, tabela.V, tabela.Z, tabela.Ž)
View(tabela.naselji)