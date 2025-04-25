
library(openxlsx)

# Create a new workbook
wb <- createWorkbook()

# Add a worksheet
addWorksheet(wb, "MBL")

boldStyle <- createStyle(textDecoration = "bold")

# Start row tracker
current_row <- 1

# Helper function with styling
write_section <- function(wb, sheet, title, df, start_row) {
  # Write section title
  writeData(wb, sheet, title, startRow = start_row, colNames = FALSE)
  addStyle(wb, sheet, style = boldStyle, rows = start_row, cols = 1, gridExpand = TRUE)
  
  # Write data below
  writeData(wb, sheet, df, startRow = start_row + 1, colNames = TRUE)
  
  return(start_row + nrow(df) + 3)
}

# Write each section
current_row <- write_section(wb, "MBL", "Age Category", df1, current_row)
current_row <- write_section(wb, "MBL", "Institutions", df2|> select(-type) , current_row)
current_row <- write_section(wb, "MBL", "Wealth Category", df3|> select(-type) , current_row)
current_row <- write_section(wb, "MBL", "Gender", df4|> select(-type) , current_row) 

saveWorkbook(wb, "combined_data.xlsx", overwrite = TRUE)
