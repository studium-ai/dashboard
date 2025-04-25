the_card1 = card(card_header("Roles"),HTML(the_df1))

the_card2 = card(card_header("Wealth category"),HTML(the_df2))

the_card3 = card(card_header("Institutions"),HTML(the_df3))

the_card4  = card(card_header("Institutions"),HTML(the_df4))


the_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = the_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = the_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Sources",
    value = the_total_sources,
    showcase = bsicons::bs_icon("buildings"),
    showcase_layout = "top right",
    theme = 'info'
  )
)
