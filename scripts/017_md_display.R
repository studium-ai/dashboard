md_df1 = md_institutions |> 
  left_join(fac_df, by = c('952_e' = 'rowname')) |> 
  filter(faculty %in% fac_names) |> 
  mutate(faculty = factor(faculty, levels = fac_names)) |>
  arrange(faculty) |>select(-`952_e`) |> 
  select(faculty, everything(), `Date unknown` = NAth) 

md_tbl1 = md_df1 |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  pack_rows("Faculty of Arts", 1, 5)  |>
  pack_rows("Other Faculties", 6, 9) 


md_tbl2 = df5 |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1)
