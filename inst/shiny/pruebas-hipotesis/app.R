library(shiny)

ui <- fluidPage(
  titlePanel("Pruebas de Hipotesis - paqueteDEG"),
  tabsetPanel(
    tabPanel(
      "Pruebas",
      sidebarLayout(
        sidebarPanel(
          selectInput(
            "modo",
            "Funcion",
            choices = c(
              "resumen_num" = "desc_resumen",
              "test.mu" = "res_mu",
              "test.mus" = "res_mus",
              "test.var" = "res_var",
              "test.vars" = "res_vars",
              "prop.test (1 proporcion)" = "prop_1",
              "prop.test (2 proporciones)" = "prop_2",
              "power.plot" = "power_plot",
              "sizemu" = "n_mu",
              "sizep" = "n_p",
              "adjusted_size" = "n_adj"
            )
          ),
          uiOutput("funcion_info"),
          tags$hr(),
          uiOutput("parametros_ui"),
          actionButton("run", "Ejecutar prueba", class = "btn-primary")
        ),
        mainPanel(
          uiOutput("titulo_resultado"),
          verbatimTextOutput("resultado"),
          plotOutput("grafico_resumen", height = "420px"),
          tags$hr(),
          h5("Interpretacion rapida"),
          textOutput("decision"),
          tags$hr(),
          h5("Tablero de potencia"),
          tableOutput("tablero_potencia")
        )
      )
    ),
    tabPanel(
      "Explorador de potencia",
      sidebarLayout(
        sidebarPanel(
          selectInput("exp_tipo", "Tipo de prueba", choices = c("Una media", "Una proporcion")),
          selectInput("exp_alt", "Alternativa", choices = c("two.sided", "greater", "less")),
          numericInput("exp_alpha", "Alpha", value = 0.05, min = 0.001, max = 0.2, step = 0.001),
          numericInput("exp_beta", "Beta", value = 0.2, min = 0.01, max = 0.8, step = 0.01),
          conditionalPanel(
            condition = "input.exp_tipo == 'Una media'",
            numericInput("exp_delta_mu", "Diferencia minima detectable (delta)", value = 2, min = 0.0001),
            numericInput("exp_sd_mu", "Desviacion estandar (sd)", value = 8, min = 0.0001)
          ),
          conditionalPanel(
            condition = "input.exp_tipo == 'Una proporcion'",
            numericInput("exp_p1", "Proporcion esperada p1", value = 0.5, min = 0, max = 1, step = 0.01),
            numericInput("exp_p2", "Proporcion bajo H0 p2", value = 0.4, min = 0, max = 1, step = 0.01)
          )
        ),
        mainPanel(
          h4("Tablero experimental alpha-beta"),
          tableOutput("tablero_explorador"),
          plotOutput("grafico_explorador", height = "380px")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  alt_choices <- c("two.sided", "less", "greater")

  output$titulo_resultado <- renderUI({
    if (input$modo == "desc_resumen") {
      return(NULL)
    }
    h4("Resultado")
  })

  output$funcion_info <- renderUI({
    info <- switch(
      input$modo,
      desc_resumen = "Sintaxis: resumen_num(x, na.rm = TRUE, graficar = TRUE, grafico = c(\"histograma\", \"cajas\"), decimals = 2)",
      res_mu = "Sintaxis: test.mu(media, n, sd, mu0, alternative = c(\"two.sided\", \"less\", \"greater\"), conf.level = 0.95)",
      res_mus = "Sintaxis: test.mus(media1, n1, sd1, media2, n2, sd2, delta0 = 0, alternative = c(\"two.sided\", \"less\", \"greater\"), var.equal = FALSE, conf.level = 0.95)",
      res_var = "Sintaxis: test.var(sd, n, sigma20, alternative = c(\"two.sided\", \"less\", \"greater\"), conf.level = 0.95)",
      res_vars = "Sintaxis: test.vars(sd1, n1, sd2, n2, ratio0 = 1, alternative = c(\"two.sided\", \"less\", \"greater\"), conf.level = 0.95)",
      prop_1 = "Sintaxis: prop.test(x, n, p = 0.5, alternative = c(\"two.sided\", \"less\", \"greater\"), conf.level = 0.95, correct = TRUE)",
      prop_2 = "Sintaxis: prop.test(x = c(x1, x2), n = c(n1, n2), alternative = c(\"two.sided\", \"less\", \"greater\"), conf.level = 0.95, correct = TRUE)",
      power_plot = "Sintaxis: curva de potencia para una media (z) o una proporcion (z)",
      n_mu = "Sintaxis: sizemu(perc_normal, varianza, error)",
      n_p = "Sintaxis: sizep(perc_normal, prob, error)",
      n_adj = "Sintaxis: adjusted_size(samp_size, pob_size)"
    )
    tags$small(tags$em(info))
  })

  output$parametros_ui <- renderUI({
    switch(
      input$modo,
      desc_resumen = tagList(
        textAreaInput("x", "Datos x (separados por coma; usa NA para faltantes)", "12, 15, 18, NA, 22, 25, 30"),
        checkboxInput("na_rm", "Remover NA", value = TRUE),
        selectInput("grafico_desc", "Grafico", choices = c("histograma", "cajas")),
        numericInput("decimals", "Decimales", value = 2, min = 0, max = 10, step = 1)
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
      ),
      prop_1 = tagList(
        numericInput("x_prop", "Numero de exitos (x)", value = 45, min = 0, step = 1),
        numericInput("n_prop", "Tamano de muestra (n)", value = 100, min = 1, step = 1),
        numericInput("p0_prop", "Proporcion bajo H0 (p)", value = 0.5, min = 0, max = 1, step = 0.01),
        checkboxInput("correct_prop", "Correccion de continuidad", value = TRUE),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      prop_2 = tagList(
        numericInput("x1_prop", "Exitos grupo 1 (x1)", value = 56, min = 0, step = 1),
        numericInput("n1_prop", "n1", value = 120, min = 1, step = 1),
        numericInput("x2_prop", "Exitos grupo 2 (x2)", value = 42, min = 0, step = 1),
        numericInput("n2_prop", "n2", value = 110, min = 1, step = 1),
        checkboxInput("correct_prop", "Correccion de continuidad", value = TRUE),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("conf", "Nivel de confianza", value = 0.95, min = 0.5, max = 0.999, step = 0.01)
      ),
      power_plot = tagList(
        selectInput("power_tipo", "Tipo", choices = c("Una media", "Una proporcion")),
        selectInput("alt", "Alternativa", alt_choices),
        numericInput("alpha_power", "Alpha", value = 0.05, min = 0.001, max = 0.2, step = 0.001),
        conditionalPanel(
          condition = "input.power_tipo == 'Una media'",
          numericInput("mu0_power", "Mu0", value = 50),
          numericInput("sd_power", "Desviacion estandar (sigma)", value = 8, min = 0.0001),
          numericInput("n_power", "n", value = 36, min = 2, step = 1),
          numericInput("mu_min", "Rango mu: minimo", value = 40),
          numericInput("mu_max", "Rango mu: maximo", value = 60)
        ),
        conditionalPanel(
          condition = "input.power_tipo == 'Una proporcion'",
          numericInput("p0_power", "p0", value = 0.5, min = 0, max = 1, step = 0.01),
          numericInput("n_power_p", "n", value = 100, min = 2, step = 1),
          numericInput("p_min", "Rango p: minimo", value = 0.2, min = 0, max = 1, step = 0.01),
          numericInput("p_max", "Rango p: maximo", value = 0.8, min = 0, max = 1, step = 0.01)
        )
      ),
      n_mu = tagList(
        numericInput("perc_normal", "Percentil normal (ej: 1.96)", value = 1.96, min = 0.0001),
        numericInput("varianza", "Varianza estimada", value = 428, min = 0.0001),
        numericInput("error", "Error maximo permitido", value = 2, min = 0.0001)
      ),
      n_p = tagList(
        numericInput("perc_normal", "Percentil normal (ej: 1.96)", value = 1.96, min = 0.0001),
        numericInput("prob", "Proporcion estimada", value = 0.5, min = 0, max = 1, step = 0.01),
        numericInput("error", "Error maximo permitido", value = 0.05, min = 0.0001)
      ),
      n_adj = tagList(
        numericInput("samp_size", "Tamano de muestra inicial", value = 385, min = 0.0001),
        numericInput("pob_size", "Tamano de la poblacion", value = 1000, min = 0.0001)
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
        desc_resumen = {
          x <- parse_vec(input$x)
          validate(need(length(x) >= 2, "x debe tener al menos 2 observaciones."))
          paqueteDEG::resumen_num(
            x = x,
            na.rm = isTRUE(input$na_rm),
            graficar = FALSE,
            grafico = input$grafico_desc,
            decimals = as.integer(input$decimals)
          )
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
        },
        prop_1 = {
          stats::prop.test(
            x = as.integer(input$x_prop),
            n = as.integer(input$n_prop),
            p = input$p0_prop,
            alternative = input$alt,
            conf.level = input$conf,
            correct = isTRUE(input$correct_prop)
          )
        },
        prop_2 = {
          stats::prop.test(
            x = c(as.integer(input$x1_prop), as.integer(input$x2_prop)),
            n = c(as.integer(input$n1_prop), as.integer(input$n2_prop)),
            alternative = input$alt,
            conf.level = input$conf,
            correct = isTRUE(input$correct_prop)
          )
        },
        power_plot = {
          list(ok = TRUE)
        },
        n_mu = {
          paqueteDEG::sizemu(
            perc_normal = input$perc_normal,
            varianza = input$varianza,
            error = input$error
          )
        },
        n_p = {
          paqueteDEG::sizep(
            perc_normal = input$perc_normal,
            prob = input$prob,
            error = input$error
          )
        },
        n_adj = {
          paqueteDEG::adjusted_size(
            samp_size = input$samp_size,
            pob_size = input$pob_size
          )
        }
      )
    }, error = function(e) {
      structure(list(error = conditionMessage(e)), class = "app_error")
    })
  })

  output$resultado <- renderPrint({
    if (input$modo == "desc_resumen") {
      return(invisible(NULL))
    }
    res <- resultado()
    if (inherits(res, "app_error")) {
      cat("Error:\n", res$error, "\n")
    } else {
      print(res)
    }
  })

  output$grafico_resumen <- renderPlot({
    req(input$modo %in% c("desc_resumen", "power_plot"))
    req(input$run > 0)
    if (input$modo == "desc_resumen") {
      x <- parse_vec(input$x)
      validate(need(length(x) >= 2, "x debe tener al menos 2 observaciones."))
      paqueteDEG::resumen_num(
        x = x,
        na.rm = isTRUE(input$na_rm),
        graficar = TRUE,
        grafico = input$grafico_desc,
        decimals = as.integer(input$decimals)
      )
    } else {
      alpha <- input$alpha_power
      alt <- input$alt
      if (input$power_tipo == "Una media") {
        validate(need(input$mu_min < input$mu_max, "El rango de mu debe ser valido."))
        mu_seq <- seq(input$mu_min, input$mu_max, length.out = 200)
        se <- input$sd_power / sqrt(as.integer(input$n_power))
        z <- stats::qnorm
        power_vals <- vapply(mu_seq, function(mu1) {
          if (alt == "two.sided") {
            zc <- z(1 - alpha / 2)
            1 - (stats::pnorm(zc - (mu1 - input$mu0_power) / se) -
              stats::pnorm(-zc - (mu1 - input$mu0_power) / se))
          } else if (alt == "greater") {
            zc <- z(1 - alpha)
            stats::pnorm((mu1 - input$mu0_power) / se - zc)
          } else {
            zc <- z(alpha)
            stats::pnorm(zc - (mu1 - input$mu0_power) / se)
          }
        }, numeric(1))
        plot(mu_seq, power_vals, type = "l", lwd = 2, col = "steelblue",
             xlab = expression(mu[1]), ylab = "Potencia",
             main = "Curva de potencia (una media)")
      } else {
        validate(need(input$p_min < input$p_max, "El rango de p debe ser valido."))
        p_seq <- seq(input$p_min, input$p_max, length.out = 200)
        n <- as.integer(input$n_power_p)
        p0 <- input$p0_power
        se0 <- sqrt(p0 * (1 - p0) / n)
        z <- stats::qnorm
        power_vals <- vapply(p_seq, function(p1) {
          se1 <- sqrt(p1 * (1 - p1) / n)
          if (alt == "two.sided") {
            zc <- z(1 - alpha / 2)
            pu <- stats::pnorm((p0 + zc * se0 - p1) / se1)
            pl <- stats::pnorm((p0 - zc * se0 - p1) / se1)
            1 - (pu - pl)
          } else if (alt == "greater") {
            zc <- z(1 - alpha)
            1 - stats::pnorm((p0 + zc * se0 - p1) / se1)
          } else {
            zc <- z(alpha)
            stats::pnorm((p0 + zc * se0 - p1) / se1)
          }
        }, numeric(1))
        plot(p_seq, power_vals, type = "l", lwd = 2, col = "darkgreen",
             xlab = expression(p[1]), ylab = "Potencia",
             main = "Curva de potencia (una proporcion)")
      }
      abline(h = 0.8, lty = 2, col = "gray40")
      abline(v = if (input$power_tipo == "Una media") input$mu0_power else input$p0_power, lty = 3, col = "gray40")
    }
  })

  output$decision <- renderText({
    res <- resultado()
    if (inherits(res, "app_error")) {
      return("Corrige los parametros y vuelve a ejecutar.")
    }
    if (input$modo == "desc_resumen") {
      return("Resumen descriptivo generado correctamente.")
    }
    if (input$modo == "power_plot") {
      return("Curva de potencia generada.")
    }
    if (input$modo %in% c("n_mu", "n_p", "n_adj")) {
      return(paste("Resultado calculado:", round(as.numeric(res), 4)))
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

  output$tablero_potencia <- renderTable({
    req(input$run > 0)
    alt_power <- if (input$alt == "two.sided") "two.sided" else "one.sided"

    make_row <- function(potencia, alpha, metodo, detalle) {
      data.frame(
        potencia = if (is.na(potencia)) NA_real_ else round(potencia, 4),
        beta = if (is.na(potencia)) NA_real_ else round(1 - potencia, 4),
        alpha = round(alpha, 4),
        metodo = metodo,
        detalle = detalle,
        stringsAsFactors = FALSE
      )
    }

    if (input$modo == "res_mu") {
      pwr <- stats::power.t.test(
        n = as.integer(input$n),
        delta = abs(input$media - input$mu),
        sd = input$sd,
        sig.level = 1 - input$conf,
        type = "one.sample",
        alternative = alt_power
      )$power
      return(make_row(pwr, 1 - input$conf, "power.t.test", "Una media"))
    }

    if (input$modo == "res_mus") {
      pwr <- stats::power.t.test(
        n = min(as.integer(input$n1), as.integer(input$n2)),
        delta = abs((input$media1 - input$media2) - input$mu),
        sd = mean(c(input$sd1, input$sd2)),
        sig.level = 1 - input$conf,
        type = "two.sample",
        alternative = alt_power
      )$power
      return(make_row(pwr, 1 - input$conf, "power.t.test", "Dos medias (aprox.)"))
    }

    if (input$modo == "prop_1") {
      p_obs <- as.integer(input$x_prop) / as.integer(input$n_prop)
      pwr <- stats::power.prop.test(
        n = as.integer(input$n_prop),
        p1 = p_obs,
        p2 = input$p0_prop,
        sig.level = 1 - input$conf,
        alternative = alt_power
      )$power
      return(make_row(pwr, 1 - input$conf, "power.prop.test", "Una proporcion"))
    }

    if (input$modo == "prop_2") {
      p1 <- as.integer(input$x1_prop) / as.integer(input$n1_prop)
      p2 <- as.integer(input$x2_prop) / as.integer(input$n2_prop)
      pwr <- stats::power.prop.test(
        n = min(as.integer(input$n1_prop), as.integer(input$n2_prop)),
        p1 = p1,
        p2 = p2,
        sig.level = 1 - input$conf,
        alternative = alt_power
      )$power
      return(make_row(pwr, 1 - input$conf, "power.prop.test", "Dos proporciones (aprox.)"))
    }

    if (input$modo %in% c("res_var", "res_vars")) {
      return(data.frame(
        potencia = NA_real_,
        beta = NA_real_,
        alpha = round(1 - input$conf, 4),
        metodo = "No disponible",
        detalle = "Potencia no implementada para pruebas de varianza en esta app",
        stringsAsFactors = FALSE
      ))
    }

    data.frame(
      potencia = NA_real_,
      beta = NA_real_,
      alpha = NA_real_,
      metodo = "No aplica",
      detalle = "Este modo no ejecuta una prueba de hipotesis con potencia asociada",
      stringsAsFactors = FALSE
    )
  })

  output$tablero_explorador <- renderTable({
    alpha <- input$exp_alpha
    beta <- input$exp_beta
    validate(need(alpha > 0 && alpha < 1, "Alpha debe estar entre 0 y 1."))
    validate(need(beta > 0 && beta < 1, "Beta debe estar entre 0 y 1."))
    power_target <- 1 - beta
    alt_power <- if (input$exp_alt == "two.sided") "two.sided" else "one.sided"

    if (input$exp_tipo == "Una media") {
      validate(need(input$exp_delta_mu > 0, "Delta debe ser positivo."))
      validate(need(input$exp_sd_mu > 0, "sd debe ser positiva."))
      calc <- stats::power.t.test(
        delta = input$exp_delta_mu,
        sd = input$exp_sd_mu,
        sig.level = alpha,
        power = power_target,
        type = "one.sample",
        alternative = alt_power
      )
      return(data.frame(
        tipo = "Una media",
        alpha = round(alpha, 4),
        beta = round(beta, 4),
        potencia_objetivo = round(power_target, 4),
        n_requerido = ceiling(calc$n),
        metodo = "power.t.test",
        stringsAsFactors = FALSE
      ))
    }

    validate(need(input$exp_p1 > 0 && input$exp_p1 < 1, "p1 debe estar entre 0 y 1."))
    validate(need(input$exp_p2 > 0 && input$exp_p2 < 1, "p2 debe estar entre 0 y 1."))
    validate(need(input$exp_p1 != input$exp_p2, "p1 y p2 deben ser distintos."))
    calc <- stats::power.prop.test(
      p1 = input$exp_p1,
      p2 = input$exp_p2,
      sig.level = alpha,
      power = power_target,
      alternative = alt_power
    )
    data.frame(
      tipo = "Una proporcion",
      alpha = round(alpha, 4),
      beta = round(beta, 4),
      potencia_objetivo = round(power_target, 4),
      n_requerido = ceiling(calc$n),
      metodo = "power.prop.test",
      stringsAsFactors = FALSE
    )
  })

  output$grafico_explorador <- renderPlot({
    beta <- input$exp_beta
    alpha <- input$exp_alpha
    validate(need(beta > 0 && beta < 1, "Beta debe estar entre 0 y 1."))
    validate(need(alpha > 0 && alpha < 1, "Alpha debe estar entre 0 y 1."))
    power_target <- 1 - beta
    alt_power <- if (input$exp_alt == "two.sided") "two.sided" else "one.sided"

    shade_area <- function(x, y, idx, col) {
      if (!any(idx)) return(invisible(NULL))
      runs <- rle(idx)
      ends <- cumsum(runs$lengths)
      starts <- ends - runs$lengths + 1
      keep <- which(runs$values)
      for (k in keep) {
        i1 <- starts[k]
        i2 <- ends[k]
        xx <- x[i1:i2]
        yy <- y[i1:i2]
        polygon(c(xx[1], xx, xx[length(xx)]), c(0, yy, 0), col = col, border = NA)
      }
    }

    if (input$exp_tipo == "Una media") {
      validate(need(input$exp_delta_mu > 0, "Delta debe ser positivo."))
      validate(need(input$exp_sd_mu > 0, "sd debe ser positiva."))
      n_req <- ceiling(stats::power.t.test(
        delta = input$exp_delta_mu,
        sd = input$exp_sd_mu,
        sig.level = alpha,
        power = power_target,
        type = "one.sample",
        alternative = alt_power
      )$n)
      se <- input$exp_sd_mu / sqrt(n_req)
      mu0 <- 0
      mu1 <- if (input$exp_alt == "less") -abs(input$exp_delta_mu) else abs(input$exp_delta_mu)

      x_min <- min(mu0, mu1) - 4.5 * se
      x_max <- max(mu0, mu1) + 4.5 * se
      x <- seq(x_min, x_max, length.out = 1500)
      f0 <- stats::dnorm(x, mean = mu0, sd = se)
      f1 <- stats::dnorm(x, mean = mu1, sd = se)

      if (input$exp_alt == "two.sided") {
        two_sided <- TRUE
        c1 <- stats::qnorm(alpha / 2, mean = mu0, sd = se)
        c2 <- stats::qnorm(1 - alpha / 2, mean = mu0, sd = se)
        idx_alpha <- (x <= c1) | (x >= c2)
        idx_beta <- (x > c1) & (x < c2)
        idx_power <- !idx_beta
        alt_lbl <- "two.sided"
      } else if (input$exp_alt == "greater") {
        two_sided <- FALSE
        c2 <- stats::qnorm(1 - alpha, mean = mu0, sd = se)
        idx_alpha <- x >= c2
        idx_beta <- x < c2
        idx_power <- !idx_beta
        alt_lbl <- "greater (cola derecha)"
      } else {
        two_sided <- FALSE
        c2 <- stats::qnorm(alpha, mean = mu0, sd = se)
        idx_alpha <- x <= c2
        idx_beta <- x > c2
        idx_power <- !idx_beta
        alt_lbl <- "less (cola izquierda)"
      }

      plot(x, f0, type = "l", lwd = 2, col = "black",
           xlab = "Estadistico de prueba", ylab = "Densidad",
           main = paste("H0 vs H1 |", alt_lbl, "| n =", n_req))
      lines(x, f1, lwd = 2, col = "red")
      shade_area(x, f0, idx_alpha, rgb(70, 130, 180, 110, maxColorValue = 255))
      shade_area(x, f1, idx_beta, rgb(255, 140, 0, 110, maxColorValue = 255))
      shade_area(x, f1, idx_power, rgb(34, 139, 34, 90, maxColorValue = 255))
      abline(v = if (two_sided) c(c1, c2) else c2, lty = 2, col = "gray40")
      legend("topright",
             legend = c("H0", "H1 (roja)", "alpha", "beta", "potencia"),
             col = c("black", "red", rgb(70, 130, 180, 180, maxColorValue = 255),
                     rgb(255, 140, 0, 180, maxColorValue = 255),
                     rgb(34, 139, 34, 180, maxColorValue = 255)),
             lwd = c(2, 2, 8, 8, 8), bty = "n")
    } else {
      validate(need(input$exp_p1 > 0 && input$exp_p1 < 1, "p1 debe estar entre 0 y 1."))
      validate(need(input$exp_p2 > 0 && input$exp_p2 < 1, "p2 debe estar entre 0 y 1."))
      validate(need(input$exp_p1 != input$exp_p2, "p1 y p2 deben ser distintos."))
      n_req <- ceiling(stats::power.prop.test(
        p1 = input$exp_p1,
        p2 = input$exp_p2,
        sig.level = alpha,
        power = power_target,
        alternative = alt_power
      )$n)
      p0 <- input$exp_p2
      p1 <- input$exp_p1
      se0 <- sqrt(p0 * (1 - p0) / n_req)
      se1 <- sqrt(p1 * (1 - p1) / n_req)

      x_min <- min(p0, p1) - 4.5 * max(se0, se1)
      x_max <- max(p0, p1) + 4.5 * max(se0, se1)
      x <- seq(max(0, x_min), min(1, x_max), length.out = 1500)
      f0 <- stats::dnorm(x, mean = p0, sd = se0)
      f1 <- stats::dnorm(x, mean = p1, sd = se1)

      if (input$exp_alt == "two.sided") {
        two_sided <- TRUE
        c1 <- stats::qnorm(alpha / 2, mean = p0, sd = se0)
        c2 <- stats::qnorm(1 - alpha / 2, mean = p0, sd = se0)
        idx_alpha <- (x <= c1) | (x >= c2)
        idx_beta <- (x > c1) & (x < c2)
        idx_power <- !idx_beta
        alt_lbl <- "two.sided"
      } else if (input$exp_alt == "greater") {
        two_sided <- FALSE
        c2 <- stats::qnorm(1 - alpha, mean = p0, sd = se0)
        idx_alpha <- x >= c2
        idx_beta <- x < c2
        idx_power <- !idx_beta
        alt_lbl <- "greater (cola derecha)"
      } else {
        two_sided <- FALSE
        c2 <- stats::qnorm(alpha, mean = p0, sd = se0)
        idx_alpha <- x <= c2
        idx_beta <- x > c2
        idx_power <- !idx_beta
        alt_lbl <- "less (cola izquierda)"
      }

      plot(x, f0, type = "l", lwd = 2, col = "black",
           xlab = "Proporcion muestral", ylab = "Densidad",
           main = paste("H0 vs H1 |", alt_lbl, "| n =", n_req))
      lines(x, f1, lwd = 2, col = "red")
      shade_area(x, f0, idx_alpha, rgb(70, 130, 180, 110, maxColorValue = 255))
      shade_area(x, f1, idx_beta, rgb(255, 140, 0, 110, maxColorValue = 255))
      shade_area(x, f1, idx_power, rgb(34, 139, 34, 90, maxColorValue = 255))
      abline(v = if (two_sided) c(c1, c2) else c2, lty = 2, col = "gray40")
      legend("topright",
             legend = c("H0", "H1 (roja)", "alpha", "beta", "potencia"),
             col = c("black", "red", rgb(70, 130, 180, 180, maxColorValue = 255),
                     rgb(255, 140, 0, 180, maxColorValue = 255),
                     rgb(34, 139, 34, 180, maxColorValue = 255)),
             lwd = c(2, 2, 8, 8, 8), bty = "n")
    }
  })
}

shinyApp(ui, server)
