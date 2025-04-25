card14 = card(card_header("Attestations by Source"),ggplotly(p5) %>%
                plotly::layout(legend=list(x=0, 
                                           xanchor='left',
                                           yanchor='bottom',
                                           orientation='h'))  )



merged_value_boxes =                                   layout_columns(
  value_box(
    title = "Multiple attestations",
    value = "17,588",
    showcase = bsicons::bs_icon("intersect"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Duplicates found",
    value = "6,176",
    showcase = bsicons::bs_icon("copy"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Total persons",
    value = nrow(distinct(persons, merged_id)),
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'purple'
  ),
  value_box(
    "Most datasets",
    value = "7 (Gommarus Huygens, 1631-1702)",
    showcase = bsicons::bs_icon("diagram-3-fill"),
    showcase_layout = "top right",
    theme = 'info'
  ), value_box(
    "Sources",
    value = mat_total_sources,
    showcase = bsicons::bs_icon("book"),
    showcase_layout = "top right",
    theme = 'primary'
  )
)
