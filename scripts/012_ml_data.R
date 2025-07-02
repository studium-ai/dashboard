t3 = ps_att  |> 
  filter(role %in% c('publisher', 'printer', 'professor', 'student', 'editor', 'castigator', 'commentator', 'translator', 'corrector', 'approbator', 'author', 'dedicatee'))|> 
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(str_detect(import, "ML")) |> 
  left_join(persons, by = 'ps_id') |>
  mutate(century = get_century(y1)) |> 
  group_by(century, role) |> 
  summarise(n = n()) |>
  ungroup() |> 
  group_by(role) |> 
  mutate(total = sum(n)) |> 
  arrange(desc(total)) |>
  pivot_wider(names_from = 'century', values_from = 'n') 



ml_total_persons = nrow( ps_att|>
                           filter(str_detect(import, "ML")) |> 
                           left_join(persons |> select(ps_id, merged_id)) |>
                           distinct(merged_id, .keep_all = TRUE) )

ml_ps_att = ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "ML")) |> pull(ps_att_id)

ml_total_institutions = nrow(ps_att_institutions |> filter(ps_att_id %in% ml_ps_att) |> distinct(institution_id))

ml_persons = persons |> filter(str_detect(import, "ML"))

ml_total_places = length(unique(c(ml_persons$birth_place_id, ml_persons$death_place_id)))

ml_total_sources = nrow(sources |> filter(str_detect(import, "ml_ingest")) |> distinct(source_id))
