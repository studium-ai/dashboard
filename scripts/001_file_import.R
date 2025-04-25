library(tidyverse)

library(data.table)

file_list = list.files('studium_export/', full.names = TRUE)

all_files = lapply(file_list, fread)

names(all_files) = basename(file_list)


get_century = function(date){
  
  
  a = str_extract(date, "[0-9]{2}")
  b = as.numeric(a)
  c = paste0(b + 1, "th")
  
  return(c)
  
}

md_xml_file_path = "/Users/ghum-m-ae231206/Library/CloudStorage/OneDrive-KULeuven/Shared_data_studium/4 Magister Dixit (through ALMA of the KU Leuven libraries' Special Collections)/20230728_Alma_Lecturenotes_all.xml"

source('../marc-exporter/extract_marc.R')

md_952 = extract_marc21_data('952', md_xml_file_path)

md_264 = extract_marc21_data('264', md_xml_file_path)

md_700 = extract_marc21_data('700', md_xml_file_path)







