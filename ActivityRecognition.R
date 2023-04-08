#Data Overview
train = read.table("C:/Users/10656/Desktop/UM2.2/626/training_data.txt",header = TRUE)
test = read.table("C:/Users/10656/Desktop/UM2.2/626/test_data.txt",header = TRUE)

dim(train)
dim(test)

# Set the binary outcome for activities
train$binary_act = ifelse(train$activity == 1|train$activity == 2|train$activity == 3, 1, 0)


# Variable Selection for Binary Classification (Baseline)

library(earth)
fsmodel = earth(binary_act~.-subject-activity,data=train)
ev <- evimp (fsmodel)
ev
plot(ev)



library(party)
cf1 <- cforest(binary_act~.-subject-activity,data=train, control=cforest_unbiased(mtry=2,ntree=50))
voi = varimp(cf1)
plot(voi)
# show first 10 most important variables
sort(voi,decreasing = TRUE)[1:10]






library(glmnet)
library(caret)

glm1 = glm(binary_act~F282+F141+F201+F182,data=train)
glmresult = predict(glm1,newdata = train, type="response")
predicted.classes <- ifelse(glmresult > 0.51, 1, 0)
mean(predicted.classes == train$binary_act)

confusionMatrix(data = as.factor(predicted.classes), reference =as.factor(train$binary_act))$table



glm2 = glm(binary_act~F96+F103+F258+F272+F270+F259+F201+F405+F345,data=train)
glmresult = predict(glm2,newdata = train, type="response")
predicted.classes <- ifelse(glmresult > 0.55, 1, 0)
mean(predicted.classes == train$binary_act)
confusionMatrix(data = as.factor(predicted.classes), reference =as.factor(train$binary_act))$table

#





#lasso
lassoy = train$binary_act
lassox = data.matrix(train[,-c(1,2,564)])
cv_model <- cv.glmnet(lassox, lassoy, alpha = 1)
best_lambda <- cv_model$lambda.min
best_lambda
best_model <- glmnet(lassox, lassoy, alpha = 1, lambda = best_lambda)
coef(best_model)
y_predicted <- predict(best_model, s = best_lambda, newx = lassox)
predicted.classes <- ifelse(y_predicted > 0.56, 1, 0)
mean(predicted.classes == train$binary_act)
confusionMatrix(data = as.factor(predicted.classes), reference =as.factor(train$binary_act))$table



testlassox = data.matrix(test[,-c(1)])
#test
y_predicted <- predict(best_model, s = best_lambda, newx = testlassox)
predicted.classes <- ifelse(y_predicted > 0.52, 1, 0)
write.table(predicted.classes, "C:/Users/10656/Desktop/UM2.2/626/binary_l1281.txt", row.names=FALSE, col.names = FALSE)


#########################################
##################################################
#####################################################
train2 = train
train2$multi_act = ifelse(train$activity>=7 & train$activity<=12, 7, train$activity)

lassoy2 = train2$multi_act
lassox2 = data.matrix(train2[,-c(1,2,564,565)])
glmnetModel <- cv.glmnet(lassox2, lassoy2, family= "multinomial",grouped = TRUE,type.measure = "class")
result2 = predict(glmnetModel, lassox2,s="lambda.min",type=c("class"))
confusionMatrix(data = as.factor(result2), reference =as.factor(train2$multi_act))$table


testlassox2 = data.matrix(test[,-c(1)])
#test
result2test <- predict(glmnetModel, testlassox2, s="lambda.min",type=c("class"))
write.table(as.numeric(result2test), "C:/Users/10656/Desktop/UM2.2/626/multiclass_l1281.txt", row.names=FALSE, col.names = FALSE)
