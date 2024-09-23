rm(list=ls(all=TRUE))
graphics.off()
cat("\014")

##Leer el csv
setwd("D:/Downloads/TB1")
hotel_data <-read.csv('hotel_bookings.csv', header=TRUE, sep=',',dec='.',stringsAsFactors = FALSE,,na.strings="")

View(hotel_data)
names(hotel_data)
str(hotel_data)
summary(hotel_data)

hotel_data$hotel <- as.factor(hotel_data$hotel)
hotel_data$is_canceled <- as.factor(hotel_data$is_canceled)
hotel_data$arrival_date_year <- as.factor(hotel_data$arrival_date_year)
hotel_data$arrival_date_month <- as.factor(hotel_data$arrival_date_month)
hotel_data$meal <- as.factor(hotel_data$meal)
hotel_data$country <- as.factor(hotel_data$country)
hotel_data$market_segment <- as.factor(hotel_data$market_segment)
hotel_data$distribution_channel <- as.factor(hotel_data$distribution_channel)
hotel_data$is_repeated_guest <- as.factor(hotel_data$is_repeated_guest)
hotel_data$reserved_room_type <- as.factor(hotel_data$reserved_room_type)
hotel_data$assigned_room_type <- as.factor(hotel_data$assigned_room_type)
hotel_data$deposit_type <- as.factor(hotel_data$deposit_type)
hotel_data$company <- as.factor(hotel_data$company)
hotel_data$agent <- as.factor(hotel_data$agent)
hotel_data$customer_type <- as.factor(hotel_data$customer_type)
hotel_data$reservation_status <- as.factor(hotel_data$reservation_status)
hotel_data$reservation_status_date <- as.Date(hotel_data$reservation_status_date)


##analisis de datos para ver si tienen datos nulos o datos que no se comprenden facilmente
summary(hotel_data)
summary(hotel_data$country) ## necesita limpieza
summary(hotel_data$arrival_date_month)
summary(hotel_data$stays_in_weekend_nights) ## datos atipicos tiene definittivamente
summary(hotel_data$meal) ## necesita limpieza
summary(hotel_data$market_segment) ## necesita limpieza
summary(hotel_data$distribution_channel) ## necesita limpieza
summary(hotel_data$reserved_room_type)
summary(hotel_data$assigned_room_type)
summary(hotel_data$company)## el valor null probablemente no sea un problema
summary(hotel_data$agent) ## el valor null probablemente no sea un problema


hotel_data[rowSums(hotel_data == "") > 0, ]
con_na <- function(x){
  sum = 0
  for(i in 1:ncol(x))
  {
    cat("En la columna",colnames(x[i]),"total de valores NA:",colSums(is.na(x[i])),"\n")
  }
}

verificar_undefined(hotel_data)

##borrar valores na en children, undefined en market segment, undefined en meal, undefinied en distribution channel

##Cambia el null de agent y company por otro dato para que no afecte a la larga
cambiar_null_por_otro <- function(df, valor_reemplazo) {
  columnas <- c("company", "agent")
  
  for (col in columnas) {
    if (col %in% colnames(df)) {

      df[[col]] <- as.character(df[[col]])
      

      df[[col]][df[[col]] == "NULL"] <- valor_reemplazo
    }
  }
  

  df$company <- as.factor(df$company)
  df$agent <- as.factor(df$agent)
  
  return(df)
}

hotel_data <- cambiar_null_por_otro(hotel_data, "0")

##ignorar esto no funciono es debido a que no lo considera na las 4 filas que dicen na enn children
hotel_data_sin_na <- na.omit(hotel_data)
View(hotel_data_limpio)
na.omit(hotel_data_sin_na$children)
summary(hotel_data_sin_na)
##Borro manual de las 4 filas con children NA
hotel_data_sin_na <- hotel_data[-c(40601, 40668,40680,41161), ]
##borro de las filas con Undefined
hotel_data_sin_na_1 <- hotel_data_sin_na[hotel_data$meal != "Undefined", ]
##se hizo manual porque un codigo similar daba error y encima devolvia los otros
hotel_data_sin_undentified <- hotel_data_sin_na_1[-c(14595), ]

##se considero eliminnar filas con week nights y weekends en 0 por quue no tiene logica que eso sea posible
eliminar_filas_invalidas <- function(df) {

  filas_invalidas <- df$stays_in_week_nights == 0 & df$stays_in_weekend_nights == 0

  df <- df[!filas_invalidas, ]

  return(df)
}

hotel_data_sinf<- eliminar_filas_invalidas(hotel_data_sin_undentified)

verificar_adultos <- function(df) {
  any(df$adults == 0)
}
## Esto es para eliminar el caso que hay filas que tienen como registro 0 adultos lo cual no tiene logica
verificar_adultos(hotel_data_sinf)

hotel_data_limpio <- hotel_data_sinf[hotel_data_sinf$adults != 0, ]

verificar_adultos(hotel_data_limpio)

hotel_data_limpio <- na.omit(hotel_data_limpio)

hotel_data_limpio$children <- as.numeric(hotel_data_limpio$children) 

summary(hotel_data_limpio)

library(ggplot2)
library(cowplot)
library(patchwork)
##Analizando manualmente los valores numericos  vemos que lead time, arrival_date_week_number, arrival_date_day_of_month, stays in weekend night , stayss in week nights ,adults, childrenn, babies 
ggplot(hotel_data_limpio, aes(y = lead_time)) + 
  geom_boxplot() + 
  ggtitle("Lead Time")

ggplot(hotel_data_limpio, aes(y = stays_in_weekend_nights)) + 
  geom_boxplot() + 
  ggtitle( "Weekend Nights")


ggplot(hotel_data_limpio, aes(y = stays_in_week_nights)) + 
  geom_boxplot() + 
  ggtitle( "Week Nights")


ggplot(hotel_data_limpio, aes(y = adults)) + 
  geom_boxplot() + 
  ggtitle("Adults")


ggplot(hotel_data_limpio, aes(y = children)) + 
  geom_boxplot() + 
  ggtitle("Children")


ggplot(hotel_data_limpio, aes(y = babies)) + 
  geom_boxplot() + 
  ggtitle("Babies")

ggplot(hotel_data_limpio, aes(y = adr)) + 
  geom_boxplot() + 
  ggtitle("Average Daily Rate)")


ggplot(hotel_data_limpio, aes(y = previous_cancellations)) + 
  geom_boxplot() + 
  ggtitle("Previous Cancellations")


ggplot(hotel_data_limpio, aes(y = previous_bookings_not_canceled)) + 
  geom_boxplot() + 
  ggtitle(" Previous Bookings Not Canceled")

ggplot(hotel_data_limpio, aes(y = days_in_waiting_list)) + 
  geom_boxplot() + 
  ggtitle(" Days in Waiting List")

# Usando el método del IQR para detectar y eliminar outliers en 'Lead Time'
Q1 <- quantile(hotel_data_limpio$lead_time, 0.25)
Q3 <- quantile(hotel_data_limpio$lead_time, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
##Aplicar límites

hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$lead_time >=lower_bound & hotel_data_limpio$lead_time <= upper_bound,]

##Visualizaremos la variable 
par(mfrow = c(1,2))
boxplot(hotel_data_limpio$lead_time, main = "Lead Time con outliers",col = 3)
boxplot(hotel_data_clean$lead_time, main = "Lead Time sin outliers",col=2)

# Usando el método del IQR para detectar y eliminar outliers en 'stays_in_weekend_night'
Q1 <- quantile(hotel_data_limpio$stays_in_weekend_night, 0.25)
Q3 <- quantile(hotel_data_limpio$stays_in_weekend_night, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
##Aplicar límites

hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$stays_in_weekend_night >=lower_bound & hotel_data_limpio$stays_in_weekend_night <= upper_bound,]

##Visualizaremos la variable 
par(mfrow = c(1,2))
boxplot(hotel_data_limpio$stays_in_weekend_night, main = "Stays in weekend_night con outliers",col = 3)
boxplot(hotel_data_clean$stays_in_weekend_night, main = "Stays in weekend_night sin outliers",col=2)

# Usando el método del IQR para detectar y eliminar outliers en 'stays_in_week_nights'
Q1 <- quantile(hotel_data_limpio$stays_in_week_nights, 0.25)
Q3 <- quantile(hotel_data_limpio$stays_in_week_nights, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR
##Aplicar límites

hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$stays_in_week_nights >=lower_bound & hotel_data_limpio$stays_in_week_nights <= upper_bound,]

##Visualizaremos la variable 
par(mfrow = c(1,2))
boxplot(hotel_data_limpio$stays_in_week_nights, main = "stays_in_week_nights con outliers",col = 3)
boxplot(hotel_data_clean$stays_in_week_nights, main = "stays_in_week_nights sin outliers",col=2)

# Usando el método del IQR para detectar y eliminar outliers en 'Adults'
Q1 <- quantile(hotel_data_limpio$adults, 0.25)
Q3 <- quantile(hotel_data_limpio$adults, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Aplicar limites
hotel_data_clean<- hotel_data_limpio[hotel_data_limpio$adults >= lower_bound & hotel_data_limpio$adults <= upper_bound,]

##Visualizaremos la variable 
par(mfrow = c(1,2))
boxplot(hotel_data_limpio$adults, main = "Adults con outliers", col = 3)
boxplot(hotel_data_clean$adults, main = "Adults sin outliers", col = 2)

# Usando el método del IQR para detectar y eliminar outliers en 'Children'
Q1 <- quantile(hotel_data_limpio$children, 0.25)
Q3 <- quantile(hotel_data_limpio$children, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR


# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$children >= lower_bound & hotel_data_limpio$children <= upper_bound,]

##Visualizaremos la variable 
boxplot(hotel_data_limpio$children, main = "Children con outliers", col = 3)
boxplot(hotel_data_clean$children, main = "Children sin outliers", col = 2)

# Usando el método del IQR para detectar y eliminar outliers en 'Babies'
Q1 <- quantile(hotel_data_limpio$babies, 0.25)
Q3 <- quantile(hotel_data_limpio$babies, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR


# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$babies >= lower_bound & hotel_data_limpio$babies <= upper_bound,]

##Visualizaremos la variable
boxplot(hotel_data_limpio$babies, main = "Babies con outliers", col = 3)
boxplot(hotel_data_clean$babies, main = "Babies sin outliers", col = 2)


# Usando el método del IQR para detectar y eliminar outliers en 'ADR'
Q1 <- quantile(hotel_data_limpio$adr, 0.25)
Q3 <- quantile(hotel_data_limpio$adr, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR


# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$adr >= lower_bound & hotel_data_limpio$adr <= upper_bound,]

##Visualizaremos la variable
boxplot(hotel_data_limpio$adr, main = "ADR con outliers", col = 3)
boxplot(hotel_data_clean$adr, main = "ADR sin outliers", col = 2)

# Usando el método del IQR para detectar y eliminar outliers en 'Previous Cancelation'
Q1 <- quantile(hotel_data_limpio$previous_cancellations, 0.25)
Q3 <- quantile(hotel_data_limpio$previous_cancellations, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$previous_cancellations >= lower_bound & hotel_data_limpio$previous_cancellations <= upper_bound,]

##Visualizaremos la variable
boxplot(hotel_data_limpio$previous_cancellations, main = "Previous Cancellations con outliers", col = 3)
boxplot(hotel_data_clean$previous_cancellations, main = "Previous Cancellations sin outliers", col = 2)

# Usando el método del IQR para detectar y eliminar outliers en 'previous_bookings_not_canceled'
Q1 <- quantile(hotel_data_limpio$previous_bookings_not_canceled, 0.25)
Q3 <- quantile(hotel_data_limpio$previous_bookings_not_canceled, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$previous_bookings_not_canceled >= lower_bound & hotel_data_limpio$previous_bookings_not_canceled <= upper_bound,]

##Visualizaremos la variable
boxplot(hotel_data_limpio$previous_bookings_not_canceled, main = "Previous Bookings Not Canceled con outliers", col = 3)
boxplot(hotel_data_clean$previous_bookings_not_canceled, main = "Previous Bookings Not Canceled sin outliers", col = 2)

# Usando el método del IQR para detectar y eliminar outliers en 'days_in_waiting_list'
Q1 <- quantile(hotel_data_limpio$days_in_waiting_list, 0.25)
Q3 <- quantile(hotel_data_limpio$days_in_waiting_list, 0.75)
IQR <- Q3 - Q1
lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

# Aplicar limites
hotel_data_clean <- hotel_data_limpio[hotel_data_limpio$days_in_waiting_list >= lower_bound & hotel_data_limpio$days_in_waiting_list <= upper_bound,]

##Visualizaremos la variable
boxplot(hotel_data_limpio$days_in_waiting_list, main = "Days in Waiting List con outliers", col = 3)
boxplot(hotel_data_clean$days_in_waiting_list, main = "Days in Waiting List sin outliers", col = 2)
#Eliminar los graficos para luego ver las preguntas

graphics.off()

##Pregunta 1
table(hotel_data_limpio$hotel)
ggplot(hotel_data_limpio, aes(x = hotel)) +
  geom_bar(fill = "Blue") +
  labs(title = "Reservas por Tipo de Hotel", x = "Tipo de Hotel", y = "Cantidad de Reservas") +
  theme_minimal()

##Pregunta 2
table(hotel_data_limpio$arrival_date_year)
ggplot(hotel_data_limpio, aes(x = arrival_date_year)) +
  geom_bar(fill = "green") +
  labs(title = "Demanda de Reservas por Año", x = "Año", y = "Cantidad de Reservas") +
  theme_minimal()
##Pregunta 3
table(hotel_data_limpio$arrival_date_month)
ggplot(hotel_data_limpio, aes(x = factor(arrival_date_month, levels = month.name))) +
  geom_bar(fill = "orange") +
  labs(title = "Reservas por Mes", x = "Mes", y = "Cantidad de Reservas") +
  theme_minimal()
##Pregunta 5
hotel_data_limpio$with_kids <- ifelse(hotel_data_limpio$children > 0 | hotel_data_limpio$babies > 0, "Sí", "No")
table(hotel_data_limpio$with_kids )
ggplot(hotel_data_limpio, aes(x = with_kids)) +
  geom_bar(fill = "purple") +
  labs(title = "Reservas con Niños o Bebés", x = "Incluye Niños/Bebés", y = "Cantidad de Reservas") +
  theme_minimal()
##Pregunta 6 
table(hotel_data_limpio$required_car_parking_spaces )
ggplot(hotel_data_limpio, aes(x = factor(required_car_parking_spaces > 0, labels = c("No", "Sí")))) +
  geom_bar(fill = "cyan") +
  labs(title = "Reservas que Requieren Estacionamiento", x = "Requiere Estacionamiento", y = "Cantidad de Reservas") +
  theme_minimal()

write.csv(hotel_data_limpio,'df_limpio.csv',row.names = TRUE)
##Pregunta 7
ggplot(hotel_data_limpio[hotel_data_limpio$is_canceled == 1, ], aes(x = factor(arrival_date_month, levels = month.name))) +
  geom_bar(fill = "red") +
  labs(title = "Cancelaciones por Mes", x = "Mes", y = "Cantidad de Cancelaciones") +
  theme_minimal() 
View(hotel_data_limpio)
## solo para escribir el nuevo df write.csv(hotel_data_limpio,'df_limpio.csv',row.names = TRUE)
