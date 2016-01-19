options(stringsAsFactors = FALSE)

#Note that plot() is not the same as ggplot()
#these are from two separate packages
library(ggplot2)

# needed for reshaping data frames
library(reshape2)

#used for querying data, performing aggregations, filtering, etc.
library(sqldf)

myDataAnalysis = read.table("C:/Users/Kirsten/Documents/GitHub/AgentBasedJRC/v9_afterverification ExperimentLHSbased2-table.csv", skip = 6, sep = ",", head=TRUE)

#this will also show you the names of the column names
colnames = colnames(myDataAnalysis)

##### Don't worry about what this means, it cleans up the column names   #####
##### You can just copy/paste it and re-use it, just make sure that      #####
##### if your data frame isn't called myDataFrame, then update that part #####
# Some colnames start with "X.", get rid of this 
colnames(myDataAnalysis) = gsub("X\\.", "", colnames(myDataAnalysis))
# Get rid of periods at the start and end of the names
colnames(myDataAnalysis) = gsub("^\\.|\\.$", "", colnames(myDataAnalysis))
# Convert all periods into underscores
colnames(myDataAnalysis) = gsub("\\.", "_", colnames(myDataAnalysis))

#(optional) remove the value at time is 0. Then all the marketshares are also still 0 and this influence the data
myDataAnalysis<-myDataAnalysis[!(myDataAnalysis$step == 0),]

dataframeforRTP2 = data.frame("Contracttype" = "RTP", "Step" = myDataAnalysis$step, "Number_of_Consumers" = myDataAnalysis$total_consumers_RTP, "Marketshare" = myDataAnalysis$marketshare_RTP, "infostrategy_increasevalue" = myDataAnalysis$infostrategy_increasevalue, "percentage_unresponsive_consumers" = myDataAnalysis$percentage_unresponsive_consumers, "Runnumber" = myDataAnalysis$run_number, "Infostrategy" = myDataAnalysis$info_RTP)
dataframeforCPP = data.frame("Contracttype" = "CPP", "Step" = myDataAnalysis$step, "Number_of_Consumers" = myDataAnalysis$total_consumers_CPP, "Marketshare" = myDataAnalysis$marketshare_CPP,  "infostrategy_increasevalue" = myDataAnalysis$infostrategy_increasevalue, "percentage_unresponsive_consumers" = myDataAnalysis$percentage_unresponsive_consumers, "Runnumber" = myDataAnalysis$run_number, "Infostrategy" = myDataAnalysis$info_CPP)
dataframeforToU = data.frame("Contracttype" = "ToU", "Step" = myDataAnalysis$step, "Number_of_Consumers" = myDataAnalysis$total_consumers_ToU, "Marketshare" = myDataAnalysis$marketshare_ToU, "infostrategy_increasevalue" = myDataAnalysis$infostrategy_increasevalue, "percentage_unresponsive_consumers" = myDataAnalysis$percentage_unresponsive_consumers, "Runnumber" = myDataAnalysis$run_number, "Infostrategy" = myDataAnalysis$info_ToU)
dataframeforRTPH = data.frame("Contracttype" = "RTPH", "Step" = myDataAnalysis$step, "Number_of_Consumers" = myDataAnalysis$total_consumers_RTPH, "Marketshare" = myDataAnalysis$marketshare_RTPH, "infostrategy_increasevalue" = myDataAnalysis$infostrategy_increasevalue, "percentage_unresponsive_consumers" = myDataAnalysis$percentage_unresponsive_consumers, "Runnumber" = myDataAnalysis$run_number, "Infostrategy" = myDataAnalysis$info_RTPH) 
total <-rbind(dataframeforRTP, dataframeforCPP, dataframeforToU, dataframeforRTPH)

dataframefinancial = data.frame("Contractattribute" = "Financial", "Contractattributevalue" = myDataAnalysis$total_financial,"Contractattributevalue_corrected" = myDataAnalysis$total_financial_correctedbymarketshare, "Step" = myDataAnalysis$step)
dataframesocial = data.frame("Contractattribute" = "Social" , "Contractattributevalue" = myDataAnalysis$total_social_gains,"Contractattributevalue_corrected" = myDataAnalysis$total_social_gains_correctedbymarketshare, "Step" = myDataAnalysis$step)
dataframeprivsec = data.frame("Contractattribute" = "Privsec", "Contractattributevalue" = myDataAnalysis$total_privsec,"Contractattributevalue_corrected" = myDataAnalysis$total_privsec_correctedbymarketshare, "Step" = myDataAnalysis$step)
totalContractattribute <- rbind(dataframefinancial, dataframesocial, dataframeprivsec)

