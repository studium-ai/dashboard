library(plotly)

card1 = card(HTML(tbl))



mbl_card1 = card(card_header("Age category"),HTML(mbl_tbl1))

mbl_card2 = card(card_header("Institutions"),HTML(mbl_tbl2))

mbl_card3 = card(card_header("Wealth category"),HTML(mbl_tbl3))

mbl_card4 = card(card_header("Gender"),HTML(mbl_tbl4))

card2 = card(card_header("Age"), ggplotly(p)%>%
               plotly::layout(legend=list(x=0, 
                                          xanchor='left',
                                          yanchor='bottom',
                                          orientation='h')) )

card3 = card(card_header("Pedagogy"),
             ggplotly(p2) %>%
               plotly::layout(legend=list(x=0, 
                                          xanchor='left',
                                          yanchor='bottom',
                                          orientation='h'))  )

card4 = card(card_header("Inscription fee"), ggplotly(p3) %>%
               plotly::layout(legend=list(x=0, 
                                          xanchor='left',
                                          yanchor='bottom',
                                          orientation='h')) )


card5 = card(card_header("Gender"),ggplotly(p4) %>%
               plotly::layout(legend=list(x=0, 
                                          xanchor='left',
                                          yanchor='bottom',
                                          orientation='h'))  )


matrikels_value_boxes = layout_columns(
  value_box(
    title = "People",
    value = mat_total_persons,
    showcase = bsicons::bs_icon("people"),
    showcase_layout = "top right",
    theme = 'success'
  ),
  value_box(
    "Places",
    value = mat_total_places,
    showcase = bsicons::bs_icon("geo-alt"),
    showcase_layout = "top right",
    theme = 'warning'
  ),
  value_box(
    "Institutions",
    value = mat_total_institutions,
    showcase = bsicons::bs_icon("buildings"),
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
