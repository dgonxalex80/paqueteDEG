library(shiny)

ui <- fluidPage(
  titlePanel("Pruebas de Hipotesis - paqueteDEG"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "modo",
        "Tipo de prueba",
        choices = c(
          "Tradicional: una media (t.test)" = "trad_mu",
          "Tradicional: dos medias (t.test)" = "trad_mus",
          "Tradicional: dos varianzas (var.test)" = "trad_vars",
          "Resumida: una media (test.mu)" = "res_mu",
          "Resumida: dos medias (test.mus)" = "res_mus",
          "Resumida: una varianza (test.var)" = "res_var",
          "Resumida: razon de varianzas (test.vars)" = "res_vars"
        )
      ),
      tags$hr(),
      uiOutput("parametros_ui"),
      actionButton("run", "Ejecutar prueba", class = "btn-primary")
    ),
    mainPanel(
      h4("Resultado"),
      verbatimTextOutput("resultado"),
      tags$hr(),
      h5("Interpretacion rapida"),
      textOutput("decision")
    )
  )
)

server <- function(input, output, session) {
  alt_choices <- c("two.sided", "less", "greater")

  output$parametros_ui <- renderUI({
    switch(
      input$modo,
      trad_mu = tagList(
        textAreaInput("x", "Datos x (separados por coma)", "12, 15, 13, 11, 14"),
        numericInput("mu", "Media bajo H0", value = 0),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      trad_mus = tagList(
        textAreaInput("x", "Datos x (separados por coma)", "80, 76, 82, 79, 81"),
        textAreaInput("y", "Datos y (separados por coma)", "72, 75, 70, 73, 74"),
        numericInput("mu", "Diferencia bajo H0", value = 0),
        checkboxInput("var_equal", "Asumir varianzas iguales", value = FALSE),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      trad_vars = tagList(
        textAreaInput("x", "Datos x (separados por coma)", "14, 16, 13, 15, 17"),
        textAreaInput("y", "Datos y (separados por coma)", "9, 11, 10, 12, 8"),
        numericInput("ratio", "Razon bajo H0 (var(x)/var(y))", value = 1, min = 0.0001),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      res_mu = tagList(
        numericInput("media", "Media muestral", value = 52),
        numericInput("n", "n", value = 36, min = 2, step = 1),
        numericInput("sd", "Desviacion estandar", value = 8, min = 0.0001),
        numericInput("mu", "Media bajo H0", value = 50),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      res_mus = tagList(
        numericInput("media1", "Media grupo 1", value = 80),
        numericInput("n1", "n1", value = 25, min = 2, step = 1),
        numericInput("sd1", "Desviacion grupo 1", value = 10, min = 0.0001),
        numericInput("media2", "Media grupo 2", value = 74),
        numericInput("n2", "n2", value = 22, min = 2, step = 1),
        numericInput("sd2", "Desviacion grupo 2", value = 12, min = 0.0001),
        numericInput("mu", "Diferencia bajo H0", value = 0),
        checkboxInput("var_equal", "Asumir varianzas iguales", value = FALSE),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      res_var = tagList(
        numericInput("sd", "Desviacion estandar", value = 12, min = 0.0001),
        numericInput("n", "n", value = 30, min = 2, step = 1),
        numericInput("sigma20", "Varianza bajo H0", value = 100, min = 0.0001),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      res_vars = tagList(
        numericInput("sd1", "Desviacion grupo 1", value = 15, min = 0.0001),
        numericInput("n1", "n1", value = 20, min = 2, step = 1),
        numericInput("sd2", "Desviacion grupo 2", value = 10, min = 0.0001),
        numericInput("n2", "n2", value = 18, min = 2, step = 1),
        numericInput("ratio", "Razon bajo H0 (var1/var2)", value = 1, min = 0.0001),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      )
    )
  })

  parse_vec <- function(txt) {
    vals <- trimws(unlist(strsplit(txt, ",", fixed = TRUE)))
    vals <- vals[nzchar(vals)]
    as.numeric(vals)
  }

  resultado <- eventReactive(input$run, {
    tryCatch({
      switch(
        input$modo,
        trad_mu = {
          x <- parse_vec(input$x)
          validate(need(length(x) >= 2 && all(is.finite(x)), "x debe tener al menos 2 numeros validos."))
          stats::t.test(x, mu = input$mu, alternative = input$alt, conf.level = input$conf)
        },
        trad_mus = {
          x <- parse_vec(input$x)
          y <- parse_vec(input$y)
          validate(need(length(x) >= 2 && all(is.finite(x)), "x debe tener al menos 2 numeros validos."))
          validate(need(length(y) >= 2 && all(is.finite(y)), "y debe tener al menos 2 numeros validos."))
          stats::t.test(
            x, y,
            mu = input$mu,
            var.equal = isTRUE(input$var_equal),
            alternative = input$alt,
            conf.level = input$conf
          )
        },
        trad_vars = {
          x <- parse_vec(input$x)
          y <- parse_vec(input$y)
          validate(need(length(x) >= 2 && all(is.finite(x)), "x debe tener al menos 2 numeros validos."))
          validate(need(length(y) >= 2 && all(is.finite(y)), "y debe tener al menos 2 numeros validos."))
          stats::var.test(x, y, ratio = input$ratio, alternative = input$alt, conf.level = input$conf)
        },
        res_mu = {
          paqueteDEG::test.mu(
            media = input$media,
            n = as.integer(input$n),
            sd = input$sd,
            mu0 = input$mu,
            alternative = input$alt,
            conf.level = input$conf
          )
        },
        res_mus = {
          paqueteDEG::test.mus(
            media1 = input$media1,
            n1 = as.integer(input$n1),
            sd1 = input$sd1,
            media2 = input$media2,
            n2 = as.integer(input$n2),
            sd2 = input$sd2,
            delta0 = input$mu,
            var.equal = isTRUE(input$var_equal),
            alternative = input$alt,
            conf.level = input$conf
          )
        },
        res_var = {
          paqueteDEG::test.var(
            sd = input$sd,
            n = as.integer(input$n),
            sigma20 = input$sigma20,
            alternative = input$alt,
            conf.level = input$conf
          )
        },
        res_vars = {
          paqueteDEG::test.vars(
            sd1 = input$sd1,
            n1 = as.integer(input$n1),
            sd2 = input$sd2,
            n2 = as.integer(input$n2),
            ratio0 = input$ratio,
            alternative = input$alt,
            conf.level = input$conf
          )
        }
      )
    }, error = function(e) {
      structure(list(error = conditionMessage(e)), class = "app_error")
    })
  })

  output$resultado <- renderPrint({
    res <- resultado()
    if (inherits(res, "app_error")) {
      cat("Error:\n", res$error, "\n")
    } else {
      print(res)
    }
  })

  output$decision <- renderText({
    res <- resultado()
    if (inherits(res, "app_error")) {
      return("Corrige los parametros y vuelve a ejecutar.")
    }
    if (is.null(res$p.value) || !is.finite(res$p.value)) {
      return("No se pudo calcular p-value.")
    }
    if (res$p.value < 0.05) {
      "Con alpha = 0.05: se rechaza H0."
    } else {
      "Con alpha = 0.05: no se rechaza H0."
    }
  })
}

shinyApp(ui, server)
