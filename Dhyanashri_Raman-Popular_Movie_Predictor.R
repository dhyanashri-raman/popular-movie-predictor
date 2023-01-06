#Dhyanashri Raman

#Datasets obtained from: https://www.kaggle.com/datasets/tmdb/tmdb-movie-metadata

movie_db <- read.csv("tmdb_5000_movies.csv")
movie_extras <- read.csv("tmdb_5000_credits.csv")

############################# Part 1 ##################################
#Datatypes of each column
str(movie_db)

#Visualize the data
#budget of the movie vs. the vote average
#x axis --> budget, y axis --> vote average
plot(movie_db$budget, movie_db$popularity, xlab="Budget", ylab="Popularity")
plot(movie_db$budget, movie_db$vote_average, xlab="Budget", ylab="Vote Average")
plot(movie_db$popularity, movie_db$revenue, xlab="Popularity", ylab="Revenue")

#Three predictors are the budget, popularity, and the average votes
plot(movie_db$budget, movie_db$revenue, xlab="Budget", ylab="Revenue", main="Budget vs Revenue")
plot(movie_db$vote_average, movie_db$revenue, xlab="Vote Average", ylab="Revenue", main="Vote Average vs Revenue")
plot(movie_db$popularity, movie_db$revenue, xlab="Popularity", ylab="Revenue", main="Popularity vs Revenue")

boxplot(revenue~budget, data=movie_db, main="Budget vs Revenue")
boxplot(revenue~vote_average, data=movie_db, main="Vote Average vs Revenue")
#Vote average for 5 or greater
greater_than_five_db <- subset(movie_db, movie_db$vote_average>=5)
boxplot(revenue~vote_average, data=movie_db, ylim = c(0, 1e+09), main="Vote Average vs Revenue")
boxplot(revenue~vote_average, data=greater_than_five_db, ylim = c(0, 1e+09), main="Vote Average vs Revenue")

################################ Part 2 #################################
#H0: Revenue for the upper half of the data (measured through vote average) is the same as
#    the revenue for the lower half of the data.
#H1: Revenue for the upper half of the data (measured through vote average) is greater than
#    the revenue for the lower half of the data.

#Using a Z-test to calculate the P-Value.

lowerHalf <- subset(movie_db, movie_db$vote_average < 5)
upperHalf <- subset(movie_db, movie_db$vote_average > 5)

mean_upperHalf <- mean(upperHalf$revenue)
mean_lowerHalf <- mean(lowerHalf$revenue)
  
len_upperHalf <- length(upperHalf$revenue)
len_lowerHalf <- length(lowerHalf$revenue)
  
sd_upperHalf <- sd(upperHalf$revenue)
sd_lowerHalf <- sd(lowerHalf$revenue)

#Formula for two sample z-test: (u1-u2)/sqrt((sd1^2/n1)+(sd2^2/n2))
z_score <- (mean_upperHalf-mean_lowerHalf)/sqrt((sd_upperHalf^2/len_upperHalf)+(sd_lowerHalf^2/len_lowerHalf))
p_val <- 1-pnorm(z_score)
p_val

if (p_val < 0.05)
{
  print("Reject the first Null Hypothesis")
}

############################## Part 2 Cont #########################
#H0: Revenue for the upper half of the data (measured through the budget) is the same as
#    the revenue for the lower half of the data.
#H1: Revenue for the upper half of the data (measured through the budget) is greater than
#    the revenue for the lower half of the data.

#Using a Z-test to calculate the P-Value.

halfBudget <- max(movie_db$budget)/2
lowerHalf2 <- subset(movie_db, movie_db$budget < halfBudget)
upperHalf2 <- subset(movie_db, movie_db$budget > halfBudget)

len_lowerHalf2 <- nrow(lowerHalf2)
len_upperHalf2 <- nrow(upperHalf2)

mean_lowerHalf2 <- mean(lowerHalf2$revenue)
mean_upperHalf2 <- mean(upperHalf2$revenue)

sd_lowerHalf2 <- sd(lowerHalf2$revenue)
sd_upperHalf2 <- sd(upperHalf2$revenue)

#Formula for two sample z-test: (u1-u2)/sqrt((sd1^2/n1)+(sd2^2/n2))
z_score <- (mean_upperHalf2-mean_lowerHalf2)/sqrt((sd_upperHalf2^2/len_upperHalf2)+(sd_lowerHalf2^2/len_lowerHalf2))
p_val <- 1-pnorm(z_score)
p_val

if (p_val < 0.05)
{
  print("Reject the second Null Hypothesis")
}

############################## Part 3 ##############################
shuffled_data <- movie_db[sample(1:nrow(movie_db)), ]
  
max <- as.integer(nrow(movie_db)*0.8)
trainingData <- shuffled_data[1:max,]
testingData <- shuffled_data[max:nrow(movie_db),]

model <- lm(revenue~vote_average+budget+popularity, data=trainingData)
testingData$Predictions <- predict(model, testingData)

for(i in 1:length(testingData$Predictions)){
  if (testingData$Predictions[i] <= 0){
    testingData$Predictions[i] = 0
  }
}
View(testingData)
  
avg <- mean(testingData$Predictions)
#85074239

testingData$TopPred <- NA
testingData$Production <- NA
counter <- 0

for(i in 1:length(testingData$Predictions)){
  if (testingData$Predictions[i] >= 83000000 && testingData$Predictions[i] <= 87000000){
    testingData$TopPred[i] = testingData$title[i]
    
    counter <- counter+1
  }
}
topMovies <- data.frame(na.omit(testingData$TopPred))

View(topMovies)
View(testingData)
########################## Part 4 ###################################
#Ordering the data in the testingData to see if it matches our predictions

newData <- testingData
newData$Prod <- NA

counter2 <- 0
for(i in 1:length(newData)){
  newData$Prod[i] = substr(newData$production_companies[i], 12, 25)
  counter2 <- counter+1
}

newData <- data.frame(na.omit(newData$Prod))

View(newData)
View(sort((table(newData)), TRUE))

#As we know it, Columbia Pictures and Universal Pictures