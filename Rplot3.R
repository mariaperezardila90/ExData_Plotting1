library(ggplot2)   #Download the libraries you will use
library(dplyr)
library(lubridate)
library(data.table)

# Load necessary libraries
library(data.table)  # Efficient data handling

# Load the dataset
data <- fread("household_power_consumption.txt", sep = ";", na.strings = "?")

# Convert 'Date' column to Date format
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# Filter data for the specific dates: February 1 and 2, 2007
filtered_data <- data[Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")]

# Combine 'Date' and 'Time' into a single POSIXct DateTime column
filtered_data$DateTime <- as.POSIXct(paste(filtered_data$Date, filtered_data$Time), format="%Y-%m-%d %H:%M:%S")

# Ensure column names are correctly formatted
names(filtered_data) <- trimws(names(filtered_data))

# Convert sub-metering columns to numeric
filtered_data$Sub_metering_1 <- as.numeric(filtered_data$Sub_metering_1)
filtered_data$Sub_metering_2 <- as.numeric(filtered_data$Sub_metering_2)
filtered_data$Sub_metering_3 <- as.numeric(filtered_data$Sub_metering_3)

# Replace any NA values with 0 (optional but recommended)
filtered_data[is.na(filtered_data)] <- 0

# Define tick marks for "Thu", "Fri", and "Sat"
tick_positions <- as.POSIXct(c("2007-02-01 00:00:00", "2007-02-02 00:00:00", "2007-02-03 00:00:00"))

# Open PNG device to save the plot
png(filename = "plot3.png", width = 480, height = 480)


# Create the plot for Sub_metering_1 (black)
plot(filtered_data$DateTime, filtered_data$Sub_metering_1, 
     type = "l",                # Line plot
     col = "black",             # Black color for Sub_metering_1
     xlab = "",                 # No x-axis label
     ylab = "Energy sub metering",
     xaxt = "n")                # Suppress default x-axis labels

# Add Sub_metering_2 (red)
lines(filtered_data$DateTime, filtered_data$Sub_metering_2, col = "red")

# Add Sub_metering_3 (blue)
lines(filtered_data$DateTime, filtered_data$Sub_metering_3, col = "blue")

# Add custom x-axis labels ("Thu", "Fri", "Sat")
axis(1, at = tick_positions, labels = c("Thu", "Fri", "Sat"))

# Add legend
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), 
       lty = 1)

# Close PNG device to save the plot
dev.off()

