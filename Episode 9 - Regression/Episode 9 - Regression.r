# ML makes it easier for us to put things into neat little categories. Not everything is a neat little category. Sometimes it's a number on a scale.

# 1. The simplest form of regression is Linear Regression.
# Imagine a table of data with many rows of an input x, which always outputs a y. When plotting this on a graph, we could fit a line through the data to predict it -- a line would be of the form y = mx + c, so we want to figure out what m and c are using regression so that when there's a new x, we can predict a y.

# Let's create some sample data
set.seed(123)
x <- rnorm(100, mean = 50, sd = 10)  # 100 random numbers from a normal distribution
y <- 2 * x + rnorm(100, mean = 0, sd = 5)  # y = 2x + noise

# Plotting the data
plot(x, y, main = "Scatter Plot of x and y", xlab = "x", ylab = "y", pch = 16, col = "blue")

# Let's fit a linear model
model <- lm(y ~ x)

# We summarize the model to get the coefficients m and c
summary(model)

# The fitted line is of the form y = mx + c
# We add this line to the plot
abline(model, col = "red")

# Now, let's predict a new y for a given x
new_x <- 55
predicted_y <- predict(model, newdata = data.frame(x = new_x))

cat("Predicted y for x =", new_x, "is", predicted_y, "\n")

# 2. Of course, we are only using one independent variable here (x), but you can do this with multiple variables (Multivariate Linear Regression).
# Let's use this data from superconductors to try and predict the critical temperature based on the other attributes.

library(ggplot2)
library(readr)  # For reading CSV files

# Superconductor data
data <- read_csv("train.csv")

# Fit our model
model <- lm(critical_temp ~ ., data = data)

# Generate predictions
data$predicted_temp <- predict(model, newdata = data)

# Scatterplot of expected vs. predicted
ggplot(data, aes(x = critical_temp, y = predicted_temp, color = predicted_temp)) +
  geom_point(size = 3) +
  scale_color_gradient(low = "blue", high = "orange") +
  labs(title = "Scatterplot of Expected vs. Predicted Temperatures",
       x = "Expected Temperature",
       y = "Predicted Temperature",
       color = "Predicted Temperature") +
  theme_minimal()


# 3. Artificial Neural Networks (ANNs) are inspired by the human brain. An ANN is composed of layers of nodes, called neurons, where each neuron is connected to neurons in the previous and next layers. These connections have weights, which are adjusted during training to minimize the error in predictions.

# Imagine a simple ANN with three layers: an input layer, a hidden layer, and an output layer. Each neuron in the hidden and output layers performs a weighted sum of its inputs, adds a bias, and passes the result through an activation function.

# The output of each neuron is calculated as follows:
# - For a neuron j, the input is a vector x.
# - The weighted sum is calculated as z_j = w_j1 * x_1 + w_j2 * x_2 + ... + w_jn * x_n + b_j, where w are the weights and b is the bias.
# - The output is then f(z_j), where f is the activation function (e.g., sigmoid, ReLU).
# By adjusting the weights and biases during training, the ANN learns to make accurate predictions. This process is called backpropagation, where the error is propagated backward through the network to update the weights.
