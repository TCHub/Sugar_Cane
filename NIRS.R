#~~~~~~~~~~~
# Libraries
#~~~~~~~~~~
library(dplyr)
library(ggplot2)
library(tidyr)

#~~~~~~~~~~~~
# Sources
#~~~~~~~~~~~
source("R/assess_func_lib.R")

#~~~~~~~~~~~~
# Thresholds
#~~~~~~~~~~~
Thresh.Brix.min <- 15
Thresh.Brix.max <- 30

Thresh.Pol.min <- 50
Thresh.Pol.max <- 105

Thresh.Fibre.min <- 4
Thresh.Fibre.max <- 25

Thresh.Ash.min <- 0
Thresh.Ash.max <- 8

Thresh.GH <- 3.5
Thresh.NH <- 2
#~~~~~~~~~~~~
# Input
#~~~~~~~~~~~
csv <-  "Data/Raw1/NIRPred.csv"
NIRData <- read.csv(csv, sep= ",", dec= ".")

#~~~~~~~~~~~~
# Analyse first 15 rows
#~~~~~~~~~~~
summary(NIRData[1:15,])

#~~~~~~~~~~~~
# Change NIRData data and time to suit R date time formats
#~~~~~~~~~~~
NIRData$DateTime <- as.POSIXct(NIRData$DateTime, format = "%Y-%m-%d%H:%M:%S")

#~~~~~~~~~~~~
# ScanID is also LabID, A new column is created called “LabID”
# floor is used to create an integer value from ScanID that becomes 
# the values for “LabID”. Use NIRData[1:15,c("ScanID", "LabID")] to check results
#~~~~~~~~~~~
NIRData <- NIRData %>%
  transform(ScanID, LabID = floor(ScanID))

#~~~~~~~~~~~~
# Use a PIPE to sequentially filter the NIR data by filtering out any 
# (a) GH values greater than 3.5, (b) NH values greater than 2, 
# (c) any out-of-range values for Pol, Brix, Fibre and Ash and 
# (d) any sample that has a ScanID equal to -1. Save the filtered data to a new data table called NIRData_Filtered.  Enter your R code:
#~~~~~~~~~~~
#~~~~~~~~~~~~
# Keep rows where;
# - GH is less than 3.5
# - NH is less than 2
# - Inside Max and Min for NIR_Pol, Brix, Fibre and Ash
# - ScanID <= 0
#~~~~~~~~~~
NIRData <- NIRData %>%
  filter(GH < Thresh.GH) %>%
  filter(NH < Thresh.NH) %>%
  filter(NIR_Pol > Thresh.Pol.min) %>%
  filter(NIR_Pol < Thresh.Pol.max ) %>%
  filter(NIR_Brix > Thresh.Brix.min) %>%
  filter(NIR_Brix < Thresh.Brix.max) %>%
  filter(NIR_Fibre > Thresh.Fibre.min) %>%
  filter(NIR_Fibre < Thresh.Fibre.max) %>%
  filter(NIR_Ash > Thresh.Ash.min) %>%
  filter(NIR_Ash < Thresh.Ash.max) %>%
  filter(ScanID <= 0)
  