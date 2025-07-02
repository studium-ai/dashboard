lov_card1 = card(card_header("Roles"),HTML(lov_df1))

lov_card2 = card(card_header("Wealth category"),HTML(lov_df2))

lov_card3 = card(card_header("Institutions"),HTML(lov_df3))

lov_card4  = card(card_header("Institutions"),HTML(lov_df4))


lov_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = lov_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = lov_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = lov_total_sources,
    showcase = bsicons::bs_icon("buildings"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
