library(tidyverse)

library(data.table)

file_list = list.files('./Documents/', pattern = "tab", full.names = TRUE)

all_files = lapply(file_list, fread)

names(all_files) = basename(file_list)

get_century = function(date){
  
  
  a = str_extract(date, "[0-9]{2}")
  b = as.numeric(a)
  c = paste0(b + 1, "th")
  
  return(c)
  
}

md_xml_file_path = "https://raw.githubusercontent.com/KULeuvenDigitalisering/Magister-Dixit-Collection-Dataset/refs/heads/master/20230728_MetadataAlma_LectureNotes_all.xml"

source('../marc-exporter/extract_marc.R')

md_952 = extract_marc21_data('952', md_xml_file_path)

md_264 = extract_marc21_data('264', md_xml_file_path)

md_700 = extract_marc21_data('700', md_xml_file_path)







