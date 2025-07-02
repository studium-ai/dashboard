df5 = ps_att  |> 
  distinct(ps_id, .keep_all = TRUE) |>
  filter(str_detect(import, "Lecture")) |> 
  left_join(persons, by = 'ps_id') |>
  mutate(century = get_century(y1)) |> 
  #filter(century <1800 & century > 1300) |>
  group_by(century,role)  |>
  summarise(n = n())|> 
  group_by(role) |> mutate(total = sum(n)) |> 
  arrange(desc(total)) |> filter(century!='NAth')|>
  pivot_wider(names_from = century, values_from = n) |>ungroup() |>
  mutate(Percent = round(total/sum(total) *100, 2)) |> 
  select(role, total, Percent, `16th`, `17th`, `18th`)


df6 = ps_att  |> 
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(str_detect(import, "Lecture")) |> 
  left_join(persons, by = 'ps_id') |>
  mutate(century = get_century(y1)) |> 
  filter(century <1800 & century > 1300) |>
  group_by(century,role)  |>
  summarise(n = n())|> pivot_wider(names_from = century, values_from = n) 



t6 = df6 |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1)

md_institutions = md_952 |> 
  left_join(md_264) |> 
  separate(`264_c`, into = c("y1", "y2"), sep = '-') |> 
  mutate(year = str_extract(y1, "[0-9]{4}")) |>
  mutate(century = get_century(year)) |> 
  group_by(century, `952_e`) |>
  summarise(n = n()) |> group_by(`952_e`) |> 
  mutate(Total = sum(n)) |>
  pivot_wider(names_from = "century", values_from ='n' ) |> 
  ungroup() |>
  mutate(Percent = round(Total/sum(Total) *100, 2)) |>
    arrange(`952_e`) |> 
  select(`952_e`, Total, Percent, everything()) 

fac_names = c('Pedagogie De Burcht' = "The Castle", 
              'Pedagogie De Lelie' = "The Lily",
              'Pedagogie De Valk' = "The Falcon", 
              'Pedagogie Het Varken' = "The Pig", 
              'Pedagogie onbekend' = "Pedagogy unknown",
              'Theologische faculteit' = "Faculty of Theology", 
              'Rechtsfaculteit' = "Faculty of Law", 
              'Medische faculteit' = "Faculty of Medicine",
              'Jezuïetencollege' = "Jesuit college")

fac_df = as.data.frame(fac_names) |> rownames_to_column() |> rename(faculty = fac_names)

md_total_persons = nrow( ps_att|>
                           filter(str_detect(import, "Lecture")) |> 
                           left_join(persons |> select(ps_id, merged_id)) |>
                           distinct(merged_id, .keep_all = TRUE) )


md_ps_att = ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "Lecture")) |> pull(ps_att_id)

md_total_institutions = nrow(md_institutions |> filter(!is.na(`952_e`)))

md_persons = persons |> filter(str_detect(import, "Lecture"))

md_total_places = length(unique(c(md_persons$birth_place_id, md_persons$death_place_id)))

md_total_places = nrow(descriptors |> filter(V5 %in% md_ps_att) |> distinct(V8))

md_total_sources = nrow(sources |> filter(str_detect(import, "md_ingest")) |> distinct(source_id))


# subset from Matriculation records

md_merged_id = persons |>
  filter(str_detect(import,'Lecture')) |> pull(merged_id)

md_ps_id = persons |> filter(merged_id %in% md_merged_id) |>
  pull(ps_id)

df1 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  filter(ps_id %in% md_ps_id) |>
  distinct(ps_id, .keep_all = TRUE) |>
  mutate(century = get_century(y1)) |>
  group_by(century, age) |> 
  summarise(n = n()) |>
  group_by(age) |>
  mutate(Total = sum(n)) |>
  pivot_wider(names_from = 'century', values_from = 'n') |> 
  arrange(desc(age))  |> 
  select(category = age, everything()) |>
  mutate(category = ifelse(category == '', 'unknown', category)) |> 
  mutate(type = 'Age') |> ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> 
  select(category, Total, percent, everything())

df1 |> summarise(tot = sum(Total))

df2 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  filter(ps_id %in% md_ps_id)  |>
  distinct(ps_att_id, .keep_all = TRUE) |>
  left_join(ps_att_institutions, by = 'ps_att_id') |>
  mutate(century = get_century(y1)) |>
  group_by(century, institution_id) |> 
  summarise(n = n())|>
  group_by(institution_id) |>
  mutate(Total = sum(n))  |> 
  ungroup()|> 
  left_join(institutions, by = 'institution_id') |> 
  select(century, name_english, n, Total) |>
  pivot_wider(names_from = 'century', values_from = 'n') |>
  select(institution = name_english, everything()) |> 
  mutate(type = 'Faculty') |> 
  mutate(institution = replace_na(institution, "unknown")) |> 
  arrange(institution)|> ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> select(institution, Total, percent, everything())

df2 |> summarise(tot = sum(Total))

df3 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(ps_id %in% md_ps_id) |> 
  mutate(century = get_century(y1)) |> 
  group_by(century, wealth) |> 
  summarise(n = n()) |>
  group_by(wealth) |>
  mutate(Total = sum(n))  |>
  pivot_wider(names_from = 'century', values_from = 'n') |> mutate(type = 'Inscription fee') |>
  mutate(wealth = replace_na(wealth, 'unknown')) |> 
  ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> 
  select(wealth, Total, percent, everything()) |> arrange(wealth)

df3 |>ungroup() |> summarise(total = sum(Total))

df4 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(ps_id %in% md_ps_id) |> 
  left_join(persons, by = 'ps_id') |> 
  distinct(merged_id, .keep_all = TRUE)|>
  mutate(century = get_century(y1)) |> 
  mutate(gender = replace_na(gender, "unknown"))|>
  group_by(century, gender) |> 
  summarise(n = n()) |>
  group_by(gender) |>
  mutate(Total = sum(n))  |> 
  ungroup()|> 
  pivot_wider(names_from = 'century', values_from = 'n')  |> 
  mutate(type = 'Gender') |> arrange(gender)|> ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> 
  select(gender, Total, percent, everything())


md_matr_df= data.table::rbindlist(list(df1, df2, df3), use.names = FALSE)
