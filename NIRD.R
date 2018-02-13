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
# Show first 15 rows of "ScanID" and "LabID"
#~~~~~~~~~~~
NIRData[1:15, c("ScanID", "LabID")]

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
NIRData_Filtered <- NIRData %>%
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
  filter(ScanID >= 0)

#~~~~~~~~~~~~
# Use a PIPE with the  grouped_by() and summarize() functions on the
# NIRData_Filtered table to produce a data table called NIR_Final which
# is grouped by LabID and contains, in addition to the grouped variable,
# the first DateTime for each group as well as the corresponding mean 
# values for Pol, Brix, Fibre and Ash (i.e. the group means). Hint: 
# the min() function returns the earliest date/time when applied to
# a date/time type variable. Enter your R code you used then enter
# the first fifteen rows of the updated NIR_Final table:
#~~~~~~~~~~~  
#~~~~~~~~~~~~
# Group by LabID
# Find the minimun DateTime 
# Find the mean of NIR_Pol NIR_Brix, NIR_Fibre and NIR_Ash
#~~~~~~~~~~~
NIR_Final <- NIRData_Filtered %>%
  group_by(LabID) %>%
  summarize(DateTime = min(DateTime), NIR_Pol = mean(NIR_Pol),
            NIR_Brix = mean(NIR_Brix), NIR_Ash = mean(NIR_Ash),
            NIR_Fibre = mean(NIR_Fibre))

#~~~~~~~~~~~~
# Show First 15 rows
#~~~~~~~~~~~
NIR_Final[1:15, ]
#~~~~~~~~~~
# Write to disk
#~~~~~~~~~
write.table(NIR_Final, file = "output/NIR_Final.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")