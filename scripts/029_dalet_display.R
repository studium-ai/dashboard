dalet_df1 = dalet_df4 |> filter(role != '') |> 
  rename(`Date unknown` = NAth) |> select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling()  |>
  kableExtra::collapse_rows(columns = 1) |>
  add_header_above(c(" " = 3,"Century" = 3))
