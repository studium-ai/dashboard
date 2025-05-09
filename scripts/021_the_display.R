the_df1 = df6 |> filter(role != '') |> 
  rename(`Date unknown` = NAth) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 4))


the_df2 = df7 |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 3,"Century" = 3))


the_df3 = df8|>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 3))

the_df4 = df9|> 
  rename(`Date unknown` = NAth, ` `  = name_english ) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
 # kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 4))

