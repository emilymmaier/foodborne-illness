#!/usr/bin/env Rscript

# Author: Emily Maier
# Last Updated: 18/09/2023
# Purpose: Perform cross correlation analysis to determine if there is a significant correlation between symptom keywords and number of cases in the five weeks preceeding and following a foodborne illness outbreak

#### FUNCTIONS ####

# Compile all cross correlation analysis results into one dataframe
ccfResults <- function(dfOutput, inFile, dfData, sympCol, week, acf, n) {

  # Name of online data source
  datSource <- inFile[[1]][2]
  # Name of foodborne illness
  ill <- inFile[[1]][1]
  # Symptom keyword
  symp <- colnames(dfData[sympCol])
 
  # For each lag between +-5 
  for (i in 1:length(acf)) {

    # Lag
    wk <- week[i]
    # Correlation coefficient
    corrVal <- acf[i]

    # Calculate the pvalue of the correlation, where the null hypothesis is no correlation
    p <- 2 * (1 - pnorm(abs(acf[i]), mean = 0, sd = 1/sqrt(n)))

    # Identify the pvalue as significant or not, where alpha = 0.05
    if (p <= 0.05) {
      sig <- 1
    } else {
      sig <- 0
    }

    # Create a new row in the dataframe containing this info
    dfOutput[nrow(dfOutput)+1,] <- c(datSource, ill, symp, wk, corrVal, p, sig)

  }
  return(dfOutput)

}

#### PACKAGES ####

library(stringr)

#### DATA ####

# Get name of folder containing files to be analyzed from command line
args <- commandArgs(trailingOnly = TRUE)

# Throw an error if directory name is not given
if (length(args)==0) {
  stop("Please provide the name of the folder containing files to be analyzed as well as the desired name of the output file", call.=FALSE)
}

# Get a list of files in the specified directory
setwd(args[1])
lFiles <- list.files()

#wd <- setwd("/Users/emilymaier/Documents/Foodborne_Illness/Data")
#lFiles <- list.files(path = wd)

# Create a dataframe to store results
dfResults <- data.frame(data_source = character(), illness = character(), symptom = character(), lag = numeric(), correlation = numeric(), pvalue = numeric(), significant = numeric())


#### ANALYSIS ####

for (dataFile in lFiles) {

  # Create dataframe
  dfOutbreakData <- as.data.frame(read.csv(dataFile))

  # Format date column
  dfOutbreakData$date <- as.Date(dfOutbreakData$date, "%Y-%m-%d")

  # Get illness and data source from file name
  inFileName <- str_split(dataFile, "_")

  # Get start year and end year of data
  startYear <- format(as.Date(min(dfOutbreakData[,1])), "%Y")
  endYear <- format(as.Date(max(dfOutbreakData[,1])), "%Y")

  # Create time series for weekly number of cases
  tsCases <- ts(dfOutbreakData[,2], start = c(startYear,01), end = c(endYear, 52), frequency = 52)

  # For each symptom keyword, assess the correlation with the number of cases +- lag 5
  for (symptomColumn in 3:ncol(dfOutbreakData)) {
    
    # Create time series for weekly number of symptom keywords
    tsSymptom <- ts(dfOutbreakData[,symptomColumn], start = c(2017,01), end = c(2019, 52), frequency = 52)

    # Cross Correlation between symptom keyword and number of cases cases
    crossCorrelation <- ccf(data.frame(tsSymptom), data.frame(tsCases), lag = 5, main = (paste(inFileName[[1]][2], inFileName[[1]][1], colnames(dfOutbreakData[symptomColumn]))))
    # Put line lag = 0 for clarity of visualization
    abline(v = 0, col = "red", lty = 2)

    # Create dataframe to store results of cross correlation analysis
    dfResults <- ccfResults(dfResults, inFileName, dfOutbreakData, symptomColumn, crossCorrelation$lag, crossCorrelation$acf, crossCorrelation$n.used)
  }

}

#### WRITE TO CSV ###

write.csv(dfResults, file = args[2])
