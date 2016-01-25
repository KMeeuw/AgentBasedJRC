#This is the verification test with Informationstrategy increasevalue is 5

options(stringsAsFactors = FALSE)

#Note that plot() is not the same as ggplot()
#these are from two separate packages
library(ggplot2)

# needed for reshaping data frames
library(reshape2)

#used for querying data, performing aggregations, filtering, etc.
library(sqldf)

myDataVerificationtest4 = read.table("C:/Users/Kirsten/Documents/Studie/Master/3dYear/Agent_Based/v9_afterverification experiment1000test2-table.csv", skip = 6, sep = ",", head=TRUE)

#this will also show you the names of the column names
colnames = colnames(myDataVerificationtest4)

##### Don't worry about what this means, it cleans up the column names   #####
##### You can just copy/paste it and re-use it, just make sure that      #####
##### if your data frame isn't called myDataFrame, then update that part #####
# Some colnames start with "X.", get rid of this 
colnames(myDataVerificationtest4) = gsub("X\\.", "", colnames(myDataVerificationtest4))
# Get rid of periods at the start and end of the names
colnames(myDataVerificationtest4) = gsub("^\\.|\\.$", "", colnames(myDataVerificationtest4))
# Convert all periods into underscores
colnames(myDataVerificationtest4) = gsub("\\.", "_", colnames(myDataVerificationtest4))

#remove the value at time is 0. Then all the marketshares are also still 0 and this influence the data
myDataVerificationtest4<-myDataVerificationtest4[!(myDataVerificationtest4$step == 0),]

#mean
mean(myDataVerificationtest4$total_consumers_RTP)
mean(myDataVerificationtest4$total_consumers_CPP)
mean(myDataVerificationtest4$total_consumers_ToU)
mean(myDataVerificationtest4$total_consumers_RTPH)

#testing kurtosis
library(e1071)  
kurtosis(myDataVerificationtest4$total_consumers_RTP)
kurtosis(myDataVerificationtest4$total_consumers_CPP)
kurtosis(myDataVerificationtest4$total_consumers_ToU)
kurtosis(myDataVerificationtest4$total_consumers_RTPH)

#testing skewness
skewness(myDataVerificationtest4$total_consumers_RTP)
skewness(myDataVerificationtest4$total_consumers_CPP)
skewness(myDataVerificationtest4$total_consumers_ToU)
skewness(myDataVerificationtest4$total_consumers_RTPH)

#see if this influence the variance
var(myDataVerificationtest4$total_consumers_RTP)
var(myDataVerificationtest4$total_consumers_CPP)
var(myDataVerificationtest4$total_consumers_ToU)
var(myDataVerificationtest4$total_consumers_RTPH)

#relative variance
sd(myDataVerificationtest4$total_consumers_RTP)/mean(myDataVerificationtest4$total_consumers_RTP)
sd(myDataVerificationtest4$total_consumers_CPP)/mean(myDataVerificationtest4$total_consumers_CPP)
sd(myDataVerificationtest4$total_consumers_ToU)/mean(myDataVerificationtest4$total_consumers_ToU)
sd(myDataVerificationtest4$total_consumers_RTPH)/mean(myDataVerificationtest4$total_consumers_RTPH)