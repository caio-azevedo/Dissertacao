# Limpar
rm(list=ls())


#Diret�rio
setwd("C:/Users/Caio Azevedo/Documents/Documentos Caio/Github/Dissertacao/Figuras")


# Pacotes
library(dplyr)
library(tidyr)
library(readxl)
library(ggplot2)



#Carregamento e configura��o dos dados----
load("C:/Users/Caio Azevedo/Documents/Documentos Caio/Github/Dissertacao/data/selecionados.rData")

#Gr�ficos----

#Configura��o
cleanup = theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_line(color = "white"),
                panel.background = element_blank(),
                legend.position = "bottom",
                axis.line = element_line(color = "black"),
                axis.title = element_text(size = 18),
                legend.text = element_text(size = 14),
                axis.text = element_text(size = 14))

cleanup1 = theme(panel.grid.major = element_blank(),
                 panel.grid.minor = element_line(color = "white"),
                 panel.background = element_blank(),
                 legend.position = "none",
                 axis.line = element_line(color = "black"),
                 axis.title = element_text(size = 24),
                 axis.text = element_text(size = 24))





# Gr�ficos Heterogeneidade
#Caso Vasco

#Configurando os dados

Vasco2017 <- base %>% filter(time=="Vasco",temporada==2017) %>%
  mutate(mt_rodada = if_else(m==1.7,rodada,NULL))

Vasco2010 <- base %>% filter(time=="Vasco",temporada==2010) %>%
  mutate(mt_rodada = if_else(m==1.7,rodada,NULL))

Vasco<-rbind(Vasco2010,Vasco2017)

Vasco<-Vasco %>% 
  mutate(Grupo=ifelse(temporada=="2010","Controle","Tratamento"))


#Gr�fico

ggplot(data=Vasco, aes(x=rodada, y=cum_surpresa, colour=Grupo)) +
  geom_line(lwd=2) + 
  geom_vline(aes(xintercept=mt_rodada, colour=Grupo),lwd=1.4) +
  xlab("Rodada") + 
  ylab("Surpresa acumulada")+
  cleanup

dev.copy(pdf,"vasco.pdf")
dev.off()

#Caso Internacional

#Configurando os dados

Internacional2009 <- base %>% filter(time=="Internacional",temporada==2009) %>%
  mutate(mt_rodada = if_else(m==1.5,rodada,NULL))

Internacional2014 <- base %>% filter(time=="Internacional",temporada==2014) %>%
  mutate(mt_rodada = if_else(m==1.5,rodada,NULL))

Internacional<-rbind(Internacional2009,Internacional2014)

Internacional<-Internacional %>% 
  mutate(Grupo=ifelse(temporada=="2014","Controle","Tratamento"))


#Gr�fico

ggplot(data=Internacional, aes(x=rodada, y=cum_surpresa, colour=Grupo)) +
  geom_line(lwd=2) + 
  geom_vline(aes(xintercept=mt_rodada, colour=Grupo),lwd=1.4) +
  xlab("Rodada") + 
  ylab("Surpresa acumulada")+
  cleanup

dev.copy(pdf,"internacional.pdf")
dev.off()





# Densidade das mudan�as 


# Configurando os dados

q <- dados %>%
  mutate(
    Mudan�a = if_else(
      !is.na(mt_antecessor) & mt_motivo=="Demitido","Demiss�es e ren�ncias",
      if_else(!is.na(mt_antecessor) & mt_motivo=="Resignado","Demiss�es e ren�ncias",
              if_else(!is.na(mt_antecessor) & mt_motivo=="Renunciado","Demiss�es e ren�ncias",      
                      if_else(is.na(mt_antecessor), "Sem trocas","Outras motiva��es")
              ))),
    tratado = if_else(!is.na(mt_antecessor),1,0)
  ) %>%
  drop_na(Mudan�a)

#Gr�fico

ggplot(data=q, aes(x=cum_surpresa,color=Mudan�a)) +  
  # definimos o tipo de geometria (gr�fico)  
  geom_density(lwd=2) +
  xlab("Surpresa Acumulada") + 
  ylab("Densidade")+cleanup1

dev.copy(pdf,"cum_surpresa.pdf")
dev.off()


#Sobreposi��o de pareamento----

ggplot(data=z, aes(x=cum_surpresa,color=Tratamento)) +  
  # definimos o tipo de geometria (gr�fico)  
  geom_density(lwd=2) +
  xlab("Surpresa Acumulada") + 
  ylab("Densidade") + cleanup1

dev.copy(pdf,"sob_surp.pdf")
dev.off()


# Desbloquear para gerar Tabela do ap�ndice
# appendix<-z %>%
# select("rodada","temporada","time","trocou","m")



#Desbloquear para Sa�da do ap�ndice ---- 
#print(xtable(appendix, caption = "Pareamento", 
#            digits = 0,
#           label = "parmatch"),
#   caption.placement = "top",
#  include.rownames = FALSE)


# Frequ�ncias 

tab<-dados %>% 
  mutate(Mudan�a = if_else(mt_motivo=="Demitido","Coach dismissals",
                           if_else(mt_motivo=="Resignado","Quits",
                                   if_else(mt_motivo=="Renunciado","Quits",      
                                           if_else(is.na(mt_antecessor), "No coach dismissals","Other reasons")
                                   )))) %>% 
  filter(trocou==1) %>% 
  group_by(temporada.x,Mudan�a) %>% 
  summarise("Frequ�ncia"=n())