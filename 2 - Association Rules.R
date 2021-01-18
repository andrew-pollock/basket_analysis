
library(dplyr)
library(arules)
library(arulesViz)


# Load in the processed data
sales_data <- read.csv("./data/processed/processed_sales_data.csv")

# Drop unneeded columns
sales_data <- sales_data %>% select(-member, -sale_date)

# Save this as a csv
write.csv(sales_data, "./data/processed/transaction_data.csv", row.names=FALSE)

# Read this csv in as a transaction dataset
basket_transactions <- read.transactions("./data/processed/transaction_data.csv", 
                                 sep=",", format = "single", cols = c(1,2),
                                 header = TRUE)

# Check my transaction dataset looks correct
basket_transactions

# What are the most common items?
itemFrequencyPlot(basket_transactions, topN = 15, xlab = "Products", ylab = "Product Frequency", 
                  main = "Most Common Products in Transaction Data")


# Relaxed rules
relaxed_rules <- apriori(basket_transactions, 
                 parameter = list(minlen=2, maxlen=6, sup = 0.001, conf = 0.005)) 
relaxed_rules


# Plotting these rules by support and confidence
plot(relaxed_rules, method= "scatterplot")
# I can use this information to filter my rules


# Given our large dataset I can use a relatively low support
# I want to prioritise confidence
refined_rules <- apriori(basket_transactions, 
                 parameter = list(minlen=2, maxlen=4, sup = 0.002, conf = 0.1)) 

# Plot these new rules by support and confidence
plot(refined_rules, method= "scatterplot")

# Inspect the new rules
inspect(refined_rules)

# I can refine this further based on lift
# Plotting the distribution of rule lift
hist(quality(refined_rules)$lift, 
     main="Distribution of Lift Across Rules",
     xlab = "Rule Lift", ylab = "Number of Rules")

# Filtering to just rules with a lift over 0.8
final_rules <- subset(refined_rules, subset = lift > 0.8)
final_rules

# Inspecting final set of rules
inspect(final_rules)

# Plotting these as a graph
plot(final_rules, method= "graph")

