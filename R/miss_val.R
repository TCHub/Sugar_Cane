#
# Counts the missing value of single column
# leave x empty if you wish to use with Ns_Miss_Val

Count_Miss_Val <- function(x) {
  sum(is.na(x))
}

#
# Uses Count_Miss_Val to do all columns
# MARGIN = 2 (columns), MARGIN = 1 (Rows)
Ns_Miss_Val <- function(Data) {
  CMV <- Count_Miss_Val
  apply(Data, MARGIN = 2, FUN = CMV)
}