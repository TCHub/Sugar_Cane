import pandas as ps
from sys import argv

scripts, column, file_one, file_two = argv
# Read files to be checked
file1 = ps.read_csv(file_one)
file2 = ps.read_csv(file_two)
# Convert files to round
round_file1 =file1[column].round(2)
round_file2 =file2[column].round(2)
# Check if rf1 is match to rf2
file_output = round_file1.isin(round_file2)
print(file_output)
