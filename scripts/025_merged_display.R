p5 = ps_att |>
  mutate(y1 = as.numeric(y1)) |> 
  filter(y1 %in% 1400:1800) |>
  mutate(decade = y1-y1 %% 10) |>
  group_by(decade, import) |> summarise(n = n()) |>
  ggplot() + geom_col(aes(x = decade, y = n, fill = import)) + theme_minimal() + theme(legend.position = 'none') 

ggp5 = ggplotly(p5)
