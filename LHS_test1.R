#Lets load the lhs library
library(lhs)
library(ggplot2)

#We will use the optimum lhs algorithm
#see http://rss.acs.unt.edu/Rdoc/library/lhs/html/optimumLHS.html

#Model design parameters
numberOfExperiments = 50	# How many experiments can we afford ?
numberOfParameters = 2

#Algorithm settings
maxSweeps=20	 		# The maximum number of times the algorithm may iterate ?
eps=.1				# The optimal stopping criterion

#we need to put the matrix in a data frame, so it gets headers etc, so we can work with it.
lhs=data.frame(optimumLHS(numberOfExperiments, numberOfParameters, maxSweeps, eps))

#make a histogram of each variable.
#We will do this to visualy inspect the uniformity of the data.

#We need to put the data in a two columns [ variable, value], or [X1, 0.223], so that we can plot it.
lhsMelt = melt(lhs)

#We will use 30 bins for each histogram
simpleHistogram = ggplot(data=lhsMelt, aes(x=value)) + geom_histogram(binwidth = 0.03) + facet_wrap(~ variable, scales="free") 
print(simpleHistogram)
ggsave(simpleHistogram, file="ExperimentDistributionHistogram.png") 


colnames(lhs)[1] = "infostrategy_increasevalue"
colnames(lhs)[2]= "percentage_unresponsive_consumers"
#Now we must scale the sample values so that we get paramter values out.
#LSH gives you numbers from [0 1]
#There are a few ways to do this.
#1. our parameter value goes from [0  X]
#2. we have a base value and add a arange to it [x+0 x+y]
#3. a parameter is a boolean
#4. a parameter is a switch 1,2,3

#infostrategy_increasevalue whould be sweeped from [0 5]
lhs$infostrategy_increasevalue = lhs$infostrategy_increasevalue*5

#percentage_unresponsive_consumers whould be sweeped from [0.4 0.6]
lhs$percentage_unresponsive_consumers = 0.4 + lhs$percentage_unresponsive_consumers*0.2

#Now, lets save the data to a space separated file, no row or column names. 
#Note that we ARE NOT using CSV, as NetLogos file-read function expects space separated values
#You have to be careful when you read the experiment into NetLogo, to get the same order of parameters right.
write.table(lhs,file="lhsExperiment.data",sep=" ",row.names = FALSE,col.names = FALSE,quote = FALSE)

#This data file can be read into NetLogo and parameter values set up. See LhsExperiment.nlogo for a exampel how to do this.