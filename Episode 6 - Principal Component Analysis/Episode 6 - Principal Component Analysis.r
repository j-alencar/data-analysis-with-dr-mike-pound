library(ggplot2)
library(dplyr)

# 0. Same approach to the csv as in the previous episode:
header <- read.csv("echonest.csv", header = FALSE, nrows = 4)
echonest <- read.csv("echonest.csv", skip = 4, header = FALSE)
combined_header <- apply(header, 2, function(col) paste(col, collapse = "_"))
unique_combined_header <- make.unique(combined_header)
colnames(echonest) <- unique_combined_header
colnames(echonest)[1] <- "track_id"

track_genres <- read.csv("track_genres.csv")
echonest <- left_join(echonest, track_genres, by = "track_id")

# 1. Don't forget to standardise your data
numeric_columns <- echonest[, sapply(echonest, is.numeric)]
echonest_with_genres <- echonest %>%
  select(track_id, genre_parent, everything()) # Ensure track_id and genre_parent are included

scaled_numeric <- scale(numeric_columns)
echonest.std <- as.data.frame(scaled_numeric)

# Ensure rows with missing values are omitted before PCA
complete_data <- echonest_with_genres[complete.cases(echonest.std), ]

# 2. Apply PCA
pca <- prcomp(echonest.std[complete.cases(echonest.std), ], scale = TRUE)

summary(pca)
# Scroll down to see the cumulative proportion of variance reach 99% at some PC. For dimensionality reduction, cutting off at this point is common practice.

# 3. How about visualizing this?
proj <- as.data.frame(pca$x)

# Add genre information to projection
proj$track_id <- complete_data$track_id
proj <- left_join(proj, echonest_with_genres %>% select(track_id, genre_parent), by = "track_id")

# Rename genre column for consistency
colnames(proj)[colnames(proj) == "genre_parent"] <- "genre"

# Plot the full dataset
ggplot(proj) +
  geom_point(aes(x = PC1, y = PC2, color = genre)) +
  labs(x = "Principal Component 1", y = "Principal Component 2", color = "Genre")

# Let's compare a few genres in PC1 and PC2
proj2 <- proj %>% filter(genre %in% c("Rock", "Electronic", "Folk"))

# Plot for specific genres
ggplot(proj2) +
  geom_point(aes(x = PC1, y = PC2, color = genre)) +
  labs(x = "Principal Component 1", y = "Principal Component 2", color = "Genre")
