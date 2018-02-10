#~~~~~~~~~~~
# Libraries
#~~~~~~~~~~
library(dplyr)
library(ggplot2)
library(tidyr)
#~~~~~~~~~~~
# Sources 
#~~~~~~~~~~
source("R/assess_func_lib.R")
#~~~~~~~~~~~~
# Thresholds (out of bounds)
#~~~~~~~~~~~
Thresh.Brix.min <- 15
Thresh.Brix.max <- 30

Thresh.Pol.min <- 50
Thresh.Pol.max <- 105
ExpectedBrix.delta <- 1

#~~~~~~~~~~~~
# Input file
#~~~~~~~~~~~
csv <- "Data/Raw1/Lab_Pol_Brix.csv"
Lab_PB_Data <- read.csv(csv, header=T, sep=",", dec=".")
#~~~~~~~~~~~~
# Use the mutate() function to add to the data table Lab_PB_Data a new variable,
# PredBrix, which uses the ExpectedBrix function with Pol as input.  Enter your R code you used
#~~~~~~~~~~~
Lab_PB_Data <- Lab_PB_Data %>%
  mutate(PredBrix = ExpectedBrix(Pol))
#~~~~~~~~~
# Scatter plot of Brix vs Pred > 1 overlayed on x Pol y Brix
#~~~~~~~~
PB_Scatter_Map <- ggplot(Lab_PB_Data, aes(x=Pol, y=Brix, colour=(abs(Brix-PredBrix) > ExpectedBrix.delta))) +
  scale_colour_manual(name = 'Samples Excluded', values = setNames(c("#000000","#E69F00"),c(T, F)))
PB_Scatter_Map  + geom_point(shape=19, position=position_jitter(width=1,height=.5), alpha=0.25)
#~~~~~~~~~
# Use a PIPE to sequentially filter out undesirable rows from Lab_PB_Data, and then select only a 
# subset of its variables, as follows: first, filter out samples (rows) where
# (a) the absolute difference between the measured Brix and predicted Brix is greater than one, and/or 
# (b) any value for Pol or Brix are out of range (the min. and max. values are specified in the 
# threshold variables we initially set-up, namely, Thresh.Brix.min, Thresh.Brix.max, 
# Thresh.Pol.min, and Thresh.Pol.max). 
# Then, (c) select only the variables LabID, Pol and Brix to constitute a new data table, called Lab_PB
#~~~~~~~~

Lab_PB <- Lab_PB_Data %>%
  filter((abs(Brix-PredBrix) < ExpectedBrix.delta)) %>%
  filter(Pol > Thresh.Pol.min) %>%
  filter(Pol < Thresh.Pol.max) %>%
  filter(Brix > Thresh.Brix.min) %>%
  filter(Brix < Thresh.Brix.max) %>%
  select(LabID, Pol, Brix)

#~~~~~~~~~~
# Write to output to directory
#~~~~~~~~~
write.table(Lab_PB, file = "Data/aggregated_formatted4/Lab_PB.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")