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

#~~~~~~~~~~~
# Input files
#~~~~~~~~~~
csv <- "Data/Sugar_Cane_Input_Files/Raw1/Lab_Fibre_Weights.csv"
Lab_Fibre_Data <- read.csv(csv, header=T, sep=",", dec=".")
#~~~~~~~~~~~
# Check for missing values
#~~~~~~~~~~
Ns_Miss_Val(scData)
#~~~~~~~~~~~
# Calculate Percentage Fibre Variables
#~~~~~~~~~~
Lab_Fibre_Data$Fibre1 <- 100 * (Lab_Fibre_Data$InitialSampleCanWeight_1 - Lab_Fibre_Data$FinalSampleCanWeight_1) / Lab_Fibre_Data$SampleWeight_1

#Lab_Fibre_Data$Fibre2 <- mutate(Lab_Fibre_Data, Total =100 * (InitialSampleCanWeight_2 - FinalSampleCanWeight_2) / SampleWeight_2)
Lab_Fibre_Data <- mutate(Lab_Fibre_Data, Fibre2 = 100 * (InitialSampleCanWeight_2 - FinalSampleCanWeight_2) / SampleWeight_2)
#~~~~~~~~~~~
# Creates a visually friend seperation between Fibre1 and Fibre2 (not drop)  
#~~~~~~~~~~
Lab_Fibre_Data <- Lab_Fibre_Data %>%
  select(-InitialSampleCanWeight_2, -FinalSampleCanWeight_2, -SampleWeight_2)
#~~~~~~~~~~~
# Input Lab_Fibre_Data
#~~~~~~~~~~
Lab_Fibre_Data <- read.csv(csv, header=T, sep=",", dec=".")
#~~~~~~~~~~~
# Filter by is variable > 0
#~~~~~~~~~~
Lab_Fibre_Filter <- Lab_Fibre_Data %>%
  select(SampleWeight_1, InitialSampleCanWeight_1, FinalSampleCanWeight_1, SampleWeight_2, InitialSampleCanWeight_2, FinalSampleCanWeight_2) %>%
  filter(SampleWeight_1 > 0, InitialSampleCanWeight_1 > 0, FinalSampleCanWeight_1 > 0, SampleWeight_2 > 0, InitialSampleCanWeight_2 > 0, FinalSampleCanWeight_2 > 0)