library(openxlsx)

# Load existing workbook
wb <- loadWorkbook("combined_data.xlsx")

# Add new worksheet
addWorksheet(wb, "Theses")

# Define styles
sectionHeaderStyle <- createStyle(textDecoration = "bold", fontSize = 12)
columnHeaderStyle <- createStyle(textDecoration = "bold")

# Create a list of section titles and dataframes
sections <- list(
  "Roles" = df6,
  "Wealth Category" = df7,
  "Institutions" = df8,
  "Faculties" = df9
)

# Row tracker
current_row <- 1

# Helper function to write each section
write_section <- function(title, df, wb, sheet, start_row) {
  writeData(wb, sheet, title, startRow = start_row, colNames = FALSE)
  addStyle(wb, sheet, style = sectionHeaderStyle, rows = start_row, cols = 1, gridExpand = TRUE)
  
  writeData(wb, sheet, df, startRow = start_row + 1, colNames = TRUE)
  addStyle(wb, sheet, style = columnHeaderStyle, rows = start_row + 1, cols = 1:ncol(df), gridExpand = TRUE)
  
  return(start_row + nrow(df) + 3)
}

# Write all sections
for (i in seq_along(sections)) {
  title <- names(sections)[i]
  df <- sections[[i]]
  current_row <- write_section(title, df, wb, "Theses", current_row)
}

# Save workbook
saveWorkbook(wb, "combined_data.xlsx", overwrite = TRUE)
