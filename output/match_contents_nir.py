import pandas as ps
from sys import argv

scripts, file_one, file_two = argv
# Read files to be checked
file1 = ps.read_csv(file_one)
file2 = ps.read_csv(file_two)
file_output = file1.isin(file2)
print(file_output)
