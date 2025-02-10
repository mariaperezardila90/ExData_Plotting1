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

png(filename = "plot1.png", width = 480, height = 480)

# Create the histogram
ggplot(filtered_data, aes(x = Global_active_power)) +
  geom_histogram(fill = "red", color = "black", bins = 12) +
  labs(title = "Global Active Power",
       x = "Global Active Power (kilowatts)",
       y = "Frequency") +
  scale_y_continuous(breaks = seq(0, 1200, by = 200)) +  # Adjust frequency axis
  theme_minimal()

# Close PNG device
dev.off()


