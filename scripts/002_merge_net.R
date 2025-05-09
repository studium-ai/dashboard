library(tidygraph)
library(ggraph)
library(igraph)

persons = all_files[['ps.tab']]


person_graph =  persons |> select(from = V1, to = V16) |> mutate(to = as.numeric(to)) |> mutate(to = coalesce(to, from))

person_graph_net = person_graph |> graph_from_data_frame(directed = FALSE)

merged_id = person_graph_net |> as_tbl_graph() |> mutate(comp = group_components()) |> as_tibble() |> pull(comp)

persons = persons |> mutate(merged_id = merged_id)

