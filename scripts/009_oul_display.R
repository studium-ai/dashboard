
# Import PSInstitutions table

ps_institutions_table = rbind(faculties |> select(ps_att_id, inst_attest = faculty1, inst_id),
                              pedagogies |> select(ps_att_id, inst_attest = pedagogy, inst_id),
                              recht |> select(ps_att_id, inst_attest = recht, inst_id)) |> 
  mutate(ps_att_id = as.character(ps_att_id)) |> 
  mutate(inst_id = as.character(inst_id))


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


t2 = df2 |> ungroup() |>
  select(-type) |> 
  kableExtra::kbl() |> 
  kableExtra::kable_styling()  |> 
  pack_rows("Faculty of Arts", 1, 5) |> 
  pack_rows("Faculty of Law", 6,8)|> 
  pack_rows("Other", 9, 12) |>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))





