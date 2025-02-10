library(ggplot2)   #Download the libraries you will use
library(dplyr)
library(lubridate)
library(data.table)

library(ggplot2)   
library(dplyr)
library(lubridate)
library(data.table)

# Cargar la base de datos
data <- fread("household_power_consumption.txt", sep = ";", na.strings = "?")

# Convertir la columna 'Date' a formato de fecha
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# Filtrar los datos para los días 1 y 2 de febrero de 2007
filtered_data <- data[Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")]

# Crear una nueva columna combinando Fecha y Hora en formato POSIXct
filtered_data$DateTime <- as.POSIXct(paste(filtered_data$Date, filtered_data$Time), 
                                     format="%Y-%m-%d %H:%M:%S")

# Convertir las columnas a numérico
filtered_data$Voltage <- as.numeric(filtered_data$Voltage)
filtered_data$Global_active_power <- as.numeric(filtered_data$Global_active_power)
filtered_data$Global_reactive_power <- as.numeric(filtered_data$Global_reactive_power)
filtered_data$Sub_metering_1 <- as.numeric(filtered_data$Sub_metering_1)
filtered_data$Sub_metering_2 <- as.numeric(filtered_data$Sub_metering_2)
filtered_data$Sub_metering_3 <- as.numeric(filtered_data$Sub_metering_3)

# Definir marcas de tiempo en el eje X para "Thu", "Fri" y "Sat"
tick_positions <- as.POSIXct(c("2007-02-01 00:00:00", 
                               "2007-02-02 00:00:00", 
                               "2007-02-03 00:00:00"), tz="UTC")

png(filename = "plot4.png", width = 800, height = 800)

# Configurar la disposición de los gráficos (2 filas, 2 columnas)
par(mfrow = c(2,2), mar=c(4,4,2,2))

# ---- Gráfico 1: Global Active Power ----
plot(filtered_data$DateTime, filtered_data$Global_active_power, 
     type = "l", xlab = "", ylab = "Global Active Power", xaxt = "n")                
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

# ---- Gráfico 2: Voltage ----
plot(filtered_data$DateTime, filtered_data$Voltage, 
     type = "l", col = "black", xlab = "datetime", ylab = "Voltage", xaxt="n") 
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

# ---- Gráfico 3: Energy Sub-metering ----
plot(filtered_data$DateTime, filtered_data$Sub_metering_1, 
     type = "l", col = "black", xlab = "", ylab = "Energy sub metering", xaxt = "n")
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red")
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue")
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1)

# ---- Gráfico 4: Global Reactive Power ----
plot(filtered_data$DateTime, filtered_data$Global_reactive_power, 
     type = "l", col = "black", xlab = "datetime", ylab = "Global reactive power", xaxt="n") 
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

dev.off()
