#' @title Resumen numerico con histogram y diagrama de cajas
#' @description
#' Calcula medidas descriptivas basicas para un vector numerico y
#' muestra los indicadores junto con un histograma o un diagrama de cajas.
#' @param x vector numerico.
#' @param na.rm si `TRUE`, elimina valores faltantes.
#' @param graficar si `TRUE`, dibuja histograma y boxplot.
#' @param grafico tipo de grafico a mostrar: `"histograma"` o `"cajas"`.
#' @param decimals numero de decimales a mostrar.
#' @return Data frame de una columna con medidas descriptivas.
#' @examples
#' resumen_num(c(12, 15, 18, 20, 22, 25, 30))
#' @export
resumen_num <- function(x, na.rm = TRUE, graficar = TRUE, grafico = c("histograma", "cajas"), decimals = 2) {
  grafico <- match.arg(grafico)

  if (!is.numeric(x)) {
    stop("`x` debe ser un vector numerico.", call. = FALSE)
  }
  if (!is.logical(na.rm) || length(na.rm) != 1) {
    stop("`na.rm` debe ser TRUE o FALSE.", call. = FALSE)
  }
  if (!is.logical(graficar) || length(graficar) != 1) {
    stop("`graficar` debe ser TRUE o FALSE.", call. = FALSE)
  }
  if (!is.numeric(decimals) || length(decimals) != 1 || decimals < 0 || decimals != as.integer(decimals)) {
    stop("`decimals` debe ser un entero mayor o igual a 0.", call. = FALSE)
  }

  n_total <- length(x)
  na_total <- sum(is.na(x))
  na_prop <- if (n_total > 0) na_total / n_total else NA_real_

  x0 <- x
  if (isTRUE(na.rm)) {
    x0 <- x0[!is.na(x0)]
  } else if (anyNA(x0)) {
    stop("`x` contiene NA. Usa `na.rm = TRUE` para removerlos.", call. = FALSE)
  }

  if (length(x0) < 2) {
    stop("`x` debe tener al menos 2 observaciones validas.", call. = FALSE)
  }

  q <- as.numeric(stats::quantile(x0, probs = c(0.25, 0.5, 0.75), na.rm = FALSE))
  iqr <- q[3] - q[1]
  media <- mean(x0)
  s <- stats::sd(x0)

  if (s > 0) {
    asimetria <- mean((x0 - media)^3) / (s^3)
    curtosis_exceso <- mean((x0 - media)^4) / (s^4) - 3
    cv <- s / abs(media)
  } else {
    asimetria <- NA_real_
    curtosis_exceso <- NA_real_
    cv <- NA_real_
  }

  out <- c(
    `nbr.total` = n_total,
    `nbr.na` = na_total,
    `pct.na` = na_prop * 100,
    `nbr.valid` = length(x0),
    `min` = min(x0),
    `q1` = q[1],
    `median` = q[2],
    `mean` = media,
    `q3` = q[3],
    `max` = max(x0),
    `range` = max(x0) - min(x0),
    `iqr` = iqr,
    `var` = stats::var(x0),
    `sd` = s,
    `cv` = cv,
    `skewness` = asimetria,
    `kurtosis` = curtosis_exceso
  )

  if (isTRUE(graficar)) {
    oldpar <- graphics::par(no.readonly = TRUE)
    on.exit(graphics::par(oldpar), add = TRUE)
    graphics::layout(matrix(c(1, 2), nrow = 1, byrow = TRUE), widths = c(1.25, 1))

    graphics::par(mar = c(4, 4, 3, 1))
    graphics::plot.new()
    graphics::plot.window(xlim = c(0, 1), ylim = c(0, 1))
    out_num <- round(as.numeric(out), decimals)
    fmt <- paste0("%-12s %10.", decimals, "f")
    txt <- paste(sprintf(fmt, names(out), out_num), collapse = "\n")
    graphics::text(
      x = 0.02, y = 0.98,
      labels = paste("Indicadores\n\n", txt, sep = ""),
      adj = c(0, 1),
      cex = 0.82,
      family = "mono"
    )
    graphics::box()

    graphics::par(mar = c(4, 4, 3, 1))
    if (grafico == "histograma") {
      graphics::hist(
        x0,
        col = "lightblue",
        border = "white",
        main = "Histograma",
        xlab = "x"
      )
    } else {
      graphics::boxplot(
        x0,
        col = "lightgreen",
        main = "Diagrama de cajas",
        ylab = "x"
      )
    }
  }

  out_df <- data.frame(valor = round(as.numeric(out), decimals), row.names = names(out))
  return(out_df)
}
