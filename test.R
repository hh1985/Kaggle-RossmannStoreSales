if (F) {
  sample.submission <- read.csv("sample_submission.csv", sep = "\t")
  store <- read.csv("store.csv")
  test <- read.csv("test.csv", row.names = 1)
  train <- read.csv("train.csv")
  str(sample.submission)
  str(store)
  str(test)
  str(train)
  
  # Introduce extra data.
  # 1. holiday detail.
  # 2. Social events (twitter / facebook).
  # 
}

if (T) {
  train.X <- subset(train, select = -c(Store, Sales))
  train.Y <- subset(train, select = Sales)
  
  # Scatter plot of all variables.
  require(caret)
  featurePlot(x = train.X,
              y = train.Y,
              plot = "scatter",
              type = c("p", "smooth"),
              span = .5,
              layout = c(2, 4)
              )
}