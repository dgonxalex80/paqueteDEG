#' @title Simulacion del Teorema Central del Limite
#' @description
#' Genera muestras aleatorias y calcula las medias muestrales para distintos
#' tamanos de muestra, con el fin de visualizar el Teorema Central del Limite.
#'
#' El argumento `generador` puede pasarse de dos formas:
#' 1. Como llamada: `rexp(m, 1)` o `runif(m, 10, 50)`.
#' 2. Como nombre de funcion: `rexp` o `runif` y sus parametros en `...`.
#'
#' @param generador funcion o llamada para generar aleatorios.
#' @param n numero maximo de columnas (tamano maximo de muestra).
#' @param replicas numero de replicas (numero de filas de la matriz).
#' @param tamanos vector con tamanos de muestra para calcular medias.
#' @param tipo_grafico tipo de grafico: `"densidad"`, `"histograma"` o `"qqplot"`.
#' @param mostrar si `TRUE`, dibuja los graficos.
#' @param par_original si `TRUE`, usa la configuracion de `par()` del codigo
#'   original: `cex=.5`, `cex.axis=.5`, `cex.lab=.5`, `cex.main=.5`,
#'   `cex.sub=.5`, `mfrow=c(3,2)`, `mai=c(.5,.5,.5,.5)`.
#' @param ... parametros adicionales para el generador cuando se pasa como nombre
#'   de funcion (por ejemplo, `rate = 1` en `rexp`).
#' @return Una lista con:
#' \describe{
#'   \item{X}{matriz de datos simulados}
#'   \item{muestras}{lista con `X1` y las medias muestrales por tamano}
#'   \item{densidades}{lista de densidades empiricas}
#' }
#' @examples
#' out1 <- simula_tcl(rexp(m, 1), n = 200, replicas = 200, mostrar = FALSE)
#' out2 <- simula_tcl(runif(m, 10, 50), n = 200, replicas = 200, mostrar = FALSE)
#' out3 <- simula_tcl(rexp, n = 200, replicas = 200, rate = 1, mostrar = FALSE)
#' @export
simula_tcl <- function(generador,
                       n = 1000,
                       replicas = 1000,
                       tamanos = c(2, 30, 50, 100, 1000),
                       tipo_grafico = c("densidad", "histograma", "qqplot"),
                       mostrar = TRUE,
                       par_original = TRUE,
                       ...) {
  tipo_grafico <- match.arg(tipo_grafico)

  if (!is.numeric(n) || length(n) != 1 || n < 1) {
    stop("`n` debe ser numerico y mayor o igual a 1.", call. = FALSE)
  }
  if (!is.numeric(replicas) || length(replicas) != 1 || replicas < 1) {
    stop("`replicas` debe ser numerico y mayor o igual a 1.", call. = FALSE)
  }

  n <- as.integer(n)
  replicas <- as.integer(replicas)

  tamanos <- unique(as.integer(tamanos))
  tamanos <- tamanos[tamanos >= 2 & tamanos <= n]
  if (length(tamanos) == 0) {
    stop("`tamanos` debe incluir al menos un valor entre 2 y `n`.", call. = FALSE)
  }

  m_total <- n * replicas
  generador_expr <- substitute(generador)

  if (is.symbol(generador_expr)) {
    fun <- get(as.character(generador_expr), mode = "function")
    valores <- do.call(fun, c(list(m_total), list(...)))
  } else if (is.call(generador_expr)) {
    generador_expr[[2]] <- m_total
    valores <- eval(generador_expr, envir = parent.frame())
  } else if (is.function(generador)) {
    valores <- do.call(generador, c(list(m_total), list(...)))
  } else {
    stop("`generador` debe ser una funcion o una llamada tipo rexp(m, 1).",
         call. = FALSE)
  }

  if (!is.numeric(valores) || length(valores) != m_total) {
    stop("El generador debe retornar un vector numerico de longitud n * replicas.",
         call. = FALSE)
  }

  X <- matrix(valores, ncol = n)
  X1 <- X[, 1]

  medias <- lapply(
    tamanos,
    function(k) {
      apply(X[, 1:k, drop = FALSE], 1, mean)
    }
  )
  names(medias) <- paste0("n", tamanos)

  densidades <- c(list(n1 = stats::density(X1)), lapply(medias, stats::density))

  if (isTRUE(mostrar)) {
    oldpar <- graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(oldpar), add = TRUE)
    if (isTRUE(par_original)) {
      graphics::par(
        cex = 0.5,
        cex.axis = 0.5,
        cex.lab = 0.5,
        cex.main = 0.5,
        cex.sub = 0.5,
        mfrow = c(3, 2),
        mai = c(0.5, 0.5, 0.5, 0.5)
      )
    } else {
      nplots <- length(tamanos) + 1
      ncol_plot <- if (nplots <= 4) 2 else 3
      nrow_plot <- ceiling(nplots / ncol_plot)
      graphics::par(
        cex = 0.7,
        cex.axis = 0.7,
        cex.lab = 0.7,
        cex.main = 0.7,
        cex.sub = 0.7,
        mfrow = c(nrow_plot, ncol_plot),
        mai = c(0.5, 0.5, 0.5, 0.3)
      )
    }

    if (tipo_grafico == "densidad") {
      plot(densidades$n1, main = " ", xlab = "n=1")
      for (k in tamanos) {
        plot(densidades[[paste0("n", k)]], main = " ", xlab = paste0("n=", k))
      }
    } else if (tipo_grafico == "histograma") {
      graphics::hist(X1, main = "n=1", freq = FALSE)
      for (k in tamanos) {
        graphics::hist(medias[[paste0("n", k)]], main = paste0("n=", k), freq = FALSE)
      }
    } else if (tipo_grafico == "qqplot") {
      stats::qqnorm(X1, main = "n=1")
      stats::qqline(X1, col = "red")
      for (k in tamanos) {
        stats::qqnorm(medias[[paste0("n", k)]], main = paste0("n=", k))
        stats::qqline(medias[[paste0("n", k)]], col = "red")
      }
    }
  }

  invisible(
    list(
      X = X,
      muestras = c(list(X1 = X1), medias),
      densidades = densidades
    )
  )
}
