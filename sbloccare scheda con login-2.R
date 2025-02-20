# app.R
library(shiny)
library(shinymanager)
library(shinyjs)

# Credenziali di esempio
credentials <- data.frame(
  user = c("user1", "user2"),
  password = c("pass1", "pass2"),
  stringsAsFactors = FALSE
)

# UI principale
ui_main <- fluidPage(
  useShinyjs(),
  
  tags$head(
    tags$style(HTML("
      .hidden {
        display: none;
      }
    "))
  ),
  
  titlePanel("App con Login su Richiesta"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("show_login", "Effettua Login"),
      uiOutput("login_status")
    ),
    
    mainPanel(
      tabsetPanel(id = "tabs",
                  tabPanel("Tab Pubblico",
                           h3("Questo contenuto è visibile a tutti")
                  ),
                  tabPanel("Tab Protetto",
                           div(id = "protected_content", class = "hidden",
                               h3("Contenuto Protetto"),
                               p("Questo contenuto è visibile solo dopo il login")
                           )
                  )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  # Variabile per tracciare lo stato del login
  auth_status <- reactiveVal(FALSE)
  
  # Gestione del bottone di login
  observeEvent(input$show_login, {
    showModal(modalDialog(
      title = "Login",
      footer = NULL,
      easyClose = FALSE,
      
      div(
        style = "width: 300px;",
        textInput("user", "Username"),
        passwordInput("password", "Password"),
        actionButton("login_submit", "Login", class = "btn-primary"),
        actionButton("login_cancel", "Annulla", class = "btn-default")
      )
    ))
  })
  
  # Gestione del submit del login
  observeEvent(input$login_submit, {
    user_input <- input$user
    pass_input <- input$password
    
    # Verifica le credenziali
    is_valid <- any(credentials$user == user_input & credentials$password == pass_input)
    
    if (is_valid) {
      auth_status(TRUE)
      removeModal()
      shinyjs::removeClass(selector = "#protected_content", class = "hidden")
    } else {
      showNotification("Credenziali non valide", type = "error")
    }
  })
  
  # Gestione del pulsante annulla
  observeEvent(input$login_cancel, {
    removeModal()
  })
  
  # Mostra lo stato del login
  output$login_status <- renderUI({
    if (auth_status()) {
      div(
        style = "color: green; margin-top: 15px;",
        "Utente autenticato"
      )
    } else {
      div(
        style = "color: red; margin-top: 15px;",
        "Utente non autenticato"
      )
    }
  })
}

# Avvia l'app
shinyApp(ui_main, server)