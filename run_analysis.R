library(dplyr)

# reading data

X_train <- read.table("./train/X_train.txt")
Y_train <- read.table("./train/Y_train.txt")
Sub_train <- read.table("./train/subject_train.txt")
X_test <- read.table("./test/X_test.txt")
Y_test <- read.table("./test/Y_test.txt")
Sub_test <- read.table("./test/subject_test.txt")
variable_names <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
Sub <- rbind(Sub_train, Sub_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# i suppose that variables like ...meanfreq are not measurements of the mean/std 
# so i require that the mean/std is the last word on the variable before parenthesis.
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X <- X[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set

colnames(Y) <- "activity_type"
Y$activity_type <- factor(Y$activity_type, labels = as.character(activity_labels[,2]))


# 4. Appropriately labels the data set with descriptive variable names.

colnames(X) <- variable_names[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

colnames(Sub) <- "subject"
total <- cbind(X, Y, Sub)
total_mean <- total %>% group_by(activity_type, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

