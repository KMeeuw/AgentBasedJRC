#This is the verification test with Informationstrategy increasevalue is 0

options(stringsAsFactors = FALSE)

#Note that plot() is not the same as ggplot()
#these are from two separate packages
library(ggplot2)

# needed for reshaping data frames
library(reshape2)

#used for querying data, performing aggregations, filtering, etc.
library(sqldf)

myDataVerificationtest1 = read.table("C:/Users/Kirsten/Documents/Studie/Master/3dYear/Agent_Based/v9_afterverification experimenttest1-table.csv", skip = 6, sep = ",", head=TRUE)

summary(myDataVerificationtest1)

#this will also show you the names of the column names
colnames = colnames(myDataVerificationtest1)

##### Don't worry about what this means, it cleans up the column names   #####
##### You can just copy/paste it and re-use it, just make sure that      #####
##### if your data frame isn't called myDataFrame, then update that part #####
# Some colnames start with "X.", get rid of this 
colnames(myDataVerificationtest1) = gsub("X\\.", "", colnames(myDataVerificationtest1))
# Get rid of periods at the start and end of the names
colnames(myDataVerificationtest1) = gsub("^\\.|\\.$", "", colnames(myDataVerificationtest1))
# Convert all periods into underscores
colnames(myDataVerificationtest1) = gsub("\\.", "_", colnames(myDataVerificationtest1))

#remove the value at time is 0. Then all the marketshares are also still 0 and this influence the data
myDataVerificationtest1<-myDataVerificationtest1[!(myDataVerificationtest1$step == 0),]

#mean
mean(myDataVerificationtest1$total_consumers_RTP)
mean(myDataVerificationtest1$total_consumers_CPP)
mean(myDataVerificationtest1$total_consumers_ToU)
mean(myDataVerificationtest1$total_consumers_RTPH)

#testing kurtosis
library(e1071)  
kurtosis(myDataVerificationtest1$total_consumers_RTP)
kurtosis(myDataVerificationtest1$total_consumers_CPP)
kurtosis(myDataVerificationtest1$total_consumers_ToU)
kurtosis(myDataVerificationtest1$total_consumers_RTPH)

#testing skewness
skewness(myDataVerificationtest1$total_consumers_RTP)
skewness(myDataVerificationtest1$total_consumers_CPP)
skewness(myDataVerificationtest1$total_consumers_ToU)
skewness(myDataVerificationtest1$total_consumers_RTPH)

#see if this influence the variance
var(myDataVerificationtest1$total_consumers_RTP)
var(myDataVerificationtest1$total_consumers_CPP)
var(myDataVerificationtest1$total_consumers_ToU)
var(myDataVerificationtest1$total_consumers_RTPH)

#relative variance
sd(myDataVerificationtest1$total_consumers_RTP)/mean(myDataVerificationtest1$total_consumers_RTP)
sd(myDataVerificationtest1$total_consumers_CPP)/mean(myDataVerificationtest1$total_consumers_CPP)
sd(myDataVerificationtest1$total_consumers_ToU)/mean(myDataVerificationtest1$total_consumers_ToU)
sd(myDataVerificationtest1$total_consumers_RTPH)/mean(myDataVerificationtest1$total_consumers_RTPH)

