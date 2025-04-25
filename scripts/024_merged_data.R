
ps_total = nrow(persons |> distinct(ps_id))

merged_total = nrow(persons |> distinct(merged_id))

new_person_total = ps_total - merged_total

merged_total = nrow(persons |> filter(merged_id != ''))

ps_id_merged_id = persons |> distinct(ps_id, merged_id)

ps_att |> left_join(ps_id_merged_id, by = 'ps_id') |> distinct(import, merged_id) |> count(merged_id) |> arrange(desc(n))

nrow(ps_att) - nrow(persons |> distinct(merged_id))

nrow(persons) - nrow(persons |> distinct(merged_id))
