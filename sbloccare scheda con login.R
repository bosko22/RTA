# https://stackoverflow.com/questions/69013924/launch-shinymanager-authentification-after-click-on-button-in-the-first-tab-then

library(shiny)
library(shinymanager)
library(shinydashboard)
library(shinyWidgets)
library(shinythemes)
library(callr)

secured_ui <- secure_app(fluidPage(uiOutput("iframecontent")), fab_position = "none")

secured_server <- function(input, output, session) {
  credentials <- data.frame(
    user = c("admin", "user1", "user2"),
    password = c("admin", "user1", "user2"),
    admin = c(TRUE, FALSE, FALSE),
    permission = c("advanced", "basic", "basic"),
    job = c("CEO", "CTO", "DRH"),
    stringsAsFactors = FALSE)
  
  res_auth <- shinymanager::secure_server(
    check_credentials = shinymanager::check_credentials(credentials)
  )
  
  output$iframecontent <- renderUI({
    currentQueryString <- getQueryString(session)$tab # alternative: parseQueryString(session$clientData$url_search)$tab
    if (is.null(currentQueryString)){
      return(div(h2("There is nothing here", style = "color: red;")))
    } else {
      req(currentQueryString, cancelOutput = TRUE)
      req(res_auth$permission, cancelOutput = TRUE)
      fluidPage(
        if(!is.null(currentQueryString) && currentQueryString == "tab1" && res_auth$permission %in% c("basic", "advanced")){
          div(h2("First tab content here"))
        } else if (!is.null(currentQueryString) && currentQueryString == "tab2" && res_auth$permission == "advanced"){
          div(h2("Second tab content here"))
        } else {
          div(h2("Access not permitted", style = "color: red;"))
        }, theme = shinythemes::shinytheme("cosmo")
      )
    }
  })
}

secured_child_app <- shinyApp(secured_ui, secured_server)

# run secured_child_app in a background R process - not needed when e.g. hosted on shinyapps.io
secured_child_app_process <- callr::r_bg(
  func = function(app) {
    shiny::runApp(
      appDir = app,
      port = 3838L,
      launch.browser = FALSE,
      host = "127.0.0.1" # secured_child_app is accessible only locally (or via the iframe)
    )
  },
  args = list(secured_child_app),
  stdout = "|",
  stderr = "2>&1",
  supervise = TRUE
)

print("Waiting for secured child app to get ready...")
while(!any(grepl("Listening on http", secured_child_app_process$read_output_lines()))){
  Sys.sleep(0.5)
}

public_ui <- navbarPage(id="navbarid",
                        "Secured Tabs Test",
                        theme = shinytheme("cosmo"),
                        header = tagList(useShinydashboard()),
                        tabPanel(
                          "Welcome", h2("Public content here")
                        ),
                        tabPanel("Tab1",
                                 tags$iframe(
                                   src = "http://127.0.0.1:3838/?tab=tab1",
                                   style = "border: none;
                              overflow: hidden;
                              height: calc(100vh - 100px);
                              width : 100vw;
                              position: relative;
                              top:0px;
                              padding:0px;"
                                 )),
                        tabPanel("Tab2", tags$iframe(
                          src = "http://127.0.0.1:3838/?tab=tab2",
                          style = "border: none;
                              overflow: hidden;
                              height: calc(100vh - 100px);
                              width : 100vw;
                              position: relative;
                              top:0px;
                              padding:0px;"
                        ))
)

public_server <- function(input, output, session) {}

public_parent_app <- shinyApp(public_ui, public_server, onStart = function() {
  cat("Doing application setup\n")
  onStop(function() {
    cat("Doing application cleanup\n")
    secured_child_app_process$kill() # kill secured_child_app if public_parent_app is exited - not needed when hosted separately
  })
})

# run public_parent_app
runApp(appDir = public_parent_app,
       port = 3939L,
       launch.browser = TRUE,
       host = "0.0.0.0")