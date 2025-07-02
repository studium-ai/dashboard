caa_card1 = card(card_header("Roles"),HTML(caa_df1))

caa_card2 = card(card_header("Wealth category"),HTML(caa_df2))

caa_card3 = card(card_header("Institutions"),HTML(caa_df3))

caa_card4  = card(card_header("Institutions"),HTML(caa_df4))


caa_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = caa_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = caa_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = caa_total_sources,
    showcase = bsicons::bs_icon("buildings"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
