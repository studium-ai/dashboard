library(tidyverse)
library(data.table)

next_ps_id = 226569
next_ps_att_id = 180549
next_pslinks_id = 144449
next_ps_institutions_id = 94477
next_namvar_id =84027
next_nam_id = 59641

oul_df = readxl::read_excel('/Users/ghum-m-ae231206/Library/CloudStorage/OneDrive-KULeuven/Shared_data_studium/3 Persons OUL (through ODIS)/Summer 2024 Job Students/Scholars@OldLouvain-20250224-final.xlsx')

filename = 'Scholars@OldLouvain-20250224-final.xlsx'

wikidata_oul = readxl::read_excel('/Users/ghum-m-ae231206/Library/CloudStorage/OneDrive-KULeuven/Shared_data_studium/3 Persons OUL (through ODIS)/Summer 2024 Job Students/Scholars@OldLouvain-20250214-final.xlsx')

wikidata_oul = wikidata_oul |> select(Wikidata_BirthPlace_RETE, Wikidata_DeathPlace_RETE, PKey) |> distinct(PKey, .keep_all = TRUE) |> filter(!is.na(PKey))

namvar = read_csv('../thesis_sheets_marc_exporter/all_namvar.csv', col_names = FALSE)

all_wiki_ids = read_csv('../whg_importer/all_wiki_ids.csv')

#all_wiki_ids = all_wiki_ids |> arrange(place_id) |> distinct(wikidata_id, .keep_all = TRUE)

replace_van_patterns <- function(input_string) {
  # Perform replacements for "Van den", "van den", "Van der", and "van der"
  input_string <- str_replace_all(input_string, "Van den (\\w+)", "Van_den_\\1")
  input_string <- str_replace_all(input_string, "van den (\\w+)", "van_den_\\1")
  input_string <- str_replace_all(input_string, "Van der (\\w+)", "Van_der_\\1")
  input_string <- str_replace_all(input_string, "van der (\\w+)", "van_der_\\1")
  input_string <- str_replace_all(input_string, "Van 't (\\w+)", "Van_'t_\\1")
  input_string <- str_replace_all(input_string, "de le (\\w+)", "de_le_\\1")
  
  return(input_string)
}


replace_name_spaces <- function(input_string) {
  # Define the patterns to replace
  patterns <- c(
    "de", "van", "Van", "a", "ab", "du", "ex", 
    "Van den", "Van der", "Vanden", "Vande", "Vander",
    "Von", "von", "De", "Le", "le", "Van 't", "de le", "La", "la"
  )
  
  # Loop through each pattern, replacing spaces after them with underscores
  for (pattern in patterns) {
    # Replace space after the token (or multi-word token) with an underscore
    input_string <- str_replace_all(input_string, paste0("\\b", pattern, "\\b (\\w+)"), paste0(pattern, "_\\1"))
  }
  
  return(input_string)
}


# PSAtt

# Dates - from dates column
# Event type - dataset
# role: should be the same as the list 

# PS table
# birth, death. Location?

# Links table
# ODIS links
# Viaf links

# Steps

# Split up name into descriptors. 

# Match to NamVar

# Add missing NamVar

# Create PS table

ps_table = oul_df %>%
  mutate(PKey = ifelse(PKey == "" | is.na(PKey), row_number()[PKey == "" | is.na(PKey)], PKey)) %>% 
  group_by(PKey) |>
  mutate(faculty = max(faculty, na.rm = TRUE)) |> ungroup() |>
  distinct(PKey, .keep_all = TRUE) %>%
  mutate(ps_id = next_ps_id:((next_ps_id-1) + nrow(.))) %>% 
  mutate(name = paste0(`first name`, " ", surname) ) %>% 
  mutate(birth_y = ifelse(str_detect(Dates, "geboren"), Dates, NA)) %>% 
  mutate(died_y = ifelse(str_detect(Dates, "gestorven"), Dates, NA)) %>% 
  mutate(birth_y = as.numeric(str_extract(birth_y, "[0-9]{4}"))) %>% 
  mutate(died_y = as.numeric(str_extract(died_y, "[0-9]{4}"))) %>% 
  mutate(dates = str_extract_all(Dates, "[0-9]{4}")) %>% 
  mutate(remarks2 = str_extract_all(remarks, "[0-9]{4}"))|>
  mutate(floruit1 = as.numeric(map_chr(dates, ~ .[1]))) |>
  mutate(floruit2 = as.numeric(map_chr(dates, ~ .[2]))) |>
  mutate(floruit1_rem = as.numeric(map_chr(remarks2, ~ .[1])))|>
  mutate(floruit2_rem = as.numeric(map_chr(remarks2, ~ .[2]))) |> 
  mutate(floruit1 = pmin(floruit1, floruit1_rem, na.rm = TRUE)) |>
  mutate(floruit2 = pmax(floruit2, floruit2_rem, na.rm = TRUE)) |>
  mutate(floruit2 = pmax(floruit2, died_y, na.rm = TRUE))|>
  mutate(floruit1 = pmin(floruit1, birth_y, na.rm = TRUE)) |>
  mutate(floruit2 = coalesce(floruit2, floruit1)) |>
  mutate(partial = ifelse(str_detect(Dates, "[0-9]xx"), Dates, NA)) |>
  mutate(partial = str_remove(partial, " \\(prof\\)")) |>
  mutate(partial1 = as.numeric(str_replace_all(partial, "xx", "00")))|>
  mutate(partial2 = as.numeric(str_replace_all(partial, "xx", "99"))) |>
  mutate(floruit1 = coalesce(partial1, floruit1)) |>
  mutate(floruit2 = coalesce(partial2, floruit2)) |>
  mutate(floruit1 = str_extract(floruit1, "^[0-9]{4}"))|>
  mutate(floruit2 = str_extract(floruit2, "[0-9]{4}$")) |>
  mutate(birth_y = coalesce(as.numeric(YearBorn_RETE), birth_y),
         died_y = coalesce(as.numeric(YearDied_RETE), died_y),
         floruit1 = coalesce(as.character(Beginning_RETE), floruit1),
         floruit2 = coalesce(as.character(End_RETE), floruit2))|>
  select(ps_id, name, birth_y, died_y, floruit1, floruit2,Dates, remarks,  ODIS, `DaLeT-ID`, 
         professor, `student in Leuven`, faculty, `first name`, surname, PKey, BirthPlace_RETE, DeathPlace_RETE, PName_RETE, FirstName_RETE, Wikipedia_RETE, VIAF_RETE) |> 
  left_join(wikidata_oul, by = 'PKey')

source('scripts/match_people.R')

ps_table = ps_table |> 
  left_join(id_matches, by = 'ps_id') |>
  mutate(ps_id = coalesce(ps_id_existing, ps_id))



ps_table = ps_table |> 
  left_join(all_wiki_ids, by = c('Wikidata_BirthPlace_RETE' = 'wikidata_id')) |> 
  left_join(all_wiki_ids, by = c('Wikidata_DeathPlace_RETE' = 'wikidata_id')) %>%
  mutate(ps_id = ifelse(!is.na(ps_id_existing), ps_id_existing, next_ps_id +cumsum(is.na(ps_id_existing)) - 1)) 

ps_table = ps_table |> distinct(name, birth_y, died_y, BirthPlace_RETE, .keep_all = TRUE)

# Import PS records

# Create PS links table

ps_links_table_odis = ps_table %>% 
  mutate(project_id = 3) %>% 
  select(ps_id,link = ODIS, project_id) %>% 
  filter(!is.na(link)) %>% 
  mutate(external_id = basename(link))

ps_links_table_oul = ps_table %>% 
  mutate(project_id = 26) %>% mutate(link = '') |>
  select(ps_id, link,external_id = PKey, project_id) %>% filter(!is.na(external_id)) 

ps_links_table_wikipedia =  ps_table %>% 
  mutate(project_id = 27) %>% mutate(link = Wikipedia_RETE) |> mutate(external_id = '') |>
  select(ps_id, link, external_id , project_id) %>% filter(!is.na(link)) 

ps_links_table_viaf = ps_table %>% 
  mutate(project_id = 28) %>% mutate(link =VIAF_RETE ) |> mutate(external_id = '') |>
  select(ps_id, link, external_id , project_id) %>% filter(!is.na(link)) 

ps_links_table = rbind(ps_links_table_odis, ps_links_table_oul, ps_links_table_wikipedia, ps_links_table_viaf)

# Import PS links

# Create PSAtt table

ps_att_table  = ps_table %>% 
  mutate(ps_att_id = next_ps_att_id:((next_ps_att_id-1) + nrow(.)))%>% 
  mutate(place_id = 2) %>% 
  mutate(from = floruit1, to = floruit2) %>%
  mutate(event_type = 'dataset') %>% 
  mutate(role = 'professor') %>% 
  mutate(to = coalesce(to, from)) %>% 
  select(ps_id, ps_att_id, name,event_type, role,  from_y = from, to_y = to, faculty, `first name`, surname,PKey, PName_RETE, FirstName_RETE) %>% 
  mutate(source_id = 10123)

# Import PS Att table

# Create PSInstitutions table? 

ps_inst_table = ps_att_table %>%
  mutate(faculty1 = str_extract_all(faculty, "(?i)theologie|artes|recht|geneeskunde|genss|CT"))%>%
  #mutate(faculty1 = trimws(faculty1)) %>%
  mutate(pedagogy = str_extract_all(faculty, "(?i)burcht|valk|varken|lelie")) |>
  mutate(recht = str_extract_all(faculty, "(?i)burgerlijk|kerkelijk"))


faculties = ps_inst_table %>%
  select(ps_att_id, faculty1) %>%
  filter(!is.na(faculty1)) %>%
  filter(! faculty1 == 'character(0)') %>%
  unnest(faculty1) %>%
  mutate(inst_id = case_when(faculty1 == "Theologie" ~ 26,
                             faculty1 == 'Artes' ~ 15,
                             faculty1 == 'Recht'~ 25,
                             faculty1 == 'CT' ~ 29,
                             faculty1 %in% c('Geneeskunde', 'Genss')~22
  ))
pedagogies = ps_inst_table %>%
  select(ps_att_id, pedagogy) %>%
  filter(!is.na(pedagogy))%>%
  filter(! pedagogy == 'character(0)') %>%
  unnest(pedagogy)%>%
  mutate(inst_id = case_when(pedagogy == "Valk" ~ 16,
                             pedagogy == 'Burcht' ~ 17,
                             pedagogy == 'Varken'~ 18,
                             pedagogy == 'Lelie' ~ 19))
recht = ps_inst_table %>%
  select(ps_att_id, recht) %>%
  filter(!is.na(recht))%>%
  filter(! recht == 'character(0)') %>%
  unnest(recht)%>%
  mutate(inst_id = case_when(recht == "burgerlijk" ~ 40,
                             recht == 'kerkelijk' ~ 41))

# Import PSInstitutions table

ps_institutions_table = rbind(faculties |> select(ps_att_id, inst_attest = faculty1, inst_id),
                              pedagogies |> select(ps_att_id, inst_attest = pedagogy, inst_id),
                              recht |> select(ps_att_id, inst_attest = recht, inst_id))
df2 = ps_att |> 
  filter(str_detect(import, "Scholar")) |>
  distinct(ps_att_id, .keep_all = TRUE) |>
  left_join(ps_institutions_table, by = 'ps_att_id') |>
  mutate(century = get_century(y1)) |>
  filter(y1 %in% 1400:1800) |>
  group_by(century, inst_id) |> 
  summarise(n = n())|>
  group_by(inst_id) |>
  mutate(Total = sum(n))  |> 
  ungroup()|> 
  left_join(institutions, by = c('inst_id' = 'institution_id')) |> 
  select(century, name_english, n, Total) |>
  pivot_wider(names_from = 'century', values_from = 'n') |>
  select( institution = name_english, everything()) |> mutate(type = 'Faculty')|>
  mutate(institution = replace_na(institution, 'unknown')) |> ungroup() |>
  mutate(type = ifelse(str_detect(institution, "^The "), "Pedagogy", type)) |> 
  arrange(desc(type), institution) |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> 
  select(institution, Total, percent, everything()) |> arrange(institution) |> mutate(institution = as.character(institution)) |>
  mutate(institution = ifelse(institution == 'Faculty of arts', 'Pedagogy unknown', institution))|>
  mutate(institution = ifelse(institution == 'Faculty of Law', 'Law type unknown', institution)) |>
  mutate(institution = factor(institution, levels = c('The Castle', 'The Falcon','The Lily', 'The Pig', 'Pedagogy unknown', "Faculty of Civil Law", "Faculty of Canon Law", "Law type unknown", "Faculty of Theology", "Faculty of Medicine", "Collegium Trilingue", 'unknown'))) |> 
  arrange(institution)

oul_total_persons = nrow(ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
                           filter(str_detect(import, "Scholar")))

oul_ps_att = ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "Scholar")) |> pull(ps_att_id)

oul_total_institutions = nrow(ps_att_institutions |> filter(ps_att_id %in% oul_ps_att) |> distinct(institution_id))

oul_persons = persons |> filter(str_detect(import, "Scholar"))

oul_total_places = length(unique(c(oul_persons$birth_place_id, oul_persons$death_place_id)))


