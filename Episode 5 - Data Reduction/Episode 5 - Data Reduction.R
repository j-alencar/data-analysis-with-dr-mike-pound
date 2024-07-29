# We don't have all the time in the world. Let's cut down on the data a bit.

library(dplyr)
library(ggplot2)

#So, one of the .csv files we're going to work with, "features.csv", is not organized in a standard way: reading it normally would give you some rows that are actually headers. Here's what we'll do:

#1. Read first 4 rows as header info
header <- read.csv("features.csv", header = FALSE, nrows = 4)

#2. Read rest of file starting from 5th row
data <- read.csv("features.csv", skip = 4, header = FALSE) # This will take a while and hog lots of RAM

#3. Combine header information into one
combined_header <- apply(header, 2, function(col) paste(col, collapse = "_"))

#4. Handle duplicate names by assigning unique numbers
unique_combined_header <- make.unique(combined_header)

#5. Assign unique column names to data
colnames(data) <- unique_combined_header
colnames(data)[1] <- "track_id"

print(head(data))

# Dr. Michael seems to have JOINed the genre attribute to his music_all as well. Let's do the same:
track_genres <- read.csv("track_genres.csv")
music_all <- left_join(data, track_genres, by = "track_id")

# Let's randomly sample 50% of the dataset for reduction. We can use sample_frac() for that:

music_sampled <- music_all %>% 
  sample_frac(0.5)

# Analyzing genres

filtered_genres <- music_sampled %>%
  filter(genre_parent %in% c("Classical", "Pop", "International", "Spoken"))

# Plotting
ggplot(filtered_genres, aes(x = genre_parent)) +
  geom_bar() +
  ggtitle("Distribution of Genres") +
  xlab("Genre") +
  ylab("Count")
  
# Randomized sampling is a perfectly good way of selecting your data, but it has a risk: if the distributions of your genres are a bit off, or you have too little of one genre, you can't guarantee a similar distribution in the output.

# In that case, we may use *stratified* sampling: it maintains the distribution of our classes.

install.packages("splitstackshape")
library(splitstackshape)

group_sizes <- table(music_sampled$genre_parent)
total_rows <- nrow(music_sampled)
desired_proportion <- 0.5
sample_sizes <- pmin(floor(total_rows * desired_proportion / length(group_sizes)), group_sizes)

# Ensure sample_sizes is a named vector
sample_sizes <- as.numeric(sample_sizes)
names(sample_sizes) <- names(group_sizes)

# Create a data frame with genre_parent and sample sizes
sample_size_df <- data.frame(
  genre_parent = names(sample_sizes),
  sample_size = sample_sizes,
  stringsAsFactors = FALSE
)

# Join the sample size with the original data
sampled_stratified <- music_sampled %>%
  left_join(sample_size_df, by = "genre_parent") %>%
  group_by(genre_parent) %>%
  filter(row_number() <= sample_size) %>%
  select(-sample_size)  # Remove the sample_size column if no longer needed

# Print the results to check
print(sampled_stratified)

# Plotting
ggplot(sampled_stratified, aes(x = genre_parent)) +
  geom_bar() +
  ggtitle("Stratified Sampling of Genres") +
  xlab("Genre") +
  ylab("Count")
  
# Another way to reduce our data is by removing features with a high correlation via correlation analysis.

install.packages("ggcorrplot")
library(ggcorrplot)

# Let's look at some echonest features and make a correlation matrix.

# Select columns starting with "chroma_cqt_kurtosis"
cqt_k <- sampled_stratified %>%
    ungroup() %>% # Ensures that only those columns will be included
    select(starts_with("chroma_cqt_kurtosis"))

# Check the names of the selected columns
print(names(cqt_k))

# Define new names and ensure there are enough new names for columns
new_names <- paste0("kurt", 1:ncol(cqt_k))

# Rename columns
names(cqt_k) <- new_names

cor_m = cor(cqt_k)

# The correlation of each kurt attribute to another. Based on this, you can decide on whether or not removing one is worth it.
ggcorrplot(cor_m, hc.order=TRUE, type="lower", lab=TRUE)+ggtitle("Correlations within Cens_Kurtosis")

# Another route is via forward or backward attribute selection. With a machine learning algorithm in mind, we can measure its performance and keep removing or adding features in order to see if it changes.

# We've learned a lot so far, but there is still a problem with these approaches: do we *actually* want to completely remove this data? This is where Principal Component Analysis comes in.