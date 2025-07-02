caa_role = ps_att  |> 
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(str_detect(import, "Caa")) |> 
  left_join(persons, by = 'ps_id') |>
  mutate(century = get_century(y1)) |>
  group_by(century,role)  |>
  summarise(n = n())|> group_by(role) |>
  mutate(Total = sum(n))|>
  pivot_wider(names_from = century, values_from = n)  |>  ungroup()|>
  mutate(Percent = round(Total/sum(Total)*100,2))  |>
  select(role, Total, Percent,everything()) |> arrange(desc(Total))

person_inst = ps_att |>
  left_join(ps_att_institutions, by = 'ps_att_id') |> 
  select(ps_att_id, institution_id) |> 
  filter(!is.na(institution_id)) |> 
  distinct(ps_att_id, .keep_all = TRUE)

caa_ps_att = ps_att |> 
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(str_detect(import, "Caa")) |> 
  select(ps_id, ps_att_id, y1) |> 
  left_join(person_inst, by = 'ps_att_id') |> 
  left_join(institutions, by = 'institution_id') |>  
  mutate(century = get_century(y1)) |> 
  group_by(century, name_english) |>
  summarise(n = n()) |> 
  group_by(name_english) |>
  mutate(Total = sum(n)) |>  ungroup() |>
  mutate(Percent = Total/sum(Total)*100) |> 
  pivot_wider(names_from = century, values_from = n) |> 
  arrange(name_english)|> select(name_english, Total, Percent, everything())|> arrange(desc(Total))

caa_persons = ps_att |>
  filter(str_detect(import, "Caa")) |> pull(ps_id)

caa_persons_id = persons |> filter(ps_id %in% caa_persons) |> pull(merged_id)

caa_ps_id = persons |> filter(merged_id %in% caa_persons_id) |> pull(ps_id)

caa_wealth = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |> filter(ps_id %in% caa_ps_id) |>
  distinct(ps_id, .keep_all = TRUE) |> 
  mutate(century = get_century(y1)) |> 
  group_by(century, wealth) |> 
  summarise(n = n()) |>
  group_by(wealth) |>
  mutate(Total = sum(n))  |>
  pivot_wider(names_from = 'century', values_from = 'n')|> 
  ungroup() |>
  mutate(Percent = round(Total/sum(Total)*100,2))  |> 
  arrange(wealth)|> select(wealth, Total, Percent, everything())|> arrange(desc(Total))


caa_institution = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |> 
  filter(ps_id %in% caa_ps_id) |>
  distinct(ps_id, .keep_all = TRUE) |>
  mutate(century = get_century(y1)) |> 
  left_join(ps_att_institutions, by = 'ps_att_id') |>
  left_join(institutions, by = 'institution_id')|>
  group_by(century, name_english) |> 
  summarise(n = n()) |>
  group_by(name_english) |>
  mutate(Total = sum(n))  |>
  pivot_wider(names_from = 'century', values_from = 'n')  |> rename(Institution = name_english)|> 
  ungroup() |>
  mutate(Percent = round(Total/sum(Total)*100,2)) |> 
  arrange(Institution)|> select(Institution, Total,Percent, everything())|> arrange(desc(Total))

caa_source_inst = sources |> filter(str_detect(import, "Caa"))  |> 
  mutate(century = get_century(y1)) |>
  left_join(source_institutions, by = 'source_id' )|> 
  left_join(institutions, by = c('inst_id' = 'institution_id')) |> 
  group_by(century, name_english) |>
  summarise(n = n()) |>
  group_by(name_english) |>
  mutate(Total = sum(n)) |>
  pivot_wider(names_from = 'century', values_from = 'n')|> 
  ungroup() |>
  mutate(Percent = round(Total/sum(Total)*100,2))   |> 
  arrange(name_english) |> select(name_english, Total, Percent, everything())|> arrange(desc(Total))


caa_total_persons = nrow(ps_att |>
                           filter(str_detect(import, "Caa")) |>
                           left_join(persons |> select(ps_id, merged_id))|> 
                           distinct(merged_id, .keep_all = TRUE))

caa_total_sources = nrow(sources |> 
                           filter(str_detect(import, "Caa")) |> distinct(source_id))

caa_ps_att = ps_att |> distinct(ps_att_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "Caa")) |> pull(ps_att_id)

caa_total_places = nrow(descriptors |> filter(V5 %in% caa_ps_att) |> distinct(V8))

