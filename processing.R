#script to split the tables of the collection for each case-study

# Load required libraries
library(tidyverse)

# Create collection directory if it doesn't exist
dir.create("collection", showWarnings = FALSE)

# Read the TSV file
data <- read_tsv("curation_file_MAIN.tsv")

# Create vectors of column names and their corresponding output file names
columns <- c("steatosis", "cholestasis", "crystallopathy", "tub.necrosis", "cfd", "ntc")

# Function to filter and save IDs
filter_and_save <- function(data, column_name) {
  # Filter rows where the specified column equals 1 and select only the ID
  filtered_data <- data %>%
    filter(.data[[column_name]] == 1) %>%
    select(id)
  
  # Create output filename with path
  output_file <- file.path("collection", paste0(column_name, "_ids.txt"))
  
  # Write to file
  write_lines(filtered_data$id, output_file)
  
  # Print summary
  cat(sprintf("Created %s with %d IDs\n", output_file, nrow(filtered_data)))
}

# Process each column and create corresponding output files
for(col in columns) {
  filter_and_save(data, col)
}

cat("\nProcessing complete. Files created in 'collection' folder:\n")
cat(paste0("- ", columns, "_ids.txt\n"))




##############################################################################
### Create a unique file with all relevant pathways
# Get list of all files in the collection folder

files <- list.files(path = "collection", full.names = TRUE)

# Create empty vector to store all values
all_values <- c()

# Read each file and append its contents to all_values
for (file in files) {
  # Read the file content
  # Using readLines to handle text files - adjust if your files have different format
  file_content <- readLines(file)
  
  # Append the content to our main vector
  all_values <- c(all_values, file_content)
}

# Remove duplicates
unique_values <- unique(all_values)

# Write the unique values to ontox.txt
writeLines(unique_values, "ontox.txt")

# Print confirmation message
cat("Process completed. Unique values have been written to ontox.txt\n")
