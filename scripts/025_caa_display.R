caa_df1 = caa_role |> filter(role != '') |> 
  rename(`Date unknown` = NAth) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 4))


caa_df2 = caa_wealth |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 3,"Century" = 4))


caa_df3 = caa_institution |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 4))

caa_df4 = caa_source_inst|> 
  rename(`Date unknown` = NAth, ` `  = name_english ) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  add_header_above(c(" " = 3,"Century" = 4))
