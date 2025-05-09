


colnames(persons) = c('ps_id', 'full_name', 'gender', 'birth_day', 'birth_month', 'birth_year', 'death_day', 'death_month', 'death_year', 'floruit_y1', 'floruit_y2', 'internal_notes', 'external_notes', 'birth_place_id', 'death_place_id', 'import',  'to_be_merged','merged_id')

persons = persons |>
  mutate(gender = factor(gender, levels = c('man', 'woman', 'unknown')))

persons = persons |> 
  arrange(gender)

ps_att = all_files[['ps_att.tab']]

ps_att_colnames = c('ps_att_id', 'ps_id', 'place_id', 'source_id', 'd1', 'm1', 'y1', 'd2', 'm2', 'y2', 'event_type', 'role', 'age', 'wealth', 'import')

colnames(ps_att) = ps_att_colnames

ps_att = ps_att |> mutate(wealth = factor(wealth, levels = c('pauper', 'dives', 'nobilis', 'beneficiatus', 'nobilis\vdives', 'unknown')))

ps_att = ps_att|> mutate(ps_att_id = as.character(ps_att_id))

ps_att_institutions = all_files[['ps_att_institutions.tab']]

colnames(ps_att_institutions) = c('institution_id', 'ps_att_id', 'import')

ps_att_institutions = ps_att_institutions |> mutate(ps_att_id = as.character(ps_att_id))

ps_att_institutions = ps_att_institutions |> mutate(institution_id = as.character(institution_id))

institutions = all_files[['institutions.tab']]

colnames(institutions) = c('institution_id', 'name_english', 'name_latin', 'name_dutch', 'type', 'subdivision_of', 'fd', 'fm', 'fy', 'ad', 'am', 'ay', 'place_id')

institutions = institutions |> mutate(institution_id = as.character(institution_id))

priority_levels = c("The Castle", "The Falcon", "The Lily", "The Pig", "Collegium Trilingue", "Faculty of arts", "Faculty of Theology", "Faculty of Law", "Faculty of Medicine")

institutions$name_english <- factor(institutions$name_english, levels = c(priority_levels, setdiff(c(unique(institutions$name_english)), c(priority_levels, 'unknown')),'unknown'))

institutions = institutions |> arrange(name_english)

ps_att = ps_att |> mutate(y1 = as.character(y1))

places = all_files[['places.tab']]

descriptors = all_files[['descriptors.tab']]

sources = all_files[['sources.tab']]

colnames(sources) = c('source_id', 'title', 'format', 'd1', 'm1', 'y1', 'd2', 'm2', 'y2', 'place_id1', 'place_id2', 'import' )

source_institutions = all_files[['source_institutions.tab']]

colnames(source_institutions) = c('source_inst_id', 'source_id','institution_id','inst_attest', 'institution_name', 'inst_rol', 'import')

source_institutions = source_institutions |> mutate(institution_id = as.character(institution_id))


