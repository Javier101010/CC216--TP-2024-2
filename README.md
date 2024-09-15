# HOTEL BOOKING
## Proyecto de Ciencia de Datos

### Grupo: 1

### Integrantes
- Marcelo Paolo Murguía Lozano       (u202013543)                                            
- Renee Enriquez Montalvan           (U202221447)                                                 
- Wendy Carol Hernández Pérez        (U202422529)

   
### Índice

1. Introducción
2. Casos de Análisis  
   2.1. Origen de los datos  
   2.2. Casos de Uso Aplicables  
   2.3. Preguntas Clave para el Análisis Exploratorio
3. Data Set  
   3.1. Descripción del Data Set
4. Análisis Exploratorio de Datos


## Variables

| Variables | Columna 1 | Columna 2 |
| --------- | --------- | --------- |
| V1        | Dato 1    | Dato 2    |
| V2        | Dato A    | Dato B    |


## Codigo

Script de R para la manipulacion y limpieza de datos.

```
rm(list=ls(all=TRUE))
graphics.off()
cat("\014")

library(ggplot2)
library(cowplot)
library(patchwork)
library(gridExtra)

mtcars

mtcars<-mtcars

head(mtcars)

summary(mtcars$hp)

##Historigrama
p1<-ggplot(data = mtcars,
           mapping = aes(x = hp)) +
  geom_histogram(aes(y=..density..),
                 bins = 15,
                 position = 'identity',
                 alpha = 0.8,
                 color="white",
                 fill="lightskyblue3") +
  stat_function(fun = dnorm,
                args = list(mean = mean(mtcars$hp),
                            sd = sd(mtcars$hp)))+
  labs(title = 'Histograma',
       x = 'Potencia (Caballos de fuerza - HP)',
       y = 'conteos',
       subtitle = 'Detectar valores atípicos',
       caption = 'Fuente:MPG')
p1
```


