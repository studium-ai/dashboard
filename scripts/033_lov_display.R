lov_df1 = lov_role |> filter(role != '') |> 
  rename(`Date unknown` = NAth) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 5))


lov_df2 = lov_wealth |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 3,"Century" = 4))


lov_df3 = lov_institution |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 4))

lov_df4 = lov_source_inst|> 
  rename(`Date unknown` = NAth, ` `  = name_english ) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  add_header_above(c(" " = 3,"Century" = 5))
