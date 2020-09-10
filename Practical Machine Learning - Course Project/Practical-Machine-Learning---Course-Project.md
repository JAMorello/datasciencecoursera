---
title: "Practical Machine Learning - Course Project"
author: "Juan Agustín Morello"
date: "10/9/2020"
output: 
  html_document: 
    keep_md: yes
---

# Introduction

Using devices such as *Jawbone Up*, *Nike FuelBand*, and *Fitbit* it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement – a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. 

One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, the goal is to predict the manner in which one person may do an exercise. We'll be using data collected from accelerometers on the belt, forearm, arm, and dumbell of 6 participants that were asked to perform barbell lifts correctly and incorrectly in 5 different ways.

# Packages

This project uses the following packages:


```r
library(readr)
library(caret)
library(randomForest)
```


# Data

The data provided by the Course consists in a Training data and a Test data. Is important to keep in mind that the Test data is intended to be used to predict some outcomes not to validate the constructed model as it doesn't have the target outcomes in their observations. Later, we'll split the Training data set in both training and testing set.

### Downloading and loading datasets


```r
# Download and unzip the files

  # Make sure that the directory where the data is to be stored exist
  if(!file.exists("./data")){dir.create("./data")}


  # Create a vector with the URL address to the training dataset
  url_train <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
  # Set download path directory
  dwnld_path <- "./data/pml-training.csv"
  # Download file
  download.file(url_train, destfile=dwnld_path, method="curl")
  
  # Create a vector with the URL address to the testing dataset
  url_test <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
  # Set download path directory
  dwnld_path <- "./data/pml-testing.csv"
  # Download file
  download.file(url_test, destfile=dwnld_path, method="curl")
  
# Load data sets
  
  cols <- cols(
          user_name = col_character(),
                    raw_timestamp_part_1 = col_integer(),
          raw_timestamp_part_2 = col_integer(),
          cvtd_timestamp = col_datetime(format = "%d/%m/%Y %H:%M"),
          new_window = col_factor(c("no", "yes"), ordered=TRUE),
          num_window = col_integer(),
          
          # classe is the outcome variable
          classe = col_factor(c("A", "B", "C", "D", "E"), ordered=TRUE),
          
          #The rest of the variables are doubles
          .default = "d"
  )
  
  training <- read_csv("data/pml-training.csv", col_types=cols, na=c("", "NA",
                                                                     "#DIV/0!"))
```

```
## Warning: Missing column names filled in: 'X1' [1]
```

```r
  to_predict <- read_csv("data/pml-testing.csv", col_types=cols, na=c("", "NA",
                                                                   "#DIV/0!"))
```

```
## Warning: Missing column names filled in: 'X1' [1]
```

```
## Warning: The following named parsers don't match the column names: classe
```

### `classe`: outcome variable

Class A corresponds to the specified execution of the exercise, while the other 4 classes correspond to common mistakes.

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions: 

* **Class A**: exactly according to the specification 
* **Class B**: throwing the elbows to the front
* **Class C**: lifting the dumbbell only halfway
* **Class D**: lowering the dumbbell only halfway
* **Class E**: throwing the hips to the front


### Acknowledge

The data came from [GroupWare](http://groupware.les.inf.puc-rio.br/har) (see the section on the Weight Lifting Exercises Dataset)

Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.

# Model building

## Data preprocessing

1) Split the training data set the Course provide us into two data sets: 70% into `train` and 30% into `test`. This splitting will be useful also to later compute the out-of-sample error.


```r
set.seed(1993)
inTrain  <- createDataPartition(training$classe, p=0.7, list=FALSE)
train <- training[inTrain,]
```

```
## Warning: The `i` argument of ``[`()` can't be a matrix as of tibble 3.0.0.
## Convert to a vector.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_warnings()` to see where this warning was generated.
```

```r
test <- training[-inTrain,]
```

Next thing we have to do before creating a predictive model is filtering all the features that the data set have and find the most important ones.

2) Delete the first seven features because they do not provide important information regarded to what action is being made; the first column is the same as the index ant the rest only tell us when it was made and by who.


```r
  train <- train[,-c(1:7)]
  test <- test[,-c(1:7)]
  to_predict <- to_predict[,-c(1:7)]
```

3) Delete all those features whose observations fall below a certain amount of NA values. We'll have as threshold a mean of 0.90 NA values. We'll erase the features first in the training data set and then delete those same features in the prediction data set.


```r
AllNA <- sapply(train, function(x) mean(!is.na(x)) > 0.90)

train <- train[,AllNA]
test <- test[,AllNA]
to_predict <- to_predict[,AllNA]
```

4) We could try cleaning the data even further by removing the variables that are at near-zero-variance. But the `nearZeroVar` returns an empty integer variable. So we'll skip this step.


```r
nearZeroVar(train[,-length(train)]) # All features minus outcome 'classe'
```

```
## integer(0)
```

5) Next we'll use the `findCorrelation` function to search for highly correlated attributes with a cut off equal to 0.75.


```r
correlation <- cor(train[, -length(train)]) # All features minus outcome 'classe'
highlyCorrelated = findCorrelation(correlation, cutoff=0.75)

train <- train[, c(highlyCorrelated, length(train))] # Correlated features plus 'classe'
test <- test[, c(highlyCorrelated, length(test))]
to_predict <- to_predict[,highlyCorrelated]
```

At the end, we end up with the following features:


```r
names(train)
```

```
##  [1] "accel_belt_z"      "roll_belt"         "accel_belt_y"     
##  [4] "accel_arm_y"       "total_accel_belt"  "accel_dumbbell_z" 
##  [7] "accel_belt_x"      "pitch_belt"        "accel_dumbbell_y" 
## [10] "magnet_dumbbell_x" "magnet_dumbbell_y" "accel_dumbbell_x" 
## [13] "accel_arm_x"       "accel_arm_z"       "magnet_arm_y"     
## [16] "magnet_belt_z"     "accel_forearm_y"   "gyros_forearm_y"  
## [19] "gyros_dumbbell_x"  "gyros_dumbbell_z"  "gyros_arm_x"      
## [22] "classe"
```

## Model building

Because we are interested in building a model capable of predicting a certain class, this is, our problem is about a classification outcome, in this project we'll try building a Random Forest model to predict in which class corresponds the observations and evaluate it's accuracy.

We'll instruct the `train` function to use 5-fold cross-validation on the `train` data to select optimal tuning parameters for the model (for this, we'll create a variable containing the training control options for Random Forest).


```r
set.seed(1993)
controlRF <- trainControl(method="cv", number=5, verboseIter=FALSE)
rf_model <- train(classe ~ ., data=train, method="rf", trControl=controlRF)
rf_model$finalModel
```

```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 2
## 
##         OOB estimate of  error rate: 1.91%
## Confusion matrix:
##      A    B    C    D    E class.error
## A 3886    5    4   10    1 0.005120328
## B   39 2592   23    4    0 0.024830700
## C    8   32 2345   11    0 0.021285476
## D   11    1   76 2162    2 0.039964476
## E    1    4   16   14 2490 0.013861386
```

Next, we'll use the `test` data to get predictions and a confusion matrix to make an analysis of the accuracy of the model.


```r
rf_prediction <- predict(rf_model, newdata=test)
confusionMatrix(rf_prediction, test$classe)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1670   15    2    2    0
##          B    3 1119   12    0    0
##          C    0    3 1006   41    2
##          D    1    2    6  920    9
##          E    0    0    0    1 1071
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9832          
##                  95% CI : (0.9796, 0.9863)
##     No Information Rate : 0.2845          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9787          
##                                           
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9976   0.9824   0.9805   0.9544   0.9898
## Specificity            0.9955   0.9968   0.9905   0.9963   0.9998
## Pos Pred Value         0.9888   0.9868   0.9563   0.9808   0.9991
## Neg Pred Value         0.9990   0.9958   0.9959   0.9911   0.9977
## Prevalence             0.2845   0.1935   0.1743   0.1638   0.1839
## Detection Rate         0.2838   0.1901   0.1709   0.1563   0.1820
## Detection Prevalence   0.2870   0.1927   0.1788   0.1594   0.1822
## Balanced Accuracy      0.9965   0.9896   0.9855   0.9753   0.9948
```

This worked very well. The Random Forests model yielded highly accurate predictions on the test data set. The **accuracy** of this model on the testing dataset was is **98%** , which is a good estimate of the out-of-sample accuracy (**2%**). It’s possible that this could be improved upon by parameterizing the Random Forests method in a different fashion, but for the current purposes I’m very happy with this model.

# Predicting outcomes

Before predicting on the testing dataset provided by the Course (the 20 quiz results), it is important to train the model on the full training set, rather than using a model trained on a reduced training set (as we did with `final_train`, that it is the 70% of the original data set), in order to produce the most accurate predictions.

We'll repeat the steps of the preprocessing section using the important features found in there (the variables: `AllNA`, `highlyCorrelated`).


```r
training <- training[,-c(1:7)]
training <- training[, AllNA]
training <- training[, c(highlyCorrelated, length(training))]
```

Next we'll build the model and predict the outcomes of the preprocessed `to_predict` data (using the previously created training control options for Random Forest).


```r
set.seed(1993)
full_rf_model <- train(classe ~ ., data=training, method="rf",
                       trControl=controlRF)

prediction <- predict(full_rf_model, newdata=to_predict)
prediction
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A < B < C < D < E
```
