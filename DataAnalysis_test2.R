#metric 1
library(lattice)
library(latticeExtra)
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=0 & infostrategy_increasevalue < 0.5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 0 < infostrategy > 0.5 ", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=0.5 & infostrategy_increasevalue < 1), xlab="Time", ylab="Number of Consumers", main = "Consumers for 0.5 < infostrategy > 1", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=1 & infostrategy_increasevalue < 1.5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 1 < infostrategy > 1.5", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=1.5 & infostrategy_increasevalue < 2), xlab="Time", ylab="Number of Consumers", main = "Consumers for 1.5 < infostrategy > 2", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=2 & infostrategy_increasevalue < 2.5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 2 < infostrategy > 2.5", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=2.5 & infostrategy_increasevalue < 3), xlab="Time", ylab="Number of Consumers", main = "Consumers for 2.5 < infostrategy > 3", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=3 & infostrategy_increasevalue < 3.5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 3 < infostrategy > 3.5", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=3.5 & infostrategy_increasevalue < 4), xlab="Time", ylab="Number of Consumers", main = "Consumers for 3.5 < infostrategy > 4", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=4 & infostrategy_increasevalue < 4.5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 4 < infostrategy > 4.5", layout= c(1,4)) + layer( panel.loess(x, y, span=0.75, col='red') ) + layer( panel.lmline(x, y) )
xyplot(Number_of_Consumers ~ Step | Contracttype, data = subset(total, infostrategy_increasevalue >=4.5 & infostrategy_increasevalue < 5), xlab="Time", ylab="Number of Consumers", main = "Consumers for 4.5 < infostrategy > 5", layout= c(1,4))
xyplot(Number_of_Consumers ~ Step | Contracttype, data = total, xlab="Time", ylab="Number of Consumers", main = "Total number of Consumers", layout= c(1,4))

summary(myDataAnalysis$total_consumers_RTP)
summary(myDataAnalysis$total_consumers_CPP)
summary(myDataAnalysis$total_consumers_ToU)
summary(myDataAnalysis$total_consumers_RTPH)

#metric 2
xyplot(Contractattributevalue ~ Step | Contractattribute, data = totalContractattribute,xlab="Time", ylab="Contractattribute value", main = "Development of Contract attributes", layout=c(1,3) )
xyplot(Contractattributevalue_corrected ~ Step | Contractattribute, data = totalContractattribute,xlab="Time", ylab="Contractattribute value", main = "Development of Contract attributes corrected by marketshares", layout=c(1,3) )
summary(myDataAnalysis$total_financial_correctedbymarketshare)
summary(myDataAnalysis$total_social_gains_correctedbymarketshare)
summary(myDataAnalysis$total_privsec_correctedbymarketshare)
sd(myDataAnalysis$total_financial_correctedbymarketshare)
sd(myDataAnalysis$total_social_gains_correctedbymarketshare)
sd(myDataAnalysis$total_privsec_correctedbymarketshare)

#metric3
cloud(Infostrategy ~ Step*Marketshare | Contracttype, data = total, xlab="Time", ylab="Marketshare", zlab="Information strategie", main = "Infostrategies over time by marketshare", scales = list(z = list(arrows = FALSE, distance = 3), x = list(arrows =FALSE, distance = 2), y = list(arrows = FALSE, distance = 2)))