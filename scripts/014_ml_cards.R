ml_card1 = card(HTML(tbl3))

ml_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = ml_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = ml_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = ml_total_sources,
    showcase = bsicons::bs_icon("book"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
