


ui <- page_sidebar(
  title = "Registro Tumori Animali",
  sidebar = sidebar("Controlli"),

#Main 
layout_columns(
  value_box(
    title = "N.casi registrati",
    value = "",
    showcase = bsicons::bs_icon("arrow-left-square-fill")
  ),
  value_box(
    title = "Incidenza",
    value = "+15.2%",
    showcase = bsicons::bs_icon("arrow-up-circle-fill")
  ),
  value_box(
    title = "xxx",
    value = "42%",
    showcase = fontawesome::fa_i("magnifying-glass-dollar")
  )
), 
card()
)



 