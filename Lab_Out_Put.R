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
#~~~~~~~~~~~
# Files
#~~~~~~~~~~
csv1 <- ("Data/aggregated_formatted4/Lab_Ash.csv")
csv2 <- ("Data/aggregated_formatted4/Lab_Fibre.csv")
csv3 <- ("Data/aggregated_formatted4/Lab_PB.csv")
#~~~~~~~~~~~
# Sources 
#~~~~~~~~~~
Lab_Ash <- read.csv(csv1)
Lab_Fibre <- read.csv(csv2)
Lab_PB <- read.csv(csv3)
#~~~~~~~~~~~
# join the Fibre and Ash tables together 
#~~~~~~~~~~
Lab <- full_join(Lab_Ash, Lab_Fibre, by=c("LabID" = "LabID"))
#~~~~~~~~~~~
# Join the existing Lab data table to the Lab_PB data table.  
# Enter you R code and the first eleven rows of the combined Lab data table.
# Hint: Use Lab[1:11,] to display the top 11 rows 
#~~~~~~~~~~
Lab <- full_join(Lab, Lab_PB, by=c("LabID" = "LabID"))

Lab[1:11, ]
#~~~~~~~~~~
# Write to output to directory
#~~~~~~~~~
write.table(Lab, file = "output/Lab_Out.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")
#~~~~~~~~~~
# Use transform() to transform the Fibre measurements from the Lab_Fibre table
# using the provided z_stand() function.  Then save the resulting table 
# (containing variables LabID and Fibre) to a file on disk.  Enter the R
# code you use to perform both actions
#~~~~~~~~~
File_Fibre_Out <- transform(Lab_Fibre, Fibre = z_stand(Fibre))
write.table(File_Fibre_Out, file = "output/Lab_Fibre_Out.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")
#~~~~~~~~~~
# Use a pipe with two subsequent transform() operations to transform 
# the Ash measurements from the Lab_Ash table, first using log10(), 
# and then using z_stand().  Save the resulting table (containing variables LabID and Ash)
# to a file on disk.  Enter the R code you use to perform both actions.
#~~~~~~~~~

File_Ash_Out <- Lab_Ash %>%
  transform(Ash = log10(Ash)) %>%
  transform(Ash = z_stand(Ash))

write.table(File_Ash_Out, file = "output/File_Ash_Out.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")
#~~~~~~~~~~
# Use the following R code to create a variable which can be subsequently
# used for stratified sub-sampling:
#~~~~~~~~~
Lab_PB$Bbin <- cut(Lab_PB$Brix, 40, labels = FALSE)
#~~~~~~~~~~
# Use the following R code to re-cast the Bbin variable as ordinal,
# so it can be used for stratified sub-sampling:
#~~~~~~~~~
Lab_PB$Bbin <- as.factor(Lab_PB$Bbin)
#~~~~~~~~~~
# Use the group_by() function then the sample_n() function to perform
# stratified sampling on the Brix meansurements, using Bbin as the grouping
# variable and size=50 for the number of samples in each stratification. 
# Name the resulting data table as Lab_B_Stratified_Balanced. Note: sample_n()
# will need to use attribute replace = TRUE, as not all groups have fifty samples.
# Enter the R code you use to perform both actions.
#~~~~~~~~~
Lab_B_Stratified_Balanced <- Lab_PB %>%
  group_by(Bbin) %>%
  sample_n(size = 50, replace = TRUE)
#~~~~~~~~~
# Use transform() with rescale_01() to rescale the Brix measurements in 
# Lab_B_Stratified_Balanced. Then, use select() to select only the LabID and Brix
# variables, and write the resulting data table to a csv file.  
# Enter the R code you use to perform the three actions.
#~~~~~~~~
File_Brix_Out <- Lab_B_Stratified_Balanced %>%
  transform(Brix = rescale_01(Brix)) %>%
  select(LabID, Brix)

write.table(File_Brix_Out, file = "output/File_Brix_Out.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")
#~~~~~~~~~~
# Use a pipe to repeat the stratified sub-sampling method used for Brix, 
# but now for Pol. Then write the LabID and the (stratified, sub-sampled, rescaled)
# Pol vales to a file.  Enter the R code you use to perform both actions.
File_Pol_Out <- Lab_B_Stratified_Balanced %>%
  transform(Pol = rescale_01(Pol)) %>%
  select(LabID, Pol)

write.table(File_Pol_Out, file = "output/File_Pol_Out.csv", append = FALSE, quote = TRUE, sep = ",",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE, col.names = TRUE,
            qmethod = c("escape", "double"), fileEncoding = "")