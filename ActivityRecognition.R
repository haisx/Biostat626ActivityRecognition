# load packages
library(glmnet)
library(caret)
library(party)
library(earth)
library(kableExtra)
library(dplyr)
library(corrplot)

#Data Overview
train = read.table("C:/Users/10656/Desktop/UM2.2/626/training_data.txt",header = TRUE)
test = read.table("C:/Users/10656/Desktop/UM2.2/626/test_data.txt",header = TRUE)

dim(train) # 7767 observations 562 variables and 1 outcome variables
dim(test)  # 3162 observations 562 variables


# Set the binary outcome for activities, static (0) and dynamic (1)
train$binary_act = ifelse(train$activity == 1|train$activity == 2|train$activity == 3, 1, 0)

# First Part
## Final algorithm

# LASSO for binary classification since a large set of variables
# Cross-Validation was used for finding the best lambda
lassoy = train$binary_act
lassox = data.matrix(train[,-c(1,2,564)])
cv_model = cv.glmnet(lassox, lassoy, alpha = 1)
best_lambda = cv_model$lambda.min
best_lambda  # 4.636301e-05
best_model = glmnet(lassox, lassoy, alpha = 1, lambda = best_lambda)
coef(best_model)
y_predicted = predict(best_model, s = best_lambda, newx = lassox)
predicted.classes = ifelse(y_predicted > 0.56, 1, 0)
mean(predicted.classes == train$binary_act)
cmtable = confusionMatrix(data = as.factor(predicted.classes), 
                reference =as.factor(train$binary_act))$table

# Confusion matrix table
cmtable %>%
  kbl(caption = "Binary Classification Results") %>%
  kable_classic(full_width = F, html_font = "Cambria")


# set the variable matrix for the test dataset
testlassox = data.matrix(test[,-c(1)])

# classification with a pre-set threshold
y_predicted = predict(best_model, s = best_lambda, newx = testlassox)
predicted.classes = ifelse(y_predicted > 0.52, 1, 0)

# output the final results using LASSO
write.table(predicted.classes, "C:/Users/10656/Desktop/UM2.2/626/binary_l1281.txt", row.names=FALSE, col.names = FALSE)


#####################################################
#####################################################
#####################################################
# LASSO for multi-class classification

train2 = train
train2$multi_act = ifelse(train$activity>=7 & train$activity<=12, 7, train$activity)

lassoy2 = train2$multi_act
lassox2 = data.matrix(train2[,-c(1,2,564,565)])
glmnetModel = cv.glmnet(lassox2, lassoy2, family= "multinomial",grouped = TRUE,type.measure = "class")
result2 = predict(glmnetModel, lassox2,s="lambda.min",type=c("class"))
cmtable2 = confusionMatrix(data = as.factor(result2), 
                           reference =as.factor(train2$multi_act))$table

# Confusion matrix table
cmtable2 %>%
  kbl(caption = "Multi-class Classification Results") %>%
  kable_classic(full_width = F, html_font = "Cambria")


# set the variable matrix for the test dataset
testlassox2 = data.matrix(test[,-c(1)])

# output the final results using LASSO
result2test = predict(glmnetModel, testlassox2, s="lambda.min",type=c("class"))
write.table(as.numeric(result2test), "C:/Users/10656/Desktop/UM2.2/626/multiclass_l1281.txt", row.names=FALSE, col.names = FALSE)







# Second Part
################################### Exploratory Data Analysis
#################################### Other methods with lower accuracy
##################################### and other try on this data
hist(train$binary_act)
hist(train2$multi_act)
ctrain = cor(train)
#corrplot(ctrain, type = "upper", order = "hclust", 
#         tl.col = "black", tl.srt = 45)
col =  colorRampPalette(c("blue", "white", "red"))(20)
heatmap(x = ctrain, col = col, symm = TRUE)


# Variable Selection for Binary Classification (Baseline)
fsmodel = earth(binary_act~.-subject-activity,data=train)
ev <- evimp (fsmodel)
ev
plot(ev)


# variables of important
cf1 <- cforest(binary_act~.-subject-activity,data=train, control=cforest_unbiased(mtry=2,ntree=50))
voi = varimp(cf1)
plot(voi)

# show first 10 most important variables
sort(voi,decreasing = TRUE)[1:10]



# logistic regression with a set of most important variables
glm1 = glm(binary_act~F282+F141+F201+F182,data=train)
glmresult = predict(glm1,newdata = train, type="response")
predicted.classes <- ifelse(glmresult > 0.51, 1, 0)
mean(predicted.classes == train$binary_act)

confusionMatrix(data = as.factor(predicted.classes), 
                reference =as.factor(train$binary_act))$table
cmtableb1 = confusionMatrix(data = as.factor(predicted.classes), 
                            reference =as.factor(train$binary_act))$table

# Confusion matrix table
cmtableb1 %>%
  kbl(caption = "Binary Classification Results") %>%
  kable_classic(full_width = F, html_font = "Cambria")

# logistic regression with a set of most important variables (more variables)
glm2 = glm(binary_act~F96+F103+F258+F272+F270+F259+F201+F405+F345,data=train)
glmresult = predict(glm2,newdata = train, type="response")
predicted.classes <- ifelse(glmresult > 0.55, 1, 0)
mean(predicted.classes == train$binary_act)
confusionMatrix(data = as.factor(predicted.classes), 
                reference =as.factor(train$binary_act))$table

cmtableb2 = confusionMatrix(data = as.factor(predicted.classes), 
                            reference =as.factor(train$binary_act))$table

# Confusion matrix table
cmtableb2 %>%
  kbl(caption = "Binary Classification Results") %>%
  kable_classic(full_width = F, html_font = "Cambria")


## 
library(nnet)

multinom_model = multinom(multi_act~F96+F103+F258+F272+F270+F259+F201+F405+F345,data=train2)

ClassPredicted = predict(multinom_model, newdata = train, "class")
# Building classification table
tab <- table(train2$multi_act, ClassPredicted)
tab
tab %>%
  kbl(caption = "Multi-class Classification Results") %>%
  kable_classic(full_width = F, html_font = "Cambria")
