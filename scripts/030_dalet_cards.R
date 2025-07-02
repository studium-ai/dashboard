dalet_card1 = card(card_header("Roles"),HTML(dalet_df1))


dalet_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = dalet_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = dalet_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = dalet_total_sources,
    showcase = bsicons::bs_icon("buildings"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
