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
Thresh.Brix.min <- 15
Thresh.Brix.max <- 30

Thresh.Pol.min <- 50
Thresh.Pol.max <- 105
ExpectedBrix.delta <- 1

Thresh.Fibre.min <- 4
Thresh.Fibre.max <- 25
Thresh.Fibre.delta <- .25

Thresh.Ash.min <- 0
Thresh.Ash.max <- 8


csv <- "Data/Raw1/Lab_Ash_Weights.csv"
Lab_Ash_Data <- read.csv(csv, header=T, sep=",", dec=".")
#~~~~~~~~~~~
# Filter out zero data, find InitialWeight and FinalWeight and 
# then make Ash variable a percentage
# Filter min max range for Ash
#~~~~~~~~~~
Lab_Ash_Calculated <- Lab_Ash_Data %>%
  filter(LabID > 0, TinWeight > 0, InitialSampleInTinWeight > 0, FinalSampleInTinWeight > 0) %>%
  mutate(InitialWeight  = InitialSampleInTinWeight - TinWeight) %>%
  mutate(FinalWeight  = FinalSampleInTinWeight - TinWeight) %>%
  mutate(Ash = 100 * FinalWeight / InitialWeight) %>%
  filter(Ash > Thresh.Ash.min) %>%
  filter(Ash < Thresh.Ash.max) 
#~~~~~~~~~~~
# Group rows by LabID then calculate the mean of Ash 
# Finally put into two columns LabID and Ash
#~~~~~~~~~~
Lab_Ash <- Lab_Ash_Calculated %>%
  group_by(LabID) %>%
  summarise(Ash = mean(Ash)) %>%
  select(LabID, Ash)

write.csv(Lab_Ash, "Data/aggregated_formatted4/Lab_Ash.csv")
