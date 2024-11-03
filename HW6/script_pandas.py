print('## Program: script_pandas.py') 
print('###### filters the dataset according to the column sum')

import pandas as pd

# Load the data
data = pd.read_csv("episode_word_counts.csv")  # Replace with your actual file path

# Obtaining the number of columns
print(f"The number of columns in the dataset is: {data.shape[1]}")

# Calculate the column sum for numerical columns
column_sums = data.select_dtypes(include=['number']).sum()

# Define the columns that we would keep in the dataset
keep_cols = column_sums[column_sums >= 100].index

# Get the filtered data
filtered_data = data[keep_cols]
print(f"The number of columns after filtering the dataset is: {filtered_data.shape[1]}")

# Write to a CSV file
filtered_data.to_csv("filtered_data.csv", index=False)
print("the filtered_data.csv file was saved")
