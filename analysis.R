# Load required libraries
library(dplyr)
library(ggplot2)
library(readr)

# Read CSV file
data <- read_csv("data.csv")

# Define output file
output_file <- "outputs_R_5.txt"

# Function: Group by Species and Calculate Mean Weight
mean_weight_by_species <- data %>%
  group_by(Species) %>%
  summarise(Mean_Weight = mean(Weight, na.rm = TRUE))

write("Group by Species and Calculate Mean Weight:", file = output_file)
write.table(mean_weight_by_species, file = output_file, append = TRUE, sep = "\t", row.names = FALSE)

# Function: Sorting the Data by Weight
sorted_data <- data %>% arrange(desc(Weight))

write("\nSorting the Data by Weight:", file = output_file, append = TRUE)
write.table(sorted_data, file = output_file, append = TRUE, sep = "\t", row.names = FALSE)

# Function: Count the Number of Males and Females
gender_count <- data %>%
  group_by(Sex) %>%
  summarise(Count = n())

write("\nCount the Number of Males and Females:", file = output_file, append = TRUE)
write.table(gender_count, file = output_file, append = TRUE, sep = "\t", row.names = FALSE)

# Function: Plotting Weight Distribution by Sex
plot <- ggplot(data, aes(x = Sex, y = Weight)) +
  geom_boxplot(fill = "lightblue") +
  ggtitle("Weight Distribution by Sex")

ggsave("weight_distribution.png", plot)

write("\nPlot saved as weight_distribution.png", file = output_file, append = TRUE)
