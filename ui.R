ui <- tagList(
  
  tags$head(
    tags$title(
      "Registro tumori animali"
    ),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"),
    tags$link(rel="icon", href="logo/favicon.ico"),
    tags$base(target="_blank"),
    # tags$meta(
    #   content = "IZSLER Shiny Registro tumori animali",
    #   name = "description"
    # ),
    # tags$link(
    #   rel = "preconnect",
    #   href = "https://fonts.gstatic.com"
    # ),
    tags$link(
      href = "https://fonts.googleapis.com/css2?family=Montserrat&display=swap",
      rel = "stylesheet"
    ),
    # css----
    tags$style(HTML(
      "
      body {
      font-family: 'Montserrat';
      }
      
      .bslib-page-navbar>.navbar+div {
      /*padding: 0;*/
      }
      
      div.bslib-sidebar-layout.bslib-mb-spacing.html-fill-item {
      /*margin-left: -12px;*/
      /*margin-right: -12px;*/
      }
      
      .bslib-sidebar-layout {
      border-top: var(--bs-border-width) solid var(--bs-border-color-translucent);
      border-bottom: var(--bs-border-width) solid var(--bs-border-color-translucent);
      }
 
      .tab-content > .tab-pane {
      min-height: calc(100vh - 111px);
      }
      
      .leaflet-container { background: transparent; cursor: auto !important; }
      
      .html-widget {
      margin: auto;
      }
      
      #btn2 {
      color: #6c757d;
      background-color: lightgrey !important;
      }

      #btn2:hover {
      filter: brightness(85%);
      }
      
      
      .footer {
      border-top: var(--bs-border-width) solid var(--bs-border-color-translucent);
      }
     
      footer > ul > li > a:hover { filter: brightness(75%); }
      footer > ul > li:nth-child(1) > a { color: #4267B2; }
      footer > ul > li:nth-child(2) > a { color: #0077B5; }
      footer > ul > li:nth-child(3) > a { color: #000000; }
      
 
      #main_tab > li:nth-child(1) { display: none; }
      #main_tab > li:nth-child(2) { display: none; }
      #main_tab > li:nth-child(3) { display: none; }
      #main_tab > li:nth-child(4) { display: none; }
      
      
      /* nascondi nav_panel_hidden */

      #nav_tab > li:nth-child(5) { display: none; }
      
      .nav-pills .nav-item {
      border-radius: 50px;
      border: var(--bs-border-width) solid var(--bs-border-color-translucent) !important;
      }
      
      
      .nav-pills {
      --bs-nav-pills-border-radius: 50px;
      /* justify-content: center; */
      gap: 50px;
      width: 80%;
      margin: 30px auto;
      /* border-bottom: var(--bs-border-width) solid var(--bs-border-color-translucent) !important; */
      }
      
      .nav-pills .nav-link {
      background-color: #eeeeee;
      color: #0000008c;
      }
      
      .nav-pills .nav-link:hover {
      background-color: #e2eaf7;
      color: #2f5aa2;
      }
      
      .nav-pills .nav-link.active {
      background-color: #e2eaf7;
      color: #2f5aa2;
      }
      
      
      .navbar-header {
      display: flex;
      justify-content: center;
      width: 100%;
      }
      
      /*vertical align link in navbar*/
      
      .navbar:not(.navbar-expand):not(.navbar-expand-sm):not(.navbar-expand-md):not(.navbar-expand-lg):not(.navbar-expand-xl) .navbar-nav {
      -webkit-flex-direction: column;
      }
     
      #main_tab > li.dropdown.nav-item > a {
      padding-top: 0;
      margin-bottom: 0;
      border: 0;
      }
      



      
      "))),
  
  # https://mdbootstrap.com/docs/standard/navigation/pills/
  
  
  # header----
  page_navbar(
    useShinyjs(),
    id = "main_tab",
    # theme = bs_theme() %>%
    #     bs_add_rules("
    #         .navbar-header {
    #             position: absolute;
    #         }
    #         ul.nav.navbar-nav { 
    #             display: flex;
    #             justify-content: center;
    #         }
    #     "),
    title = h1(style = "padding:0 ; margin:0; cursor: default;", "REGISTRO TUMORI ANIMALI"),
    # header = h1("Provincia di Bologna", style = "text-align: center;", class = "px-3 my-3"),
    bg = "#ABBDD7",
    underline = TRUE,
    fillable = FALSE,
    # home----
    navset_pill(id = "nav_tab",
              #   shinyjs::extendShinyjs(
              #     functions = c(),
              #     text = "shinyjs.init = function(){
              #   $('#nav_tab li a[data-value = hidden_tab]').hide();
              # }"),
    nav_panel(HTML("<i class='fas fa-chart-pie fa-fw me-2'></i> home"), 
              page_fillable(
                card(
                  full_screen = TRUE,
                  # card_header("PROVINCIA DI BOLOGNA"),
                layout_sidebar(
                  fillable = TRUE,
                  # class = "pt-0 pl-0 pb-0",
                  class = "p-0",
                  # border = TRUE,
                  # border_color = "#364652",
                  border_radius = FALSE,
                  bg = "#f5f5f5",
                  sidebar = sidebar("Left sidebar", 
                                    bg = "#f5f5f5",
                                    width = 300,
                                    div(
                                      circleButton(inputId = "btn1", size = "lg", icon = icon("dog")),
                                      circleButton(inputId = "btn2", icon = icon("cat")),
                                      actionBttn(
                                        inputId = "Id103",
                                        label = NULL,
                                        style = "material-circle", 
                                        color = "royal",
                                        icon = icon("bars"))
                                    ),
                                    checkboxGroupButtons(
                                      inputId = "Id050",
                                      label = NULL,
                                      choiceNames = c(HTML('<i class="fa-solid fa-dog fa-2x" title="filter dog"></i>'), 
                                                      HTML('<i class="fa-solid fa-cat title="filter cat""></i>')),
                                      choiceValues = c("dog", "cat"),
                                      selected = c("dog", "cat"),
                                      # justified = T,
                                      individual = T
                                      
                                      
                                    )),
                  layout_sidebar(
                    class = "p-0",
                    sidebar = sidebar("Right sidebar", 
                                      bg = "#f5f5f5",
                                      position = "right",
                                      open = TRUE,
                                      width = 300,
                                      div("INSERISCI DATI SINTESI")
                    ),
                    leafletOutput("mymap"),
                    border = FALSE
                  )
                )),
                br(),
                layout_columns(class = "mx-5",
                  # fillable = T,
                  col_widths = c(5, 2, 5),
                  # breakpoints(),
                  plotlyOutput("p1"),
                  breakpoints(),
                  plotlyOutput("p2")
                  # breakpoints()
                ),
                br(),
                layout_columns(class = "mx-5",
                  # fillable = T,
                  col_widths = c(5, 2, 5),
                  # breakpoints(),
                  plotlyOutput("p3"),
                  breakpoints(),
                  plotlyOutput("p4")
                  # breakpoints()
                )
              )
    ),
    
    # data----
    nav_panel(HTML("<i class='fas fa-home fa-fw me-2'></i> data"),
              page_fluid(
                DT::dataTableOutput("tab_home")
              )
    ),
    # info----
    nav_panel(HTML("<i class='fas fa-magnifying-glass fa-fw me-2'></i> info"),
              page_fillable(
                p("Third page content."),
              card(
                plotOutput("my_plot")
              )
              )
    ),
    
    # four----
    nav_panel(title = "Four",
              # page_fluid(
              #   layout_sidebar(
              #     sidebar = sidebar("Provincia di Bologna",
              #                       div(
              #                       circleButton(inputId = "btn1", size = "lg", icon = icon("dog")),
              #                       circleButton(inputId = "btn2", icon = icon("cat")),
              #                       actionBttn(
              #                         inputId = "Id103",
              #                         label = NULL,
              #                         style = "material-circle", 
              #                         color = "royal",
              #                         icon = icon("bars"))
              #                       ),
              #                       checkboxGroupButtons(
              #                         inputId = "Id050",
              #                         label = NULL,
              #                         choiceNames = c(HTML('<i class="fa-solid fa-dog fa-2x" title="filter dog"></i>'), 
              #                                     HTML('<i class="fa-solid fa-cat title="filter cat""></i>')),
              #                         choiceValues = c("dog", "cat"),
              #                         selected = c("dog", "cat"),
              #                         # justified = T,
              #                         individual = T
              #                         
              #                         
              #                       )
              #                       ),
              #     layout_columns(#fill = T,
              #     leafletOutput("mymap"#, width = 400
              #                   )
              #     # ,
              #     # uiOutput("modal")
              #     )
              #     ),
              #   br(),
              #   layout_columns(
              #     # fillable = T,
              #     col_widths = c(1, 5, 5, 1),
              #     breakpoints(),
              #     plotlyOutput("p1"),
              #     # breakpoints(),
              #     plotlyOutput("p2"),
              #     breakpoints()
              #     ),
              #   br(),
              #   layout_columns(
              #     # fillable = T,
              #     col_widths = c(1, 5, 5, 1),
              #     breakpoints(),
              #     plotlyOutput("p3"),
              #     # breakpoints(),
              #     plotlyOutput("p4"),
              #     breakpoints()
              #   )
              #   )
              
              
    ),
    # five hidden----
    nav_panel_hidden("hidden_tab", p("prova hidden"))
    ),
    hr(style="margin-bottom: 0px;"),
    layout_columns(style = "margin:20px",
                   width = 1/5,
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.regione.emilia-romagna.it/"><img src="logo/logo_ER.png" alt="emilia-romagna" style="height:90px">
                               </a></div>'),
                   HTML('
                               <div class="img-container" style = "text-align: center;">
                               <a href="https://www.ausl.bologna.it/"><img src="logo/logo_asl_bo_mod.png" alt="ausl-bo" style="height:90px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.izsler.it//"><img src="logo/removebg.png" alt="izsler" style="height:90px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.mediciveterinari.bo.it/"><img src="logo/ordvetbo.jpg" alt="ordvet-bo" style="height:90px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://scienzemedicheveterinarie.unibo.it/it"><img src="logo/logo-unibo.png" alt="unibo" style="height:90px">
                               </a></div>')
    ),
    
    
    
    nav_spacer(),
    nav_menu(
      title = "Links",
      value = "Links",
      align = "right",
      nav_item(link_shiny),
      nav_item(link_posit)
    ),
    # footer----
    footer = HTML(
      paste0("<footer class='footer' style='cursor: default; padding: 5px 15px; margin:0px -12px; background-color:#ABBDD7; display: flex; justify-content: space-between;'>",
             # "<span style='cursor:default;'>",
             "Istituto Zooprofilattico Sperimentale della Lombardia e dell'Emilia Romagna &quot;BRUNO UBERTINI&quot;",
             # "</span>",
             "<ul style='list-style:none; margin: 0; padding: 0; display: flex; gap: 10px;'>",
             "<li><a  href='https://www.facebook.com/people/Istituto-Zooprofilattico-Sperimentale-Della-Lombardia-Ed-Emilia-Romagna/100087222248133/' target='_blank'>",
             "<i class='fa fa-brands fa-facebook-f' aria-hidden='true'></i>",
             "</a></li>",
             "<li><a href='https://it.linkedin.com/company/izsler' target='_blank'>",
             "<i class='fa fa-brands fa-linkedin-in' aria-hidden='true'></i>",
             "</a></li>",
             "<li><a  href='https://twitter.com/izsler' target='_blank'>",
             "<i class='fa fa-brands fa-x-twitter' aria-hidden='true'></i>",
             "</a></li>",
             "</ul>",
             "</footer>")
    )
  )
)