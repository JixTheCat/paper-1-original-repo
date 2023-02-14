# loading libraries
for (val in c(
  'rpart',
  'rpart.plot',
  'feather')
  ){
  if(!require(val, character.only=TRUE)) install.packages(val, character.only=TRUE)
}

# reading file in
# Note that the file is prepared in python using what will become deprecated functions

# A seed is set for reproducibility

# The data is split
#sample.split <- sample(2, nrow(viticlean), replace = T, prob = c(0.9, 0.1))
#df.train <- viticlean[sample.split == 1,]
#df.test <- viticlean[sample.split == 2,]

rtree <- function(df, formula, class_var) {
  set.seed(31415)
  
  df <- read.csv(
    df, stringsAsFactors = TRUE, row.names = 1, header = TRUE)

  tree <- rpart(formula, data = df)
  
  png(file=".tree.png")
  rpart.plot(tree, extra=102, legend.x=-100)
  dev.off()
  
  png(file=".error.png")
  plotcp(tree)
  dev.off()
  
  printcp(tree)
  pred = predict(tree, type="class")
  print("Variable Importance:")
  print(tree$variable.importance)
  print("Confusion matrix saved. Accuracies printed below:")
  conf <- table(pred, df[,class_var])
  write.table(conf, paste(class_var, ".csv"), sep=",")
  correct <- sum(diag(conf))
  total <- sum(conf)
  incorrect <- total - correct
  print(paste("Correct: %", round(correct/total*100, 2)))
  print(paste("Incorrect: %", round(incorrect/total*100, 2)))
}



###################
# Regression Trees

#tree.operating.costs <- 

# to be calculated
#tree.fuel <- rpart(giregion ~ ., data = train)

# Some variables need to be removed
#tree.water <- rpart(total.water.used ~ ., data = df.train)

# Classification Trees
#tree.giregion <- rpart(giregion ~ ., data = df.train)

#tree.cover.crop <- rpart(giregion ~ ., data = train)
# Need to combine several variables:
# [
#'annual cover crop',
#'permanent cover crop non native',
#'permanent cover crop volunteer sward',
#'permanent cover crop native',
#'bare soil',
#'total crop cover']
#
# Need to binarise the variables below:
#tree.grazing <- rpart(sheep ~ ., data = train)
#tree.biodiversity <- rpart(biodiversity.vineyard ~ ., data = train)

#
##############


# The tree is output
#rpart.plot(tree, box.palette=0)

# Confusion Matrix
#table(p, train$tonnes.grapes.harvested)


#p1 <- predict(tree, test, type = 'prob')
#p1 <- p1[,2]
#r <- multiclass.roc(test$tonnes.grapes.harvested, p1, percent = TRUE)
#roc <- r[['rocs']]
#r1 <- roc[[1]]
#plot.roc(r1,
#         print.auc=TRUE,
#         auc.polygon=TRUE,
#         grid=c(0.1, 0.2),
#         grid.col=c("green", "red"),
#         max.auc.polygon=TRUE,
#         auc.polygon.col="lightblue",
#         print.thres=TRUE,
#         main= 'ROC Curve')
