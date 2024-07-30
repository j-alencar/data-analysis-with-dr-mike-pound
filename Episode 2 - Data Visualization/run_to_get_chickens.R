# Turns out chickens.csv isn't actually real, as you might have guessed from the weird values. I'm "artificially" generating it here.

set.seed(123)

diet_A_weight <- c(28.06518, runif(98, 46.51014, 61.93257), 78.42803)
diet_A_weight <- diet_A_weight[order(diet_A_weight)]
diet_A_weight[50] <- 55.08234
diet_A_weight[75] <- 61.93257
diet_A_weight <- diet_A_weight[order(diet_A_weight)]

diet_B_weight <- c(35.92975, runif(98, 51.41988, 63.82526), 82.79082)
diet_B_weiht <- diet_B_weight[order(diet_B_weight)]
diet_B_weight[50] <- 57.36610
diet_B_weight[75] <- 63.82526
diet_B_weight <- diet_B_weight[order(diet_B_weight)]

diet_C_weight <- c(41.48325, runif(98, 58.70688, 73.27904), 91.98395)
diet_C_weight <- diet_C_weight[order(diet_C_weight)]
diet_C_weight[50] <- 66.33680
diet_C_weight[75] <- 73.27904
diet_C_weight <- diet_C_weight[order(diet_C_weight)]

diet_A_eggs <- c(1, runif(98, 4, 8), 14)
diet_A_eggs <- diet_A_eggs[order(diet_A_eggs)]
diet_A_eggs[50] <- 6
diet_A_eggs[75] <- 8
diet_A_eggs <- diet_A_eggs[order(diet_A_eggs)]

diet_B_eggs <- c(1, runif(98, 6, 10), 16)
diet_B_eggs <- diet_B_eggs[order(diet_B_eggs)]
diet_B_eggs[50] <- 8
diet_B_eggs[75] <- 10
diet_B_eggs <- diet_B_eggs[order(diet_B_eggs)]

diet_C_eggs <- c(5, runif(98, 7, 12), 19)
diet_C_eggs <- diet_C_eggs[order(diet_C_eggs)]
diet_C_eggs[50] <- 9.5
diet_C_eggs[75] <- 12
diet_C_eggs <- diet_C_eggs[order(diet_C_eggs)]

diet_A_age <- runif(100, 0.5, 2.5)
diet_A_age <- diet_A_age[order(diet_A_age)]

diet_B_age <- runif(100, 2.0, 4.0)
diet_B_age <- diet_B_age[order(diet_B_age)]

# Diet C: Intermediate age
diet_C_age <- runif(100, 1.5, 3.5)
diet_C_age <- diet_C_age[order(diet_C_age)]

chickens <- data.frame(
  weight = c(diet_A_weight, diet_B_weight, diet_C_weight),
  eggs = c(diet_A_eggs, diet_B_eggs, diet_C_eggs),
  age = c(diet_A_age, diet_B_age, diet_C_age),
  diet = rep(c("A", "B", "C"), each = 100)
)

write.csv(chickens, "chickens.csv", row.names = FALSE)