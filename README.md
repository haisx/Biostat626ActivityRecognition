# Human Activity Recognition using Wearable Sensor Technology

### BIOSTAT626 Midterm Project 1.
The original project page could be found at https://github.com/xqwen/bios626.




## Description

A group of volunteers, aged between 19 and 48, are recruited to participate in the experiment. They performed a protocol consisting of six activities: three static postures (standing, sitting, lying) and three dynamic activities (walking, walking downstairs, and walking upstairs). The experiment also recorded postural transitions that occurred between the static postures. These are: stand-to-sit, sit-to-stand, sit-to-lie, lie-to-sit, stand-to-lie, and lie-to-stand. All participants wore a smart device on the waist during the experiment. It captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz using the embedded accelerometer and gyroscope of the device. In this context, the activities are considered outcomes, and the signals measured by the smart device are considered features. 

More details could be found at the ``studyDesign/README.txt``.


## Motivation

To better understand static and dynamic human activities and their signals captured by wearable device sensors, this project will

1. Build a binary classifier to classify the activity of each time window into static (0) and dynamic (1). The postural transitions are seen as static (0). 

2. Build a refined multi-class classifier to classify walking (1), walking_upstairs (2), walking_downstairs (3), sitting (4), standing (5), lying (6), and static postural transition (7).


## Data files and Result files

Two tab-delimited text files ``data/training_data.txt`` and ``data/test_data.txt`` are provided. The training data (labeled activity information included) should be used to construct and test your ML algorithms. Apply your algorithm to the test data (containing only feature information) and predict the activity corresponding to each time window. 


The result files ``result/binary_l1281.txt`` and ``result/multiclass_l1281.txt`` are provided. These two files show the results predicted by ML algorithms for the test data.
  


## Getting Started

- R version 4.1.3
- R packages used in the project including `glmnet`, `caret`, `party`, `earth`, `kableExtra`, `dplyr`, `corrplot`, ...

- All the necessary codes for training the ML model is open to run at `ActivityRecognition.R`(Only the useful codes were kept in the file. Some old attempts were removed). Note that the performance of classifier may act slightly differently compared to my results according to the seeds.

- There are two main parts in the file `ActivityRecognition.R`, Final Algorithm part and Other Methods part. The Final Algorithm part includes the final algorithms (LASSO) we finally used for classifications. The Other Methods part includes the baseline algorithms (including glm, multinomal glm, feature selection, ...) used in the project.

- The prediction results on test data was written by `write.table()` function in R. The results of classification could be found at `result/.txt`.