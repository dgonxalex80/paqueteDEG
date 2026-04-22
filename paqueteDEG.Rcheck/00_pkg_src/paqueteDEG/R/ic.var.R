#' @title Intervalo de confianza para una varianza
#' @description Funcion que calcula un intervalo de confianza para una varianza.
#' @param x Vector de datos.
#' @param conf.level Nivel de confianza (por ejemplo, 0.95 para un 95% de confianza).
#' @importFrom stats qchisq var
#' @return Vector con los limites inferior y superior del intervalo de confianza.
#' @export
#' @examples
#' ic.var(c(12, 15, 18, 21, 24, 27, 30), 0.95)
#'

ic.var <- function(x, conf.level) {
  if (!is.numeric(x) || length(x) < 2) {
    stop("`x` debe ser numerico y tener al menos 2 observaciones.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe ser un numero entre 0 y 1.", call. = FALSE)
  }

  # Calcula la varianza muestral
  s2 <- var(x)

  # Grado de libertad
  gl <- length(x) - 1

  # Intervalo de confianza
  lic <- (gl * s2) / qchisq(1 - (1 - conf.level) / 2, df = gl)
  lsc <- (gl * s2) / qchisq((1 - conf.level) / 2, df = gl)

  # Imprime el intervalo de confianza y el nivel de confianza
  cat("Intervalo de confianza ", "\n")
  cat("para la varianza poblacional", "\n")
  cat("\n")
  cat(lic, "; ", lsc, "\n")
  cat("nivel de confianza :", conf.level*100 , "%\n" )
  invisible(c(lim_inf = lic, lim_sup = lsc))
}
