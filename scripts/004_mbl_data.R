df1 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |>
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
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> select(category, Total, percent, everything())

df2 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
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
  mutate(institution = replace_na(institution, "unknown")) |> arrange(institution)|> ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> select(institution, Total, percent, everything())

df3 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |> 
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

df4 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |> 
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
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> select(gender, Total, percent, everything())


df= data.table::rbindlist(list(df1, df2, df3, df4), use.names = FALSE)

mat_total_persons = nrow(ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
                           filter(str_detect(import, "Matrikel")))

mat_ps_att = ps_att |> distinct(ps_att_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "Matrikel")) |> pull(ps_att_id)

mat_total_institutions = nrow(ps_att_institutions |> filter(ps_att_id %in% mat_ps_att) |> distinct(institution_id))

mat_total_sources = nrow(ps_att |> distinct(source_id, .keep_all = TRUE) |> 
                           filter(str_detect(import, "Matrikel")))

mat_total_places = nrow(descriptors |> filter(V5 %in% mat_ps_att) |> distinct(V8))

