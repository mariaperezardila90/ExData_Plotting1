library(ggplot2)   #Download the libraries you will use
library(dplyr)
library(lubridate)
library(data.table)

# Load the dataset
data <- fread("household_power_consumption.txt", sep = ";", na.strings = "?")

# Convert 'Date' column to Date format
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# Filter data for the specific dates: February 1 and 2, 2007
filtered_data <- data[Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")]


# Combine 'Date' and 'Time' into a single POSIXct DateTime column
filtered_data$DateTime <- as.POSIXct(paste(filtered_data$Date, filtered_data$Time), format="%Y-%m-%d %H:%M:%S")

# Convert 'Global_active_power' to numeric
filtered_data$Global_active_power <- as.numeric(filtered_data$Global_active_power)

# Define tick marks for Thu, Fri, and Sat
tick_positions <- as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"))

# Open PNG device with required dimensions
png(filename = "plot2.png", width = 480, height = 480)


# Create the line plot
plot(filtered_data$DateTime, filtered_data$Global_active_power, 
     type = "l",                # Line plot
     xlab = "",                 # No x-axis label
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n")                # Suppress default x-axis labels


# Add custom x-axis with "Thu", "Fri", "Sat"
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

# Close PNG device
dev.off()
