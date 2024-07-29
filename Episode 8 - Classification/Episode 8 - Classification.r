# Dr. Mike uses Weka in this episode, but we want to code. Thankfully we have a library specifically for that situation: RWeka.
install.packages("RWeka")
library(RWeka)

# When you need outputs that are categorical or are based on a small amount of labels you Classify.

# 1. Decision Trees
# Decision trees will base their outputs on conditions generated on a structure with decision nodes, branches and leaf nodes.

install.packages("caret")
install.packages("data.table")
library(caret)
library(data.table)

# Let's read our dataset. Pound seems to have gotten hand of the unmasked, headerful version of the dataset. That one's not available for us, but it works the same. The last column in the .data file will show a "+" for Approved and "-" for Not Approved.
credit_data <- fread("crx.data", header = FALSE)

# Assign column names
colnames(credit_data) <- c("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12", "A13", "A14", "A15", "Class")

# Convert string attributes to factors (categorical data)
credit_data[] <- lapply(credit_data, function(x) if (is.character(x)) as.factor(x) else x)

# Split the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(credit_data$Class, p = 0.70, list = FALSE)
trainData <- credit_data[trainIndex, ]
testData <- credit_data[-trainIndex, ]

# We'll pick the J48 decision tree for our model
model <- J48(Class ~ ., data = trainData)

# Predict on the test set
predictions <- predict(model, newdata = testData)

# Generate the confusion matrix, along with other results.
confusionMatrix(predictions, testData$Class)

# 2. K-NN 
# K-Nearest Neighbours' approach is something like "what, in the existing dataset, have we already seen around this area?". It iteratively works with a selected number (K) of nearest neighbours of data points and calculates the average, or majority vote, of these neighbours' given labels.

# Let's do a K-NN model
model <- IBk(Class ~ ., data = trainData, control = Weka_control(K = 5)) # Let's pick 5 for our K-number

predictions <- predict(model, newdata = testData)

confusionMatrix(predictions, testData$Class)

# 3. SVMs
# Support Vector Machines maximize the separation between classes when drawing the decision boundary. It's good for non-linear data as well.

# Now an SVM model
model <- SMO(Class ~ ., data = trainData)

predictions <- predict(model, newdata = testData)

confusionMatrix(predictions, testData$Class)