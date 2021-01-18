
library(dplyr)

# Load in the raw dataset
sales_data <- read.csv("./data/raw/Groceries_dataset.csv")

# Check the structure of the data
str(sales_data)

# Change the column names
names(sales_data) <- c("member", "sale_date", "product")

# Format the date column as a date
sales_data$sale_date <- as.Date(sales_data$sale_date, format = "%d-%m-%Y")


# How many unique members are there?
length(unique(sales_data$member))

# How many different products are there?
length(unique(sales_data$product))

# When are the earliest and latest sales?
min(sales_data$sale_date)
max(sales_data$sale_date)

# Are there any products that need to be merged?
View(sort(unique(sales_data$product)))
# Some words could potentially be grouped
# But in general these products seem distinct


# How many times has each product sold?
sales_data %>% group_by(product) %>% 
  summarise(times_sold = n()) %>% 
  arrange(times_sold) %>% head(15)

# Combining products with very few sales
sales_data <- sales_data %>% mutate(product = case_when(product %in% c("liqueur", "whisky") ~ "liquor",
                                                        product == "frozen chicken" ~ "chicken",
                                                        TRUE ~ product))


# Arrange the dataset by member and date
sales_data <- sales_data %>% arrange(member, sale_date)

# Create a transaction Id column
sales_data$transaction_id <- sales_data %>% group_by(member, sale_date) %>% group_indices()

# Reorder the columns
sales_data <- select(sales_data, member, transaction_id, sale_date, product)

# Save the cleaned dataset
write.csv(sales_data, "data/processed/processed_sales_data.csv", row.names = FALSE)



