server <- function(input, output, session) {
  
  shinyjs::addClass(class = "nav-fill", selector = ".nav-pills") #nav-justified
  
  # observe(session$setCurrentTheme(
  #   if (isTRUE(input$dark_mode)) dark else light
  # ))
  
  output$my_plot <- renderPlot({
    plot(cars)
  })
  
  zoom <- reactive({
    
    if(is.null(input$map01_zoom)){
      return(9)
    }else{
      return(input$map01_zoom)
    }
    
  })
  
  center <- reactive({
    
    if(is.null(input$map01_center)){
      return(c(11.31, 44.44))
    }else{
      return(input$map01_center)
    }
    
  })
  

  labels <- reactive({
    paste("<strong>",
          comuni$COMUNE,
          "</strong><br>",

          "Casi riportati:",
          comuni$casi_totali,
          "<br>") %>%
      lapply(htmltools::HTML)
  })
  
  output$mymap <- renderLeaflet({
    
    pal <- colorNumeric("Reds", domain=comuni$casi_totali)
    
    leaflet(comuni,
      options = leafletOptions(
        minZoom = 9,
        maxZoom = 10,
        zoomControl=FALSE,
        attributionControl=FALSE)) %>%
      addProviderTiles(providers$CartoDB.Positron) %>% 
      # addTiles() %>% 
      setView(lng = center()[1],
              lat = center()[2],
              zoom = zoom()) %>% 
      # addPolygons(data = regioneER, fill = FALSE, weight = 1, color = "black") %>% 
      # addPolygons(data = provinceER, fill = FALSE, weight = 1, color = "black") %>% 
      addPolygons(layerId = ~COMUNE,
                  color = "#444444", weight = 1, smoothFactor = 0.5,
                  
                  opacity = 0.7,
                  
                  fillOpacity = 0.7,
                  
                  fillColor = ~pal(casi_totali),
                  
                  # fillColor = ~colorQuantile("YlOrRd", ALAND)(ALAND),
                  label = ~labels(),
                  
                  highlightOptions = highlightOptions(fillOpacity = 0.6,
                                                      # color = "red",
                                                      weight = 2,
                                                      bringToFront = TRUE)) %>%
      addEasyButton(
        easyButton(
        id = 'reset-btn',
        icon = "fa-arrows-rotate", 
        title = "Reset",
        position = "bottomleft",
        onClick = JS("function(btn, map){ map.setView([44.44, 11.31], 9); }"))) %>% 
      # https://stackoverflow.com/questions/48450273/how-to-set-zoom-level-view-of-leaflet-map
      # xmin: 10.8037 ymin: 44.06226 xmax: 11.84204 ymax: 44.80476
       setMaxBounds(10.8037-1,44.06226,11.84204+1,44.80476)  %>%
      addControl(title, position = "bottomright", className="map-title")
    
      # setMaxBounds(lng1 = 10, lat1 = 44, lng2 = 12, lat2 = 45)
      # setMaxBounds(lng1 = 11.31, lat1 = 44.44, lng2 = 11.31, lat2 = 44.44)
    
    
    # https://gis.stackexchange.com/questions/301839/how-to-create-independent-fixed-inset-maps-with-leaflet
    
    # https://gis.stackexchange.com/questions/231103/cutting-leaflet-map-in-r-to-a-specific-area
    # https://github.com/rstudio/leaflet/issues/486
    # https://www.r-bloggers.com/2019/12/quick-tips-for-customizing-your-r-leaflet-map/
    # https://rstudio.github.io/leaflet/articles/shiny.html
    # https://www.r-bloggers.com/2017/03/4-tricks-for-working-with-r-leaflet-and-shiny/
    
    # onRender
    # https://stackoverflow.com/questions/71013017/move-zoom-controls-in-leaflet-for-r-shiny
  })
  

  
  # clicked <- reactiveVal()
  
  
  observeEvent(input$mymap_shape_click, {
    
    click <- input$mymap_shape_click
    
    leafletProxy("mymap") %>% 
      setView(lng = comuni$lon_centroid[comuni$COMUNE == click$id], lat = comuni$lat_centroid[comuni$COMUNE == click$id], zoom = 10)
    # setView(lng = click$lng, lat = click$lat, zoom = 10)
    
    # clicked(input$mymap_shape_click)
    
  })
  
  # https://stackoverflow.com/questions/73314170/distinguish-between-inputmap-click-and-inputmap-shape-click-in-leaflet-r-shiny
  # https://stackoverflow.com/questions/76465586/click-on-a-polygon-of-a-leaflet-map-and-subset-the-same-dataset-which-is-display
  
  cases <- reactive({
    cases <- dtBO %>% 
      select(data, comune, codice_paziente, specie, razza, vet_icd_o_1_code) %>% 
      arrange(desc(data))
    cases
    
  })
  
  output$tab_home <- DT::renderDataTable({
    DT::datatable(
      cases(),
      rownames = FALSE,
      # style = 'bootstrap',
      class = "cell-border stripe compact",
      options = list(
        scrollX = TRUE)
      ) %>% 
      formatDate(c("data"), 'toLocaleDateString')
    
  })
  
  # p1----
  output$p1 <- renderPlotly({
    dtBO %>% 
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
    dtBO %>% 
      group_by(vet_icd_o_1_code) %>% 
      summarise(casi = n(), .groups = "drop") %>% 
      arrange(desc(casi)) %>% 
      head(5) %>% 
      plot_ly(x = ~casi, y = ~vet_icd_o_1_code, type = "bar", #color = ~vet_icd_o_1_code,
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)),
              text = ~casi, textfont = list(color = '#000'),
              textposition = 'outside') %>% 
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Top 5 tipi di tumore canino', x = 0.05),
        xaxis = list(title = "numero di casi"),
        yaxis = list(title = "", categoryorder = "total ascending"),
        showlegend = F) %>%
      config(displayModeBar = FALSE) %>% 
      style(hoverinfo = 'none')
    
  })
  
  # p3----
  output$p3 <- renderPlotly({
    dtBO %>%
      mutate(
        eta_anno = as.integer(str_extract(eta, "\\d+(?=a)")),
        eta_mese = as.integer(str_extract(eta, "\\d+(?=m)")),
        eta_classe = cut(eta_anno, 
                         breaks = seq(0, 20, by = 2), 
                         labels = paste0(seq(0, 18, by = 2), "-", seq(2, 20, by = 2), " yrs"),
                         include.lowest = T,
                         right = F)) %>%
      mutate(eta_classe = case_when(
        is.na(eta_classe) ~ "Unknown",
        TRUE ~ eta_classe)) %>% 
      mutate(eta_classe = ordered(eta_classe, levels = c("Unknown", "0-2 yrs", "2-4 yrs",
                                                         "4-6 yrs", "6-8 yrs", "8-10 yrs", "10-12 yrs",
                                                         "12-14 yrs", "14-16 yrs", "16-18 yrs", "18-20 yrs"))) %>%
      group_by(specie, eta_classe) %>% 
      summarise(n = n(), .groups = "drop") %>%
      filter(specie == "Cane") %>% 
      mutate(perc = n/sum(n)) %>% 
      plot_ly(x = ~eta_classe, y = ~perc, type = "bar", #color = ~eta_classe,
              marker = list(color = "#ABBDD7",
                            line = list(color = 'rgb(8,48,107)', width = 1)),
              text = ~perc, textfont = list(color = '#000'),
              texttemplate = '%{y:.0%}', 
              textposition = 'outside') %>% 
      layout(
        margin = list(b = 50, t = 50),
        title = list(text = 'Età media alla diagnosi', x = 0.05),
        xaxis = list(title = "", tickangle= -45),
        yaxis = list(title = "% di casi", tickformat = ".0%",
                     range = list(0, 0.51),
                     tick0 = 0,
                     dtick = 0.05),
        showlegend = F) %>%
      config(displayModeBar = FALSE) %>% 
      style(hoverinfo = 'none')
    
  })

  # p4----
  output$p4 <- renderPlotly({
    dtBO %>%
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
  #                  datatable(dtBO %>%
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
  
  
 
