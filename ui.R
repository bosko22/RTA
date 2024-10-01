ui <- tagList(
  # shinymanager
  auth_ui(id = "auth"),
  shinyjs::hidden(tags$div(id = "fab_btn_div",fab_button(
    actionButton(
      inputId = "logout",
      label = NULL,
      tooltip = "Logout",
      icon = icon("sign-out")
    ))
  )),
  
  
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
      font-family: 'Open Sans'; /*'Montserrat'; */
      }
      
      /*.tab-content > .tab-pane[data-value = home]*/ 
        
      .tab-content > .tab-pane {
      min-height: calc(100vh - 350px);
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
 
      
      .leaflet-container { 
      background: transparent;
      cursor: auto !important; 
      }
      
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

      #nav_tab > li:nth-child(6) { display: none; }
      
      .nav-pills .nav-item {
      border-radius: 50px;
      /*border: var(--bs-border-width) solid var(--bs-border-color-translucent) !important;*/
      }
      
      .nav-pills .nav-link {
      border: 1px solid;
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
      
      .navbar-brand {
      padding:0;
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
      
    
      #reset_btn {
      width: auto;
      background: #e2eaf7;
      }
      
      #reset_btn:hover {
      filter: brightness(85%);
      }
      
      
      .leaflet-touch .leaflet-bar {
      border: 1px black solid;
      }
      
      .leaflet-tooltip{
      border: 2px solid rgba(0, 0, 0, 0.7);
      border-radius: 4px;
      background-color: rgba(255, 255, 255, 0.8);
      }
      
      .leaflet-popup-content-wrapper{
      border: 2px solid rgba(0, 0, 0, 0.7);
      border-radius: 4px;
      font-family:Montserrat;
      font-size:16px;
      text-transform:uppercase;
      font-weight:bold;
      background-color: rgba(255, 255, 255, 0.8);
      }
      
      
      
      .select_comune .selectize-dropdown {
      bottom: 100% !important;
      top:auto!important;
      }
      
      .modal-dialog {
      font-size: 14px;
      /*min-width: fit-content;*/
      max-width: 140vh;
      margin-top: 30px;
      margin-bottom: 30px;
      }
      
      .modal-header {
       padding-bottom: 0px !important;
      }
      
      
      
      #vet .dataTables_filter {
      display: none;
      }
      
      #vet td {
      vertical-align: middle;
      padding: 4px;
      border: 2px white solid;
      }
      
      #tab_data td {
      vertical-align: middle;
      padding: 4px;
      border: 2px white solid;
      }
      
      #tab_data table.dataTable {
      font-size: 15px;
      }
     
      
      #vet table.dataTable {
      font-size: 15px;
      }
      
      /*table.dataTable {*/
      /*margin: 0 auto;*/
      /*width: 100%;*/
      /*clear: both;*/
      /*border-collapse: collapse;*/
      /*table-layout: fixed;*/
      /*word-wrap: break-word;*/
      /* }*/
      
      #vet .vetwrap {
      display: flex;
      justify-content: space-between;
      align-items: center;
      }
      
      #vet .dataTables_info,
      #vet .dataTables_length,
      #vet .dataTables_paginate {
      padding-top: 20px;
      padding-bottom: 0px;
      }
      
      
      .mfb-component__wrap > a > i,
      .mfb-component__child-icon {
      bottom: 15px;
      }
      

      "))),
  
  # https://mdbootstrap.com/docs/standard/navigation/pills/
  
  
  # header----
  page_navbar(
    useShinyjs(),
    id = "main_tab",
    # theme = bs_theme() %>% 
    #   bs_add_rules(""),
    title = div(h1(style = "padding:0 ; margin:0; cursor: default;", "REGISTRO TUMORI ANIMALI"),
                h3(style = "padding:0 ; margin:0; cursor: default; text-align: center;", "Provincia di Bologna")),
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
                nav_panel(HTML("<i class='fas fa-home fa-fw me-2'></i> home"), 
                          value = "home",
                          page_fillable(
                            card(
                              full_screen = TRUE,
                              # card_header("PROVINCIA DI BOLOGNA"),
                              ## left----
                              layout_sidebar(
                                fillable = TRUE,
                                # class = "pt-0 pl-0 pb-0",
                                class = "p-0",
                                # border = TRUE,
                                # border_color = "#364652",
                                border_radius = FALSE,
                                bg = "#f6f6f6",
                                sidebar = sidebar(
                                  id = "sidebar_left",
                                  title = HTML(paste0(
                                    "<div>clicca sulla mappa per vedere il dettaglio dei casi segnalati ",
                                    "<i class='fas fa-arrow-right'></i></div>")), 
                                  bg = "#f6f6f6",
                                  width = 300,
                                  div(
                                    
                                    circleButton(inputId = "btn1", icon = icon("dog"))
                                    # circleButton(inputId = "btn2", icon = icon("cat")),
                                    
                                    #   actionBttn(
                                    #     inputId = "Id103",
                                    #     label = NULL,
                                    #     style = "material-circle", 
                                    #     color = "royal",
                                    #     icon = icon("bars"))
                                  ),
                                  selectizeInput("selanno", "Seleziona anno",
                                                 c("2023","2024"),
                                                 multiple = TRUE,
                                                 selected = c("2023")
                                  ),
                                  tags$div(class='select_comune',
                                           selectizeInput("selcom", "Cerca comune",
                                                          c("", sort(unique(comuni$COMUNE))),
                                                          selected = character(0),
                                                          multiple = FALSE,
                                                          options = list(
                                                            # maxOptions = 5,
                                                            # placeholder = 'Please select an option below',
                                                            # onInitialize = I('function() { this.setValue(""); }')
                                                          ))
                                  )
                                  
                                  # checkboxGroupButtons(
                                  #   inputId = "Id050",
                                  #   label = NULL,
                                  #   choiceNames = c(HTML('<i class="fa-solid fa-dog fa-2x" title="filter dog"></i>'), 
                                  #                   HTML('<i class="fa-solid fa-cat title="filter cat""></i>')),
                                  #   choiceValues = c("dog", "cat"),
                                  #   selected = c("dog", "cat"),
                                  #   # justified = T,
                                  #   individual = T
                                  #   
                                  #   
                                  # )
                                ),
                                ## right----
                                layout_sidebar(
                                  class = "p-0",
                                  sidebar = sidebar(
                                    id = "sidebar_right",
                                    title = NULL, #"Right sidebar", 
                                    bg = "#f6f6f6",
                                    
                                    position = "right",
                                    open = TRUE,
                                    width = 300,
                                    
                                    # actionBttn("resetmap", "RESET",
                                    #            style = "simple", 
                                    #            color = "primary",
                                    #            icon = icon("refresh")),
                                    uiOutput("ui_sidebar_right")
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
                nav_panel(HTML("<i class='fas fa-chart-pie fa-fw me-2'></i> data"),
                          value = "data",
                          page_fillable(
                            # card(full_screen = T,
                            #   card_body(
                            DT::dataTableOutput("tab_data")
                          # ))
                )
                ),

                # vet----
                nav_panel(HTML("<i class='fas fa-shield-dog fa-fw me-2'></i> Vet-ICD-O"),
                          page_fillable(
                            card(
                              HTML("<p><strong>System for Coding Canine Neoplasms Based on the Human ICD-O-3.2</strong>
                              <br>
                              Pinello, K.; Baldassarre, V.;
Steiger, K.; Paciello, O.; Pires, I.;
Laufer-Amorim, R.; Oevermann, A.;
Niza-Ribeiro, J.; Aresu, L.; Rous, B.;
et al.<br>Cancers
2022, 14, 1529. <a href='https://doi.org/
10.3390/cancers14061529'> 10.3390/cancers14061529</a><br>
<br>Cancer registries 
                              are fundamental tools for collecting epidemiological cancer data and developing cancer 
                              prevention and control strategies. While cancer registration is common in the human medical 
                              field, many attempts to develop animal cancer registries have been launched over time, but
                              most have been discontinued. A pivotal aspect of cancer registration is the availability of 
                              cancer coding systems, as provided by the International Classification of Diseases for Oncology
                              (ICD-O). Within the Global Initiative for Veterinary Cancer Surveillance (GIVCS), established to
                              foster and coordinate animal cancer registration worldwide, a group of veterinary pathologists
                              and epidemiologists developed a comparative coding system for canine neoplasms.
                              Vet-ICD-O-canine-1 is compatible with the human ICD-O-3.2 and is consistent with the currently 
                              recognized classification schemes for canine tumors.
                              <br>The Vet-ICD-O-canine-1 coding system represents a user-friendly, easily accessible, 
                                   and comprehensive resource for developing a canine cancer registration system that 
                                   will enable studies within the One Health space.</p>")
                              #   card(
                              #     plotOutput("my_plot")
                              #   )
                            ),
                            
                            card(
                              full_screen = TRUE,
                              card_header(
                                layout_columns(
                                  class = "mx-3 mt-3",
                                  gap = "40px",
                                  selectizeInput("inputClasse", "Filtra per classe", 
                                                 c("", sort(unique(diagnosi$classe))),
                                                 selected = c("")),
                                  selectizeInput("inputCategoria", "Filtra per categoria",
                                                 c("", sort(unique(diagnosi$categoria))),
                                                 selected = c("")),
                                  textInput("inputVETCode", "Filtra per VET-ICD-O"),
                                  textInput("inputICDCode", "Filtra per ICD-O")
                                )),
                              card_body(fillable = T,
                                        # as_fill_carrier(uiOutput("ui_vet"))
                                        dataTableOutput("vet")
                              ))
                          )
                ),
                # info----
                nav_panel(HTML("<i class='fas fa-regular fa-circle-info fa-fw me-2'></i> info"),
                          page_fillable(
                            p("Info page content.")
                            # card(
                            #   plotOutput("my_plot")
                            # )
                          )
                ),
                
                # partners----
                nav_panel(HTML("<i class='fas fa-handshake fa-fw me-2'></i> partners"),
                          page_fillable(
                            p("Partners page content.")
                          )
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
    layout_columns(style = "margin:10px",
                   width = 1/5,
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.regione.emilia-romagna.it/"><img src="logo/logo_ER.png" alt="emilia-romagna" style="height:70px">
                               </a></div>'),
                   HTML('
                               <div class="img-container" style = "text-align: center;">
                               <a href="https://www.ausl.bologna.it/"><img src="logo/logo_asl_bo_mod.png" alt="ausl-bo" style="height:70px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.izsler.it//"><img src="logo/removebg.png" alt="izsler" style="height:70px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://www.mediciveterinari.bo.it/"><img src="logo/ordvetbo.jpg" alt="ordvet-bo" style="height:70px">
                               </a></div>'),
                   HTML('<div class="img-container" style = "text-align: center;">
                               <a href="https://scienzemedicheveterinarie.unibo.it/it"><img src="logo/logo-unibo.png" alt="unibo" style="height:70px">
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