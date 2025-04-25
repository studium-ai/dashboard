library(openxlsx)

# Load existing workbook
wb <- loadWorkbook("combined_data.xlsx")

# Add new worksheet for Roles
addWorksheet(wb, "ML")

# Define styles
sectionHeaderStyle <- createStyle(textDecoration = "bold", fontSize = 12)
columnHeaderStyle <- createStyle(textDecoration = "bold")

# Write section title
writeData(wb, "ML", "ML", startRow = 1, colNames = FALSE)
addStyle(wb, "ML", style = sectionHeaderStyle, rows = 1, cols = 1, gridExpand = TRUE)

# Write the dataframe
writeData(wb, "ML", t3, startRow = 2, colNames = TRUE)
addStyle(wb, "ML", style = columnHeaderStyle, rows = 2, cols = 1:ncol(t3), gridExpand = TRUE)

# Save the workbook
saveWorkbook(wb, "combined_data.xlsx", overwrite = TRUE)
