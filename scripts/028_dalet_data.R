dalet_df4 = ps_att |> 
  filter(str_detect(import, "2024082212000101_dalet_persons.csv")) |>
  distinct(ps_att_id, .keep_all = TRUE) |> 
  left_join(persons, by = 'ps_id') |> 
  distinct(merged_id, .keep_all = TRUE)|>
  mutate(century = get_century(y1)) |> 
  mutate(gender = replace_na(gender, "unknown"))|>
  group_by(century, role) |> 
  summarise(n = n()) |>
  group_by(role) |>
  mutate(Total = sum(n))  |> 
  ungroup()|> 
  pivot_wider(names_from = 'century', values_from = 'n')  |> 
  mutate(type = 'role') |> arrange(role)|> ungroup() |>
  mutate(percent = round(Total/sum(Total)* 100, 2)) |> select(role, Total, percent, everything())


dalet_total_persons = nrow(ps_att  |>
                             filter(str_detect(import, "dalet")) |> 
                             left_join(persons |> 
                                         select(ps_id, merged_id))|>
                             distinct(merged_id, .keep_all = TRUE))

dalet_total_sources = nrow(sources |> 
                           filter(str_detect(import, "dalet")) |> distinct(source_id))

dalet_ps_att = ps_att |> distinct(ps_att_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "dalet")) |> pull(ps_att_id)

dalet_total_places = nrow(descriptors |> filter(V5 %in% dalet_ps_att) |> distinct(V8))
