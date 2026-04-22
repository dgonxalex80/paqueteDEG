#' @title Permutación
#' @description Función que calcula la permutación de n en k.
#' @param n tamaño de la población, número entero
#' @param k tamaño de la muestra, número entero
#' @return Pnk  permutacion de n con k
#' @export Pnk
#' @examples Pnk(10,2)
#'

Pnk=function(n,k){
  if (!is.numeric(n) || !is.numeric(k) || length(n) != 1 || length(k) != 1 ||
      n < 0 || k < 0 || n != as.integer(n) || k != as.integer(k)) {
    stop("`n` y `k` deben ser enteros no negativos.", call. = FALSE)
  }
  if (k > n) {
    stop("`k` no puede ser mayor que `n`.", call. = FALSE)
  }
  Pnk=choose(n,k)*factorial(k)
  return(Pnk)}

