img_data <- base64enc::dataURI(file = "www/STUDIUM.AI_RGB.png", mime = "image/png")


dashboard = page_fillable(tagList(
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
                                   layout_column_wrap(md_card1,md_card2)),
              nav_panel("CAA", br(),caa_value_boxes,
                        layout_column_wrap(caa_card1,caa_card2, caa_card3, caa_card4 )),
              nav_panel("Lovaniensia", br(),lov_value_boxes,
                        layout_column_wrap(lov_card1,lov_card2, lov_card3, lov_card4 )),
                         nav_panel("Theses", br(),the_value_boxes,
                                   layout_column_wrap(the_card1,the_card2, the_card3, the_card4 )),
              nav_panel("DaLeT", br(),dalet_value_boxes,
                        layout_column_wrap(dalet_card1)),
                         nav_panel("Merged",br(), merged_value_boxes, layout_column_wrap(card14, merged_card2))))

library(htmltools)
save_html(dashboard, "studium_dashboard3.html")
