#' Generar y representar una muestra de bolas de colores
#'
#' Extrae una muestra aleatoria con reemplazo a partir de los colores y las
#' probabilidades indicadas, y representa el resultado como un conjunto de
#' bolas. Los colores pueden escribirse usando nombres reconocidos por R o
#' codigos hexadecimales.
#'
#' @param n Tamano de la muestra. Debe ser un entero positivo.
#' @param colores Vector de colores reconocidos por R, por ejemplo
#'   `c("white", "red", "blue")` o `c("#FFFFFF", "#FF0000", "#0000FF")`.
#' @param probabilidades Vector numerico no negativo, con una probabilidad por
#'   cada elemento de `colores`. No es necesario que sume uno.
#'
#' @return Invisiblemente, un `data.frame` con la posicion, la fila, la columna
#'   y el color de cada bola extraida.
#' @examples
#' set.seed(123)
#' muestra_bolas(
#'   n = 10,
#'   colores = c("white", "red", "blue"),
#'   probabilidades = c(3, 5, 4)
#' )
#'
#' set.seed(321)
#' muestra_bolas(
#'   n = 15,
#'   colores = c("#F4D35E", "#EE964B", "#0D3B66"),
#'   probabilidades = c(0.5, 0.3, 0.2)
#' )
#' @export
muestra_bolas <- function(n, colores, probabilidades) {
  if (!is.numeric(n) || length(n) != 1L || is.na(n) || !is.finite(n) ||
      n < 1 || n > .Machine$integer.max || n != floor(n)) {
    stop("`n` debe ser un entero positivo.", call. = FALSE)
  }

  if (!is.character(colores) || length(colores) < 1L ||
      anyNA(colores) || any(!nzchar(colores))) {
    stop("`colores` debe ser un vector de caracteres no vacio.", call. = FALSE)
  }

  colores_validos <- vapply(
    colores,
    function(color) {
      tryCatch({
        grDevices::col2rgb(color)
        TRUE
      }, error = function(e) FALSE)
    },
    logical(1)
  )
  if (!all(colores_validos)) {
    stop(
      "Color no valido en `colores`: ",
      paste(colores[!colores_validos], collapse = ", "),
      ".",
      call. = FALSE
    )
  }

  if (!is.numeric(probabilidades) ||
      length(probabilidades) != length(colores) ||
      anyNA(probabilidades) || any(!is.finite(probabilidades)) ||
      any(probabilidades < 0) || sum(probabilidades) <= 0) {
    stop(
      paste0(
        "`probabilidades` debe contener un valor numerico no negativo y ",
        "finito por cada color, y al menos uno debe ser positivo."
      ),
      call. = FALSE
    )
  }

  n <- as.integer(n)
  muestra <- sample(
    colores,
    size = n,
    replace = TRUE,
    prob = probabilidades / sum(probabilidades)
  )

  max_por_fila <- 10L
  columna <- ((seq_len(n) - 1L) %% max_por_fila) + 1L
  fila <- ((seq_len(n) - 1L) %/% max_por_fila) + 1L
  numero_filas <- max(fila)
  elementos_por_fila <- tabulate(fila, nbins = numero_filas)
  x <- columna + (max_por_fila - elementos_por_fila[fila]) / 2
  y <- numero_filas - fila + 1L

  old_par <- graphics::par(c("mar", "oma"))
  on.exit(graphics::par(old_par), add = TRUE)
  graphics::par(mar = rep(0, 4), oma = rep(0, 4))

  margen <- 0.35
  graphics::plot.new()
  graphics::plot.window(
    xlim = range(x) + c(-margen, margen),
    ylim = range(y) + c(-margen, margen),
    xaxs = "i",
    yaxs = "i"
  )
  graphics::points(
    x,
    y,
    pch = 21,
    bg = muestra,
    col = "#4D4D4D",
    lwd = 0.8,
    cex = 2.6
  )

  invisible(data.frame(
    posicion = seq_len(n),
    fila = fila,
    columna = columna,
    color = muestra,
    stringsAsFactors = FALSE
  ))
}
