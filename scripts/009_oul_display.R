t2 = df2 |> ungroup() |>
  select(-type) |> 
  kableExtra::kbl() |> 
  kableExtra::kable_styling()  |> 
  pack_rows("Faculty of Arts", 1, 5) |> 
  pack_rows("Faculty of Law", 6,8)|> 
  pack_rows("Other", 9, 12) |>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

t2



