# Uses Pol value(s) as input
# Expected Brix is calculated, 
# If Expected Brix measurement between Expected Brix is greater than 1
# Then there was problem in collecting either the Brix or Pol measurements
ExpectedBrix <- function(x){
  (x*0.21084778699754 + 4.28455310831511)
}