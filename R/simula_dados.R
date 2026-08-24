#' Simular dos dados y calcular operaciones con sus resultados
#'
#' Simula lanzamientos independientes de dos dados y calcula, para cada
#' lanzamiento, la suma, la multiplicacion, la resta y la division de los
#' valores obtenidos.
#'
#' @param n Numero de lanzamientos. Debe ser un entero positivo.
#' @param caras Numero de caras de cada dado. Debe ser un entero mayor o igual
#'   a dos.
#'
#' @return Un `data.frame` con una fila por lanzamiento y las columnas
#'   `dado_1`, `dado_2`, `suma`, `multiplicacion`, `resta` y `division`.
#'   La resta se calcula como `dado_1 - dado_2` y la division como
#'   `dado_1 / dado_2`.
#' @examples
#' set.seed(123)
#' simula_dados()
#'
#' set.seed(123)
#' simula_dados(n = 10)
#'
#' # Dados de ocho caras
#' simula_dados(n = 5, caras = 8)
#' @export
simula_dados <- function(n = 1, caras = 6) {
  es_entero_positivo <- function(x) {
    is.numeric(x) && length(x) == 1L && !is.na(x) && is.finite(x) &&
      x >= 1 && x <= .Machine$integer.max && x == floor(x)
  }

  if (!es_entero_positivo(n)) {
    stop("`n` debe ser un entero positivo.", call. = FALSE)
  }
  if (!es_entero_positivo(caras) || caras < 2) {
    stop("`caras` debe ser un entero mayor o igual a 2.", call. = FALSE)
  }

  n <- as.integer(n)
  caras <- as.integer(caras)
  dado_1 <- sample.int(caras, size = n, replace = TRUE)
  dado_2 <- sample.int(caras, size = n, replace = TRUE)

  data.frame(
    dado_1 = dado_1,
    dado_2 = dado_2,
    suma = as.numeric(dado_1) + dado_2,
    multiplicacion = as.numeric(dado_1) * dado_2,
    resta = as.numeric(dado_1) - dado_2,
    division = as.numeric(dado_1) / dado_2
  )
}
