server <- function(input, output, session) {
  
  # shinymanager
  # authentication module
  auth <- callModule(
    module = auth_server,
    id = "auth",
    check_credentials = check_credentials(credentials)
  )
  
  
  observe({
    req(auth$user=="admin")
    shinyjs::show("fab_btn_div")
  })
  
  output$res_auth <- renderPrint({
    reactiveValuesToList(auth)
  })
  
  observeEvent(session$input$logout,{
    session$reload()
  })
  
  
  
  
  
  
  shinyjs::addClass(class = "nav-justified", selector = ".nav-pills") #nav-fill
  
  # observe(session$setCurrentTheme(
  #   if (isTRUE(input$dark_mode)) dark else light
  # ))
  

  # zoom <- reactive({
  #   if(is.null(input$map01_zoom)){
  #     return(9)
  #   }else{
  #     return(input$map01_zoom)
  #   }
  # })
  # 
  # center <- reactive({
  #   if(is.null(input$map01_center)){
  #     return(c(11.31, 44.44))
  #   }else{
  #     return(input$map01_center)
  #   }
  # })
  
  
  
  
  labels <- reactive({
    paste("<strong style='font-family:Montserrat;font-size:18px;text-transform:uppercase'>",
          comuni$COMUNE,
          "</strong><br>") %>%
      lapply(htmltools::HTML)
  })
  
  # mymap----
  output$mymap <- renderLeaflet({
    
    pal <- colorNumeric("Reds", domain=comuni$casi_cane)
    
    comuni %>%
      leaflet(
        options = leafletOptions(
          minZoom = 9,
          maxZoom = 10,
          zoomControl=FALSE,
          attributionControl=FALSE)) %>%
      # addProviderTiles(providers$CartoDB.Positron) %>% 
      # addTiles() %>% 
      # setView(lng = center()[1],
      #         lat = center()[2],
      #         zoom = zoom()) %>% 
      setView(lng = 11.31,
              lat = 44.44,
              zoom = 9) %>% 
      # addPolygons(data = regioneER, fill = FALSE, weight = 1, color = "black") %>% 
      # addPolygons(data = provinceER, fill = FALSE, weight = 1, color = "black") %>% 
      
      addPolygons(layerId = ~COMUNE,
                  color = "#444444",
                  weight = 1,
                  smoothFactor = 0.5,
                  opacity = 0.7,
                  fillOpacity = 0.7,
                  fillColor = ~ ifelse(casi_cane == 0, "#fff", pal(casi_cane)),
                  label = ~labels(),
                  highlightOptions = highlightOptions(fillOpacity = 0.6,
                                                      # color = "red",
                                                      # fillColor = "yellow",
                                                      weight = 3,
                                                      bringToFront = TRUE)) %>%
      
      addEasyButton(
        easyButton(
          id = 'reset_btn',
          # icon = HTML("<div>
          #             <i class='fas fa-arrows-rotate'></i>
          #             <span style = 'font-size:18px;font-family:Montserrat;font-weight:bold;'> reset </span>
          #             </div>"),
          icon = HTML("<div>
                    <span style = 'font-size:18px;font-family:Montserrat;font-weight:bold;'> PROVINCIA DI BOLOGNA </span>
                    </div>"),
          title = "reset map",
          position = "bottomright",
          onClick = JS("function(btn, map){ map.setView([44.44, 11.31], 9); }"))) %>% 
      # https://stackoverflow.com/questions/48450273/how-to-set-zoom-level-view-of-leaflet-map
      setMaxBounds(10.8037-1,44.06226,11.84204+1,44.80476) 
    # addControl(title, position = "bottomleft", className="map-title")
    
    
    # https://gis.stackexchange.com/questions/301839/how-to-create-independent-fixed-inset-maps-with-leaflet
    
    # https://gis.stackexchange.com/questions/231103/cutting-leaflet-map-in-r-to-a-specific-area
    # https://github.com/rstudio/leaflet/issues/486
    # https://www.r-bloggers.com/2019/12/quick-tips-for-customizing-your-r-leaflet-map/
    # https://rstudio.github.io/leaflet/articles/shiny.html
    # https://www.r-bloggers.com/2017/03/4-tricks-for-working-with-r-leaflet-and-shiny/
    
    # onRender
    # https://stackoverflow.com/questions/71013017/move-zoom-controls-in-leaflet-for-r-shiny
  })
  
  
  
  clicked_shape <- reactiveVal(NULL)
  
  
  observeEvent(input$mymap_shape_click, {
    
    click <- input$mymap_shape_click
    
    leafletProxy("mymap") %>% 
      setView(lng = comuni$lon_centroid[comuni$COMUNE == click$id], lat = comuni$lat_centroid[comuni$COMUNE == click$id], zoom = 10)
    # setView(lng = click$lng, lat = click$lat, zoom = 10)
    
    clicked_shape(input$mymap_shape_click)
    
    updateSelectizeInput(session, "selcom", selected = character(0))
    
  })
  
  
  sel_comune <- reactive({
    comuni %>%
      filter(COMUNE %in% input$selcom)
  })
  
  # sel_comune <- reactiveVal(NULL)
  
  
  observeEvent(input$selcom, {
    
    # sel_comune(input$selcom)
    
    leafletProxy("mymap") %>% 
      clearPopups() %>% 
      addPopups(
        data = sel_comune(),
        popup = ~COMUNE,
        ~lon_centroid, 
        ~lat_centroid) %>% 
      setView(lng = sel_comune()$lon_centroid, lat = sel_comune()$lat_centroid, zoom = 10)
    # clearMarkers() %>% 
    # addMarkers(
    #   # data = comuni[comuni$COMUNE == sel_comune(), ],
    #   data = sel_comune(),
    #           ~lon_centroid, 
    #           ~lat_centroid)
    
  })
  
  # reset map----
  onclick("reset_btn", {
    clicked_shape(NULL);
    updateSelectizeInput(session, "selcom", selected = character(0))
  })
  
  
  # https://stackoverflow.com/questions/73314170/distinguish-between-inputmap-click-and-inputmap-shape-click-in-leaflet-r-shiny
  # https://stackoverflow.com/questions/76465586/click-on-a-polygon-of-a-leaflet-map-and-subset-the-same-dataset-which-is-display
  
  
  # data----
  cases <- reactive({
    cases <- dati %>% 
      arrange(desc(data)) %>%
      mutate(child = "<i class=\"fas fa-circle-plus\" role=\"presentation\" style=\"color:currentcolor\" aria-label=\"circle-plus icon\"></i>") %>% 
      select(child, data, comune, codice_soggetto, specie, razza,
             sesso, eta,
             vet_icd_o_1_code, organi_fissati,
             anamnesi_e_quesito_diagnostico, 
             diagnosi_istologica, sede_prelievo_istologica,
             diagnosi_citologica, sede_prelievo_citologica,
             comorbilita, metastasi)
    
    cases
    
  })
  
  
  output$tab_data <- DT::renderDataTable({
    DT::datatable(
      cases(),
      # fillContainer = TRUE,
      rownames = F,
      escape = F,
      style = 'bootstrap4',
      selection = "none",
      # class = "cell-border stripe compact",
      colnames = c(" ", "data", "comune", "codice_paziente", "specie",
                   "razza", "sesso", "età", "vet_icd_o_1", "organi_fissati",
                   "anamnesi", 
                   "diagnosi istologica", "sede prelievo istologica",
                   "diagnosi citologica", "sede prelievo citologica",
                   "comorbilità", "metastasi"),
      callback = JS(
        "$('tbody').css('cursor', 'default')",
        # "$('div.dwnld').append($('#download_pubbl'));", # assegnare id
        "table.column(1).nodes().to$().css({cursor: 'pointer'});
         var format = function(d) {
         return '<div style=\"background-color:#eee; padding: .5em;\"> <strong>ANAMNESI:</strong> ' + d[10] +
         '<br><strong>DIAGNOSI:</strong> ' + d[11] +
         '<br><strong>COMORBILITÀ:</strong> ' + d[15] +
         '<br><strong>METASTASI:</strong> ' + d[16] +'</div>';
         };
         table.on('click', 'td.details-control', function() {
         var td = $(this), row = table.row(td.closest('tr'));
         if (row.child.isShown()) {
         row.child.hide();
         td.html('<i class=\"fas fa-circle-plus\" role=\"presentation\" style=\"color:currentcolor\" aria-label=\"circle-plus icon\"></i>');
         } else {
         row.child(format(row.data())).show();
         td.html('<i class=\"fas fa-circle-minus\" role=\"presentation\" style=\"color:currentcolor\" aria-label=\"circle-plus icon\"></i>');
         }
         });"
      ),
      options = list(
        lengthMenu = list(c(5, 10, 25, 50), c('5', '10','25','50')), #togli se non vuoi "tutti"
        pageLength = 10,
        language = list(search = "Cerca: ",
                        paginate = list(previous = "Precedente", `next` = "Successiva"),
                        info = "_START_ - _END_ di _TOTAL_ voci",
                        infoFiltered = "",
                        infoEmpty = "-",
                        zeroRecords = "- - -",
                        lengthMenu = "Mostra _MENU_ righe"),
        columnDefs = list(
          list(visible = FALSE, targets = c(10,11,12,13,14)),
          # list(width = '40px', targets =c(0)),
          # list(width = '50px', targets =c(1)),
          # list(width = '40px', targets =c(9)),
          # list(className = 'dt-center', targets = c(0)),
          # list(className = 'dt-body-right', targets = c(1, 9)),
          # list(className = 'dt-head-right', targets = c(1, 9)),
          # list(className = 'dt-head-center', targets = "_all"),
          list(orderable = FALSE, className = 'details-control', targets = 0)
        ),
        scrollX = TRUE)
    ) %>% 
      formatDate(c("data"), 'toLocaleDateString')
    
  })
  
  
  
  # p1----
  output$p1 <- renderPlotly({
    dati %>% 
      group_by(specie, razza) %>% 
      summarise(casi = n(), .groups = "drop") %>% 
      arrange(desc(casi)) %>% 
      head(5) %>% 
      plot_ly(x = ~casi, y = ~razza, type = "bar", #color = ~razza, 
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)), 
              
              text = ~casi, textfont = list(color = '#000'),
              textposition = 'outside') %>% 
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Top 5 razze di cane affette da tumore', x = 0.05),
        xaxis = list(title = "numero di casi"),
        yaxis = list(title = "", categoryorder = "total ascending"),
        showlegend = F) %>%
      config(displayModeBar = FALSE) %>% 
      style(hoverinfo = 'none')
    
  })
  
  # p2----
  output$p2 <- renderPlotly({
    dt <- dati %>% 
      group_by(vet_icd_o_1_code) %>% 
      summarise(casi = n(), .groups = "drop") %>% 
      mutate(perc = casi/(sum(casi))) %>% 
      arrange(desc(perc)) %>% 
      head(5)
    
    max_range <- max(dt$perc)+0.06-max(dt$perc)%%0.05
    
    dt %>% 
      plot_ly(x = ~perc, y = ~vet_icd_o_1_code, type = "bar", #color = ~vet_icd_o_1_code,
              source = "p2",
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)),
              text = "clicca qui per ulteriori dettagli",
              hoverinfo = "text",
              texttemplate = '%{x:.0%}',
              textfont = list(color = '#000'),
              textposition = 'outside') %>% 
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Top 5 tipi di tumore canino', x = 0.05),
        xaxis = list(title = "% di casi", tickformat = ".0%",
                     range = list(0, max_range),
                     tick0 = 0,
                     dtick = 0.05),
        yaxis = list(title = "", categoryorder = "total ascending"),
        showlegend = F) %>%
      config(displayModeBar = FALSE) 
      # style(hoverinfo = 'none')
    
  })
  
  
  # diagn <- reactive({
  #   diagnosi %>% 
  #     filter(vet_icd_o == event_data$y) %>% 
  #     select(vet_icd_o, categoria, term)
  # })
  
  # https://stackoverflow.com/questions/70265205/plotly-shiny-reactive-values-error-function-not-found
  # plotly_click <- reactiveVal(NULL)
  plotly_barclick <- reactiveValues(selections=NULL)
  
  observeEvent(
    event_data("plotly_click", source = "p2", priority = "event"), {
      
      # plotly_click(event_data("plotly_click", source = "p2", priority = "event"))
      plotly_barclick <- event_data("plotly_click", source = "p2", priority = "event")
      
      showModal(#tags$div(id="modal_plotly",
        modalDialog(
          easyClose = TRUE,
          footer = NULL, #modalButton("Chiudi"),
          # title = paste0("Vet-ICD-O: ", plotly_barclick$y),
          title = div(style = "font-size: 18px;",
                      HTML(paste0("Vet-ICD-O: ", plotly_barclick$y
                                  # "<br>",
                                  # "ICD-O: ", unique(gt_diagnosi$icd_o_code[gt_diagnosi$vet_icd_o == plotly_barclick$y])
                                  )
                           )),
          uiOutput('modalDT')
          
        ))
      
    })
  
  output$modalDT <- renderUI({
    
    plotly_barclick <- event_data("plotly_click", source = "p2", priority = "event")
    
    gt_diagnosi %>% 
      filter(vet_icd_o %in% plotly_barclick$y) %>% 
      select(classe, categoria, term, synonym, related) %>%
      arrange(classe, categoria) %>% 
      DT::datatable(
        rownames = F,
        escape = F,
        selection = "none",
        options = list(
          dom="t",
          pageLength = 9999)
      )
    
  })
  
  
  
  # p3----
  output$p3 <- renderPlotly({
    dt <- dati %>%
      group_by(specie, eta_classe) %>% 
      summarise(n = n(), .groups = "drop") %>%  
      mutate(perc = n/sum(n))
    
    max_range <- max(dt$perc)+0.11-max(dt$perc)%%0.05
    
    dt %>% 
      plot_ly(x = ~eta_classe, y = ~perc, type = "bar", #color = ~eta_classe,
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)),
              text = ~perc, textfont = list(color = '#000'),
              texttemplate = '%{y:.1%}', 
              textposition = 'outside') %>% 
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Età media alla diagnosi', x = 0.05),
        xaxis = list(title = "", tickangle= -45),
        yaxis = list(title = "% di casi", tickformat = ".0%",
                     range = list(0, max_range),
                     tick0 = 0,
                     dtick = 0.05),
        showlegend = F) %>%
      config(displayModeBar = FALSE) %>% 
      style(hoverinfo = 'none')
    
  })
  
  # p4----
  output$p4 <- renderPlotly({
    dati %>%
      mutate(
        data_anno = year(data),
        data_mese = month(data), .after = data) %>% 
      filter(data_anno == 2023) %>% 
      group_by(data_mese) %>% 
      count() %>% 
      ungroup() %>% 
      mutate(data_mese2 = as.character(month(ymd(010101) + months(data_mese-1),label=TRUE,abbr=F))) %>% 
      plot_ly(x = ~data_mese, y = ~n, type = "scatter", mode="markers+lines+text", #source = "A",
              text = ~n, 
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)), 
              textfont = list(color = '#000'),
              textposition = 'top') %>%        
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Andamento mensile', x = 0.05),
        xaxis = list(title = '',
                     tickvals = seq(1, 12, by = 1),
                     ticktext = ~data_mese2), 
        yaxis = list(title = 'numero di casi'),
        showlegend = F) %>%
      config(displayModeBar = FALSE) %>% 
      style(hoverinfo = 'none')
    
  })
  
  # sidebar right----
  
  # data1<-reactive({
  #   if (input$muni!='Show all') {
  #     data<-data[which(data$name==input$muni),]
  #   }
  #   if (input$area!='Show all') {
  #     data<-data[data[input$area]!=0,]
  #   }
  #   return(data)
  # })
  
  filtered_com <- reactive({
    if (!is.null(clicked_shape())) {
      
      comuni %>%
        filter(COMUNE == clicked_shape()$id)
      
    } else {
      
      casi %>% 
        rename(#casi_cane = casi_Cane,
               comune_1 = comune) %>% 
        bind_rows(summarise(.,
                            across(where(is.numeric), sum),
                            across(comune_1, ~"Provincia di Bologna"))) %>% 
        filter(comune_1 == "Provincia di Bologna")
      
    }
  })
  
  
  output$ui_sidebar_right <- renderUI({
    
    if (!is.null(clicked_shape())) {
      
      div(
        HTML(
          paste0(
            "<b>",filtered_com()$comune_1,"</b>",
            "<br>",
            "CAP: ", filtered_com()$cap,
            "<br>",
            "casi registrati: ",
            filtered_com()$casi_cane
            
          )))
      
    } else { 
      
      div(
        HTML(
          paste0(
            "<b>",
            filtered_com()$comune_1,
            "</b>",
            "<br>",
            "casi registrati: ",
            filtered_com()$casi_cane
            
          )))
      
      
    }
    
  })
  
  
  # vet datatable----
  
  
  # gt_diagnosi <- reactive({
  #   gt_diagnosi %>% 
  #     select(-related) %>% 
  #     arrange(classe, categoria, vet_icd_o) %>%  
  #     relocate(vet_icd_o, .before = icd_o_code) %>% 
  #     mutate(icd_o_code = ifelse(icd_o_code == "NONE", "-", icd_o_code)) %>%
  #     filter(
  #       conditional(input$inputClasse != "", classe == input$inputClasse),
  #       conditional(input$inputCategoria != "", categoria == input$inputCategoria),
  #       
  #       conditional(input$inputCode != "", str_detect(vet_icd_o, input$inputCode)))
  # })
  
  
  # output$ui_vet <- renderUI({
  #   div(
  #     as_fill_item(),
  #     dataTableOutput("vet")
  #   )
  # })
  
  output$vet <- DT::renderDataTable({
    
    gt_diagnosi %>% 
      select(-related) %>% 
      arrange(classe, categoria, vet_icd_o) %>%  
      relocate(vet_icd_o, .before = icd_o_code) %>% 
      mutate(icd_o_code = ifelse(icd_o_code == "NONE", "-", icd_o_code)) %>% 
      DT::datatable(
        fillContainer = TRUE,
        rownames = F,
        escape = F,
        style = "bootstrap4",
        # class = 'cell-border compact',
        # class = 'table-bordered table-condensed',
        selection = "none",
        callback = JS("$('tbody').css('cursor', 'default')"),
        options = list(dom = "ft<'vetwrap'lip>",
                       lengthMenu = list(c(5, 10, 25, 50), c('5', '10','25','50')), #togli se non vuoi "tutti"
                       # lengthChange = TRUE,
                       # paging = TRUE,
                       searching = TRUE,
                       language = list(search = "Cerca: ",
                                       paginate = list(previous = "Precedente", `next` = "Successiva"),
                                       info = "_START_ - _END_ di _TOTAL_ voci",
                                       infoFiltered = "",
                                       infoEmpty = "-",
                                       zeroRecords = "- - -",
                                       lengthMenu = "Mostra _MENU_ righe"),
                       columnDefs = list(
                         # list(visible = FALSE, targets = c(3, 4, 5, 6, 7, 8)),
                         # list(width = '40px', targets =c(0)),
                         # list(width = '50px', targets =c(1)),
                         # list(width = '40px', targets =c(9)),
                         # list(className = 'dt-center', targets = c(0))
                       )
        )
      )
  })
  
  DTproxy_vet <- dataTableProxy("vet") 
  
  observeEvent(input$inputClasse, {
    updateSearch(DTproxy_vet,
                 keywords = list(global = input$inputClasse, columns = "classe"))
  })     
  
  observeEvent(input$inputCategoria, {
    updateSearch(DTproxy_vet,
                 keywords = list(global = input$inputCategoria, columns = "categoria"))
  })   
  
  observeEvent(input$inputVETCode, {
    updateSearch(DTproxy_vet,
                 keywords = list(global = input$inputVETCode, columns = c("vet_icd_o")))
  })   
  
  observeEvent(input$inputICDCode, {
    updateSearch(DTproxy_vet,
                 keywords = list(global = input$inputICDCode, columns = c("icd_o_code")))
  })   
  
  
  observe({
    x <- input$inputClasse
    
    choices_cat <- as.character(sort(unique(diagnosi$categoria[diagnosi$classe == x])))
    
    if (x == "") 
      choices_cat <- c("", sort(unique(diagnosi$categoria)))
    
    updateSelectInput(session, "inputCategoria",
                      choices = choices_cat,
                      selected = c("")
    )
  })
  
  # output$modal <- renderUI({
  #   # click <- input$mymap_shape_click
  #   req(clicked())
  #   if(is.null(clicked())) {
  #     return()
  #   } else { 
  #   card(id = "card1",
  #     card_header(HTML(paste("<strong>",
  #                            comuni$COMUNE[comuni$COMUNE == clicked()$id],
  #                            "</strong><br>"))),
  #     card_body(
  #                  datatable(dati %>%
  #                    filter(comune == clicked()$id) %>% 
  #                    group_by(specie, vet_icd_o_1_code) %>%
  #                    summarise(casi = n()) %>%
  #                    slice_max(order_by = casi, n = 3),
  #                    rownames = F,
  #                    options = list(dom="t"))),
  #     full_screen = FALSE)
  #   }
  # })
  
  
  # NO
  # https://stackoverflow.com/questions/34985889/how-to-get-the-zoom-level-from-the-leaflet-map-in-r-shiny
  # observe({
  #   # sel_site <- df[df$site == input$site,]
  #   # isolate({
  #     new_zoom <- 10
  #     if(input$mymap_zoom==new_zoom) {
  #       # new_zoom <- input$mymap_zoom
  #       leafletProxy('mymap') %>%
  #       setView(11.31, 44.44, zoom = new_zoom)
  #     }
  #   # })
  # })
  # 
  
  
  
}



