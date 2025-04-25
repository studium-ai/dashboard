library(openxlsx)

# Load the existing workbook
wb <- loadWorkbook("combined_data.xlsx")

# Add new worksheet
addWorksheet(wb, "MD")

# Define styles
sectionHeaderStyle <- createStyle(textDecoration = "bold", fontSize = 12)
columnHeaderStyle <- createStyle(textDecoration = "bold")

# Split the data
arts_df <- md_df1[1:5, ]
other_df <- md_df1[6:9, ]

# Row tracker
current_row <- 1

# Function to write a labeled section
write_section <- function(title, df, wb, sheet, start_row) {
  writeData(wb, sheet, title, startRow = start_row, colNames = FALSE)
  addStyle(wb, sheet, style = sectionHeaderStyle, rows = start_row, cols = 1, gridExpand = TRUE)
  
  writeData(wb, sheet, df, startRow = start_row + 1, colNames = TRUE)
  addStyle(wb, sheet, style = columnHeaderStyle, rows = start_row + 1, cols = 1:ncol(df), gridExpand = TRUE)
  
  return(start_row + nrow(df) + 3)
}

# Write both sections to the sheet
current_row <- write_section("Faculty of Arts", arts_df, wb, "MD", current_row)
current_row <- write_section("Other Faculties", other_df, wb, "MD", current_row)

# Save updated workbook
saveWorkbook(wb, "combined_data.xlsx", overwrite = TRUE)
