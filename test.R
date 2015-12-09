if (F) {
  sample.submission <- read.csv("sample_submission.csv", sep = "\t")
  store <- read.csv("store.csv")
  test <- read.csv("test.csv", row.names = 1)
  train <- read.csv("train.csv")
  str(sample.submission)
  str(store)
  str(test)
  str(train)
  
  # Issues.
  # 1. holiday detail.
  # 2(optional). Social events (twitter / facebook).
  # 3. digitalizing "Date" field.
}

if (T) {
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
  featurePlot(x = subset(train.X, select = -c(Date)),
              y = train.Y,
              plot = "scatter",
              type = c("p", "smooth"),
              span = .5,
              layout = c(2, 4)
              )
}