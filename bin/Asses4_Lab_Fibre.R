#~~~~~~~~~~~
# Libraries
#~~~~~~~~~~
library(tibble)
library(dplyr)
library(ggplot2)
library(tidyr)
#~~~~~~~~~~~
# Sources 
#~~~~~~~~~~
source("R/assess_func_lib.R")
source("R/miss_val.R")
# To use for fills, add
scale_fill_manual(values=colour_pallette::black_pal)
# To use for line and point colors, add
scale_colour_manual(values=colour_pallette::black_pal)
#~~~~~~~~~~~~
# Thresholds (out of bounds)
#~~~~~~~~~~~
Thresh.Fibre.min <- 4
Thresh.Fibre.max <- 25
Thresh.Fibre.delta <- .25
#~~~~~~~~~~~
# Input files
#~~~~~~~~~~
csv <- "Data/Raw1/Lab_Fibre_Weights.csv"
Lab_Fibre_Data <- read.csv(csv, header=T, sep=",", dec=".")
#~~~~~~~~~~~
# Check for missing values
#~~~~~~~~~~
Ns_Miss_Val(scData)
#~~~~~~~~~~~
# Calculate Percentage Fibre Variables
#~~~~~~~~~~
Lab_Fibre_Data$Fibre1 <- 100 * (Lab_Fibre_Data$InitialSampleCanWeight_1 - Lab_Fibre_Data$FinalSampleCanWeight_1) / Lab_Fibre_Data$SampleWeight_1

Lab_Fibre_Data <- mutate(Lab_Fibre_Data, Fibre2 = 100 * (InitialSampleCanWeight_2 - FinalSampleCanWeight_2) / SampleWeight_2)

#~~~~~~~~~~~
# Filter by is variable > 0
#~~~~~~~~~~
Lab_Fibre_Filter <- Lab_Fibre_Data %>%
  filter(SampleWeight_1 > 0, InitialSampleCanWeight_1 > 0, FinalSampleCanWeight_1 > 0, SampleWeight_2 > 0, InitialSampleCanWeight_2 > 0, FinalSampleCanWeight_2 > 0) %>%
  filter((Fibre1 - Fibre2) <= Thresh.Fibre.delta) 
#~~~~~~~~~~~
# Mutate the average for each columns
#~~~~~~~~~~
Lab_Fibre_Filter <- mutate(Lab_Fibre_Filter, Fibre = (Fibre1 + Fibre2)/2)
#~~~~~~~~~~~
# Filter by is by max min thresholds
#~~~~~~~~~~
Lab_Fibre_Filter <- Lab_Fibre_Filter %>%
  filter(Fibre > Thresh.Fibre.min)
  filter(Fibre < Thresh.Fibre.max)
#~~~~~~~~~~~
# Select only first and last column
#~~~~~~~~~~
Lab_Fibre <- Lab_Fibre_Filter %>%
  select(LabID, Fibre)

write.table(Lab_Fibre, "Data/aggregated_formatted4/Lab_Fibre.csv")


