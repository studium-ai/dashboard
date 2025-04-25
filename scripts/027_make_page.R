img_data <- base64enc::dataURI(file = "www/STUDIUM.AI_RGB.png", mime = "image/png")


page = page_fillable(tagList(
  div(style = "display: flex; align-items: center;",
    tags$img(src = img_data, height = "50px", style = "margin-right:10px;"),
    h1("Dashboard"),
    style = "margin-left: 20px; margin-right: 1px;"
  )
),  navset_tab(nav_panel("Matrikels",br(), matrikels_value_boxes,
                layout_column_wrap(heights_equal = 'row',
                  width = 1/2,
                  mbl_card2,
                  mbl_card3,
                  mbl_card1,
                  mbl_card4
                ),
                layout_columns(heights_equal = 'row',
                  width = 1/2,
                  card2,
                  card3,
                  card4,
                  card5
                )
              ),
                         nav_panel("OUL",br(),oul_value_boxes, 
                                   layout_column_wrap(oul_card1)),
                         nav_panel("Manuale Lovaniense", br(), ml_value_boxes, 
                                   layout_column_wrap(ml_card1)),
                         nav_panel("Magister Dixit", br(),md_value_boxes,
                                   layout_column_wrap(md_card1)),
                         nav_panel("Theses", br(),the_value_boxes,
                                   layout_column_wrap(the_card1,the_card2, the_card3, the_card4 )),
                         nav_panel("Merged",br(), merged_value_boxes, layout_column_wrap(card14))))


htmltools::save_html(page, file = 'studium_dashboard.html')
