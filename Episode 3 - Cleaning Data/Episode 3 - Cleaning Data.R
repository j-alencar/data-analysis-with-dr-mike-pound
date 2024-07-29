# Data is filthy.

# 1. Load the dataset
choco <- read.csv("choco_wprice.csv", stringsAsFactors = FALSE)

# 2. Let's look at the dataset as a whole first:
summary(choco)

# 3. Missing values - Deleting
# 3.1. Let's see how many missing values per attribute are there.
missing_values_count <- sapply(choco, function(x) sum(x == "" | is.na(x))) # That is, the sum of every blank or N/A value
print(missing_values_count)

# 3.2. Now, let's see the proportion of values that are empty. "Bean.Type" is quite offending. 
# As a rule of thumb, an attribute with over 50, maybe 60% missing data is a candidate for deletion in a static dataset.
missing_values_proportion <- sapply(choco, function(x) sum(x == "" | is.na(x)) / nrow(choco))
print(missing_values_proportion)

# 3.3. For the sake of practice, let's delete attributes which are missing 50% or more of their values.
atts_to_delete <- which(missing_values_proportion >= 0.5)
choco <- choco[, -atts_to_delete]

# 4. Missing values replacing
# Now, let's go back to our attributes and see if there are any whose values can be estimated
# We could replace with 0, replace with mean, or replace with median.

# For example, look at Bar.Price. 30% of the values are missing, so we could try to estimate them, but 0 would be the worst possible replacement.
# So, replacing it with the mean is better:

choco$Bar.Price[is.na(choco$Bar.Price)] <- mean(choco$Bar.Price, na.rm = TRUE)

# We can also apply stratified replacement. Let's look at Rating
sum(is.na(choco$Rating)) # The missing ratings
# We can estimate their rating according to the median result obtained by the company. For example:
per_comp = aggregate(choco$Rating, by=list(choco$Company), na.rm=TRUE, median)
colnames(per_comp) = c("Company", "MRating")

# Let's replace some values manually
choco$Rating[is.na(choco$Rating) & choco$Company == "Vicuna"] <- per_comp$Rating[per_comp$Company == "Vicuna"]
choco$Rating[is.na(choco$Rating) & choco$Company == "Zokoko"] <- per_comp$Rating[per_comp$Company == "Zokoko"]
choco$Rating[is.na(choco$Rating) & choco$Company == "Videri"] <- per_comp$Rating[per_comp$Company == "Videri"]

# 5. Outliers
boxplot(choco$Cocoa.Percent) 
# We can see possible outliers here. In a boxplot, R will show values more than three stdevs away from the median as outliers. 
# Could these really be of extremely high/low quality or simply anomalies? Judgment call!