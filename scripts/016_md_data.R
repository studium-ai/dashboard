df5 = ps_att  |> 
  distinct(ps_att_id, .keep_all = TRUE) |>
  filter(str_detect(import, "Lecture")) |> 
  left_join(persons, by = 'ps_id') |>
  mutate(century = get_century(y1)) |> 
  #filter(century <1800 & century > 1300) |>
  group_by(century,role)  |>
  summarise(n = n())|> pivot_wider(names_from = century, values_from = n) 


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
  left_join(md_264) |>separate(`264_c`, into = c("y1", "y2"), sep = '-') |> 
  mutate(year = str_extract(y1, "[0-9]{4}")) |>
  mutate(century = get_century(year)) |> 
  group_by(century, `952_e`) |>
  summarise(n = n()) |> group_by(`952_e`) |> 
  mutate(Total = sum(n)) |>
  pivot_wider(names_from = "century", values_from ='n' ) |> ungroup() |>
  mutate(Percent = round(Total/sum(Total) *100, 2)) |>
    arrange(`952_e`) |> select(`952_e`, Total, Percent, everything())

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

md_total_persons = nrow(ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
                          filter(str_detect(import, "Lecture")))

md_ps_att = ps_att |> distinct(ps_id, .keep_all = TRUE) |> 
  filter(str_detect(import, "Lecture")) |> pull(ps_att_id)

md_total_institutions = nrow(md_institutions |> filter(!is.na(`952_e`)))

md_persons = persons |> filter(str_detect(import, "Lecture"))

md_total_places = length(unique(c(md_persons$birth_place_id, md_persons$death_place_id)))

md_total_places = nrow(descriptors |> filter(V5 %in% md_ps_att) |> distinct(V8))

md_total_sources = nrow(sources |> filter(str_detect(import, "md_ingest")) |> distinct(source_id))

