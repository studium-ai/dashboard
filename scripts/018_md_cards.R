md_card1 = card(HTML(md_tbl1))


md_card2 = card(HTML(md_tbl2))


md_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = md_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Institutions",
    value = md_total_institutions,
    showcase = bsicons::bs_icon("buildings"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = md_total_sources,
    showcase = bsicons::bs_icon("book"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
