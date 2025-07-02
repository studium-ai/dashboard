p5 = ps_att |>
  mutate(y1 = as.numeric(y1)) |> 
  filter(y1 %in% 1400:1800) |>
  mutate(decade = y1-y1 %% 10) |>
  group_by(decade, import) |> summarise(n = n()) |>
  ggplot() + geom_col(aes(x = decade, y = n, fill = import)) + 
  theme_minimal() + 
  theme(legend.position = 'none') 

merged_totals =  ps_att |> 
  left_join(persons |> 
              select(ps_id, merged_id)) |> mutate(merged_id = ifelse(import == 'import from Matrikels2-0_PublicationVersion_20230816', ps_id, merged_id)) |>
  group_by(import) |> 
  summarise(total_ps = n_distinct(merged_id), 
            total_ps_att = n_distinct(ps_att_id), total_sources = n_distinct(source_id))

ps_att_names = merged_totals$import

ps_att_names = tibble(import = merged_totals$import, source = c('dalet', 'thesis', 'OUL', 'CAA', 'magister_dixit', 'lovaniensia', 'MBL', 'manuale_lovaniensia'))


merged_sources = sources |> group_by(import) |> 
  summarise(total_sources = n_distinct(source_id))

sources_names = tibble(import = merged_sources$import, source = c(NA, 'dalet', 'magister_dixit', 'CAA','lovaniensia', 'manuale_lovaniensia', 'thesis', 'manuale_lovaniensia', 'MBL', 'OUL' ))

merged_sources = merged_sources |> 
  left_join(sources_names) |> 
  group_by(source) |> 
  summarise(total_sources = sum(total_sources)) |> 
  filter(!is.na(source))

total_datasets = persons |> 
  group_by(merged_id) |> 
  mutate(total = n_distinct(import)) |>
  mutate(morethanone = ifelse(total>1,'yes', 'no'))

morethan_one_df = total_datasets  |>
  filter(morethanone == 'yes')|>
  group_by(import)|> distinct(merged_id, .keep_all = TRUE)|>
  summarise(morethan = n()) |> 
  left_join(ps_att_names, by = 'import') |> 
  filter(!is.na(source)) |>
  select(source,  morethan)



merged_totals_df = merged_totals |> 
  left_join(ps_att_names) |> 
  left_join(merged_sources, by = 'source') |> 
  select(dataset = source, total_ps, total_ps_att, sources = total_sources.y) |> 
  mutate(dataset = factor(dataset, levels = c('MBL', 'OUL', 'manuale_lovaniensia','magister_dixit', 'CAA','lovaniensia','thesis', 'dalet' ))) |> 
  arrange(dataset) |> left_join(morethan_one_df, by = c('dataset'='source'))



merged_totals_kbl = merged_totals_df |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) 


ggp5 = ggplotly(p5)
