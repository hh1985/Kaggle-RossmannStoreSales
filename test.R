if (F) {
  sample.submission <- read.csv("sample_submission.csv", sep = "\t")
  store <- read.csv("store.csv")
  test <- read.csv("test.csv", row.names = 1)
  train <- read.csv("train.csv")
  str(sample.submission)
  str(store)
  str(test)
  str(train)
}

# Data processing --------------------------------------------------
if (F) {
  train.X <- subset(train, select = -c(Store, Sales, StateHoliday))
  train.Y <- train[, "Sales"]
  
  # dummy variable.
  #state.holiday.f <- factor(train.X$StateHoliday)
  #dummies <- model.matrix(~state.holiday.f)
  #dummies = table(1:length(train.X$StateHoliday),as.factor(train.X$StateHoliday))
  #dummies <- as.data.frame(dummies)
  require(dummies)
  train.X <- cbind(train.X, dummy("StateHoliday", train)[, -1])
  
  # Scatter plot of all variables.
  require(caret)
  slice.index <- sample(1:nrow(train.X), 10000)
  featurePlot(x = subset(train.X, select = -c(Date))[slice.index, ],
              y = train.Y[slice.index],
              plot = "scatter",
              type = c("p", "smooth"),
              span = .5,
              layout = c(2, 4)
              )
}

# Feature engineering ------------------------------------------------
# 1. Date
# 1a. weekday/weekend
# 1b. proceeding day
# 1c. Promotion days.
# 2. Store: store type, assortment, competition
# 3. Promotion.
# 3a. If correlation with Holiday.
# 4. Open: if Open = 0, Sales = 0.
# 5. Customers: removed in test dataset.
if (T) {
   
}