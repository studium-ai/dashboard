
options(knitr.kable.NA = '-')

library(kableExtra)
library(htmltools)
library(bslib)
tbl = df |> select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling() %>%
  #kableExtra::kable_paper("striped", full_width = T) |>
  kableExtra::collapse_rows(columns = 1) |> 
  pack_rows("Age", 1, 3) |> 
  pack_rows("Faculty", 4, 14)|> 
  pack_rows("Inscription fee", 15, 20)|> 
  pack_rows("Gender", 21, 23)|>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

mbl_tbl1 =  df1 |> select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling() %>%
  #kableExtra::kable_paper("striped", full_width = T) |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

mbl_tbl2 =  df2 |> select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling() %>%
  #kableExtra::kable_paper("striped", full_width = T) |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

mbl_tbl3 =  df3 |>select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling() %>%
  #kableExtra::kable_paper("striped", full_width = T) |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

mbl_tbl4 =  df4 |>select(-type) |>
  kableExtra::kbl() |> kableExtra::kable_styling() %>%
  #kableExtra::kable_paper("striped", full_width = T) |>
  kableExtra::collapse_rows(columns = 1)|>
  add_header_above(c(" " = 1, " " = 2, "Century" = 4))

p = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |>
  mutate(y1 = as.numeric(y1)) |>
  mutate(decade = y1-y1 %% 10) |>
  mutate(age = ifelse(age == '', 'unknown', age)) |>
  group_by(decade, age) |> 
  summarise(n = n())  |>
  ggplot() + geom_col(aes(x = as.numeric(decade), y = n, fill = age )) +
  theme(legend.position = 'bottom')  + 
  theme_minimal() + 
  theme(legend.position = 'none', axis.title = element_blank(), legend.title = element_blank()) + 
  labs(fill = "Name:")


p2 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |> 
  distinct(ps_att_id, .keep_all = TRUE) |> 
  left_join(ps_att_institutions, by = 'ps_att_id') |>
  mutate(y1 = as.numeric(y1)) |>
  mutate(decade = y1-y1 %% 10) |>
  group_by(decade, institution_id) |> 
  summarise(n = n()) |> 
  left_join(institutions, by = 'institution_id') |> 
  filter(institution_id %in% 16:19) |>
  select(decade, name_english, n)|> 
  mutate(V2 = replace_na(name_english, "unknown")) |>
  ggplot() + geom_col(aes(x = as.numeric(decade), y = n, fill = name_english ), alpha = .9) + 
  theme_minimal() + 
  theme(legend.position = 'none', axis.title = element_blank(), legend.title = element_blank()) + 
  labs(fill = "Name:")

p3 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |> 
  mutate(y1 = as.numeric(y1)) |>
  mutate(decade = y1-y1 %% 10)|> 
  mutate(wealth = replace_na(wealth, "unknown")) |>
  group_by(decade, wealth) |> 
  summarise(n = n()) |>
  ggplot() + geom_col(aes(x = as.numeric(decade), y = n, fill = wealth )) +
  theme(legend.position = 'bottom') + 
  theme_minimal() + 
  theme(legend.position = 'none', axis.title = element_blank(), legend.title = element_blank()) + 
  labs(fill = "Name:")

p4 = ps_att |> 
  filter(str_detect(import, "Matrikels2")) |>
  distinct(ps_att_id, .keep_all = TRUE) |> 
  left_join(persons, by = 'ps_id') |> 
  distinct(merged_id, .keep_all = TRUE)|>
  mutate(gender = replace_na(gender, 'unknown'))|>
  mutate(y1 = as.numeric(y1)) |>
  mutate(decade = y1-y1 %% 10) |>
  group_by(decade, gender) |> 
  summarise(n = n())|>
  ggplot() + geom_col(aes(x = as.numeric(decade), y = n, fill = gender )) +
  theme(legend.position = 'bottom') + 
  theme_minimal() + 
  theme(legend.position = 'none', axis.title = element_blank(), legend.title = element_blank()) + 
  labs(fill = "Name:")



