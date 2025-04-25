library(openxlsx)

# Load the existing workbook
wb <- loadWorkbook("combined_data.xlsx")

# Add the new worksheet
addWorksheet(wb, "OUL")

# Define styles
sectionHeaderStyle <- createStyle(textDecoration = "bold", fontSize = 12)
columnHeaderStyle <- createStyle(textDecoration = "bold")

# Split the dataframe into labeled sections
arts_df <- df2[1:5, ]
law_df  <- df2[6:8, ]
other_df <- df2[9:11, ]

# Row tracker
current_row <- 1

# Helper to write one section
write_section <- function(title, df, wb, sheet, start_row) {
  writeData(wb, sheet, title, startRow = start_row, colNames = FALSE)
  addStyle(wb, sheet, style = sectionHeaderStyle, rows = start_row, cols = 1, gridExpand = TRUE)
  
  writeData(wb, sheet, df, startRow = start_row + 1, colNames = TRUE)
  addStyle(wb, sheet, style = columnHeaderStyle, rows = start_row + 1, cols = 1:ncol(df), gridExpand = TRUE)
  
  return(start_row + nrow(df) + 3)
}

# Write each section to the new sheet
current_row <- write_section("Faculty of Arts", arts_df, wb, "OUL", current_row)
current_row <- write_section("Faculty of Law", law_df, wb, "OUL", current_row)
current_row <- write_section("Other", other_df, wb, "OUL", current_row)

# Save the workbook with the new sheet included
saveWorkbook(wb, "combined_data.xlsx", overwrite = TRUE)
