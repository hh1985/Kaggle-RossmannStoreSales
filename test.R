if (F) {
  sample.submission <- read.csv("sample_submission.csv", sep = "\t")
  store <- read.csv("store.csv")
  final.test <- read.csv("test.csv", row.names = 1)
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
train.date <- data.frame()

# 2. Store: store type, assortment, competition
# 3. Promotion.
# 3a. If correlation with Holiday.
# 4. Open: if Open = 0, Sales = 0.
# 5. Customers: removed in test dataset.
if (T) {
   
}

# XGBoost test case.
require(xgboost)
require(Matrix)
require(data.table)
if (F) {
  train.df <- data.table(train)
  # The store id is still important.
  train.df$Store <- factor(paste("ST", train.df$Store, sep = ""))
  store.df <- data.table(store)
  store.df$Store <- factor(paste("ST", store.df$Store, sep = ""))
  final.df <- data.table(final.test)
  final.df$Store <- factor(paste("ST", final.df$Store, sep = ""))
  
  require(dplyr)
  expand.df <- left_join(train.df, store.df, by = "Store")

  # Create dummy variable
  library(caret)
  # Customer can be used to weight Store.
  #dmy <- dummyVars(Sales~. - Date - Store - Customers, data = expand.df)
  dmy <- dummyVars(Customers~. - Date - Store - Sales, data = expand.df)
  expand.train <- predict(dmy, newdata = expand.df)
  #sparse.train <- sparse.model.matrix(Sales ~. - Date - Store, data = expand.df)
  
  # Each key is (Store, Date) and the sales should meet: sales = f(Store, Date, Competitor)
  #train.Y <- train.df[,  Sales]
  train.Y <- train.df[,  Customers]
  bst <- xgb.cv(data = expand.train,
                 label = train.Y,
                 max.depth = 8,
                 eta = 1,
                 nfold = 5,
                 nthread = 4,
                 nround = 5000,
                 objective = "reg:linear",
                 maximize = FALSE,
                 early.stop.round = 1000
                 )
  importance <- xgb.importance(feature_names = dimnames(expand.train)[[2]], model = bst)
  head(importance)
}