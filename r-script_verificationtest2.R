#This is the verification test with Informationstrategy increasevalue is 5

options(stringsAsFactors = FALSE)

#Note that plot() is not the same as ggplot()
#these are from two separate packages
library(ggplot2)

# needed for reshaping data frames
library(reshape2)

#used for querying data, performing aggregations, filtering, etc.
library(sqldf)

myDataVerificationtest2 = read.table("C:/Users/Kirsten/Documents/Studie/Master/3dYear/Agent_Based/v9_afterverification experimenttest2-table.csv", skip = 6, sep = ",", head=TRUE)

summary(myDataVerificationtest2)

#this will also show you the names of the column names
colnames = colnames(myDataVerificationtest2)

##### Don't worry about what this means, it cleans up the column names   #####
##### You can just copy/paste it and re-use it, just make sure that      #####
##### if your data frame isn't called myDataFrame, then update that part #####
# Some colnames start with "X.", get rid of this 
colnames(myDataVerificationtest2) = gsub("X\\.", "", colnames(myDataVerificationtest2))
# Get rid of periods at the start and end of the names
colnames(myDataVerificationtest2) = gsub("^\\.|\\.$", "", colnames(myDataVerificationtest2))
# Convert all periods into underscores
colnames(myDataVerificationtest2) = gsub("\\.", "_", colnames(myDataVerificationtest2))

#remove the value at time is 0. Then all the marketshares are also still 0 and this influence the data
myDataVerificationtest2<-myDataVerificationtest2[!(myDataVerificationtest2$step == 0),]

#testing kurtosis
library(e1071)  
kurtosis(myDataVerificationtest2$total_consumers_RTP)
kurtosis(myDataVerificationtest2$total_consumers_CPP)
kurtosis(myDataVerificationtest2$total_consumers_ToU)
kurtosis(myDataVerificationtest2$total_consumers_RTPH)

#testing skewness
skewness(myDataVerificationtest2$total_consumers_RTP)
skewness(myDataVerificationtest2$total_consumers_CPP)
skewness(myDataVerificationtest2$total_consumers_ToU)
skewness(myDataVerificationtest2$total_consumers_RTPH)

#see if this influence the variance
var(myDataVerificationtest2$total_consumers_RTP)
var(myDataVerificationtest2$total_consumers_CPP)
var(myDataVerificationtest2$total_consumers_ToU)
var(myDataVerificationtest2$total_consumers_RTPH)

#mean
mean(myDataVerificationtest2$total_consumers_RTP)
mean(myDataVerificationtest2$total_consumers_CPP)
mean(myDataVerificationtest2$total_consumers_ToU)
mean(myDataVerificationtest2$total_consumers_RTPH)

#relative variance
sd(myDataVerificationtest2$total_consumers_RTP)/mean(myDataVerificationtest2$total_consumers_RTP)
sd(myDataVerificationtest2$total_consumers_CPP)/mean(myDataVerificationtest2$total_consumers_CPP)
sd(myDataVerificationtest2$total_consumers_ToU)/mean(myDataVerificationtest2$total_consumers_ToU)
sd(myDataVerificationtest2$total_consumers_RTPH)/mean(myDataVerificationtest2$total_consumers_RTPH)