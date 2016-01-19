

#test on small dataset
Contracttype = c("RTP", "RTP","RTP", "RTP", "CPP", "CPP","CPP", "CPP", "ToU", "ToU","ToU", "ToU", "RTPH", "RTPH", "RTPH", "RTPH")
Step = c(10, 60, 10, 60, 10, 60, 10, 60,10, 60, 10, 60, 10, 60, 10, 60)
Number_of_Consumers = c(0, 1000, 0, 1200, 500, 700, 2400, 2400, 1000, 0, 1200, 500, 700, 2400, 2400, 0)
Runnumber = c(1,1,2,2,1,1,2,2,1,1,2,2,1,1,2,2)
infostrategy_increasevalue = c(1, 2.5, 3, 5, 1, 2.5, 3, 5, 1, 2.5, 3, 5, 1, 2.5, 3, 5 )
testdataframe = data.frame(Contracttype, Step, Number_of_Consumers, Runnumber, infostrategy_increasevalue)
library(car)
scatterplot(Number_of_Consumers ~ Step, group=Contracttype, data = testdataframe, xlab="Time", ylab="Number of Consumers", main = "Consumers")

#test (old)
library(car)
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=0 & infostrategy_increasevalue < 0.5), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=0.5 & infostrategy_increasevalue < 1), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=1 & infostrategy_increasevalue < 1.5), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=1.5 & infostrategy_increasevalue < 2), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=2.5 & infostrategy_increasevalue < 3), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=3 & infostrategy_increasevalue < 3.5), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >=3.5 & infostrategy_increasevalue < 4), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >4 & infostrategy_increasevalue < 4.5), xlab="Time", ylab="Number of Consumers", main = "Consumers")
scatterplot(Number_of_Consumers ~ Step, reg.line = FALSE, smoother = FALSE, group=Contracttype, by.group = FALSE, data = subset(total, infostrategy_increasevalue >4.5 & infostrategy_increasevalue < 5), xlab="Time", ylab="Number of Consumers", main = "Consumers")

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
xyplot(Infostrategy ~ Step | Contracttype, data = total, xlab="Time", ylab="Infostrategy", main = "Infostrategy used", layout= c(1,4))

library(car)
scatterplotMatrix(~ Step + Infostrategy + Marketshare | Contracttype, data = total )