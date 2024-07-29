# Machine learning doesn't like numbers that aren't nice and normalized. Also, if it's not a number (e.g nominal or ordinal string values), it generally should be.

library(ggplot2)
library(dplyr)

# 1. Read the census data
census <- read.csv("census_us.csv")

# Let's look at the dataset roughly
head(census)

# Which attributes are numeric?
nums <- sapply(census, is.numeric)
num_atts <- names(nums[nums])

# Let's see the range of numeric attributes
apply(census[, num_atts], 2, range)

# Let's see the standard deviation of numeric attributes
apply(census[, num_atts], 2, sd)

# Visualize Age vs Capital Gain, with untransformed data
ggplot(census) + 
  geom_point(aes(x = age, y = capital.gain)) + 
  ggtitle("Age vs Capital Gain") + 
  xlab("Age")

# For now, let's just keep the attributes we are going to transform
num_census <- census[, num_atts]

# 2. Transform your data
# 2.1. Normalize your data
normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
census.norm <- as.data.frame(apply(num_census, 2, normalize))

# Check the range of normalized data (should be between 0 and 1)
apply(census.norm, 2, range)

# 2.2. Some stats techniques like PCA require us standardize our data (i.e turn the data to be centered around 0, with a mean of 0 and a stdev of 1). We can do this with scale():
census.stand <- as.data.frame(scale(num_census))

# Take a look at your results
apply(census.stand, 2, mean)
apply(census.stand, 2, sd)

ggplot(census.stand) + 
  geom_point(aes(x = age, y = capital.gain)) + 
  ggtitle("Age vs Capital Gain")

# 3. Let's see when we look at adding another dataset
# 3.1. Dr. Michael has fooled us once again by fabricating the so-called country of "Spain" in the video. We'll just the census data from Mexico instead.
mexico <- read.csv("census_mexico.csv")

# To be able to combine them, we need to ensure that units are the same and distributions are similar
head(num_census)
head(mexico)

mexico$capital.gain <- mexico$peso.capital.gain * 3.11
mexico$capital.loss <- mexico$peso.capital.loss * 3.11 # Exchange rate on the year of collection (1994)
													 
# Let's keep the attributes that we need from each, concatenate them and study their distribution

num_census <- cbind(census[,num_atts], native.country=census$native.country)
num_mexico <- cbind(mexico[,num_atts], native.country=mexico$native.country)

united <- rbind(num_census, num_mexico)

# Let's plot a bar chart that counts values to see if our new dataset is proper. 
# There's a few values outside of the standard range, but it's mostly okay. This can be a judgement call, depending on the data.

ggplot() + 
  geom_histogram(data = united, bins = 10, aes(x = capital.gain, fill = native.country)) +
  scale_fill_discrete(name = "Country") +
  ggtitle("Histogram of Capital Gain by Country")
  
# Now with capital loss
ggplot() + 
  geom_histogram(data = united, bins = 10, aes(x = capital.loss, fill = native.country)) +
  scale_fill_discrete(name = "Country") +
  ggtitle("Histogram of Capital Loss by Country")
  
# Finally, let's take a look at ages. The distributions look about the same: a somewhat right-skewed bell curve.
ggplot() + 
  geom_histogram(data = united, bins = 10, aes(x = age, fill = native.country)) +
  scale_fill_discrete(name = "Country") +
  ggtitle("Histogram of Age by Country") 