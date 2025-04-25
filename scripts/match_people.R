links_table = fread('odis_ps_links.tab')

links_table = links_table |>
  mutate(ODIS_ID = basename(V2))

dalet_links_table = fread('dalet_ps_links.tab')

dalet_links_table = dalet_links_table |>
  mutate(V2 = str_remove(V2, "https\\:\\/\\/"))

ps_full_name = fread('ps_name_fl.tab')

colnames(ps_full_name) = c('ps_id_fm', 'name', 'floruit1', 'floruit2')

ps_full_name = ps_full_name |> 
  distinct(name, floruit1, floruit2, .keep_all = TRUE)

fm_ps_id = ps_table |> 
  left_join(ps_full_name, by = c('name', 'floruit1', 'floruit2')) |> 
  select(ps_id, ps_id_existing = ps_id_fm) %>% filter(!is.na(ps_id_existing))

odis_ps_id = ps_table |> 
  mutate(ODIS_ID = basename(ODIS)) |>
  left_join(links_table, by = "ODIS_ID") |> 
  select(ps_id, ps_id_existing = V1 ) %>% 
  filter(!is.na(ps_id_existing))

dalet_ps_id = ps_table |>
  left_join(dalet_links_table, by = c('DaLeT-ID' = 'V2'))  |> 
  select(ps_id, ps_id_existing = V1 )%>% 
  filter(!is.na(ps_id_existing))



id_matches = rbind(fm_ps_id, odis_ps_id,dalet_ps_id) |> distinct(ps_id, .keep_all = TRUE)
            