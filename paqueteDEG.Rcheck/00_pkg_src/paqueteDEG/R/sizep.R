#' @title Tamano de la muestra para la estimacion de una proporcion
#' @description Funcion que calcula el tamano de la muestra para la estimacion de una proporcion.
#' @param perc_normal valor del percentil normal que indica el nivel de confianza
#' @param prob valor de la proporcion estimada
#' @param error valor del error de muestreo (diferencia entre la media muestral y el parametro)
#' @return sizep tamano de muestra para la estimacion de una proporcion
#' @export sizep
#' @examples sizep(1.96,0.5,0.02)
# '

sizep=function(perc_normal,prob,error){
  if (!is.numeric(perc_normal) || length(perc_normal) != 1 || perc_normal <= 0) {
    stop("`perc_normal` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(prob) || length(prob) != 1 || prob < 0 || prob > 1) {
    stop("`prob` debe ser un numero entre 0 y 1.", call. = FALSE)
  }
  if (!is.numeric(error) || length(error) != 1 || error <= 0) {
    stop("`error` debe ser un numero positivo.", call. = FALSE)
  }
  sizep=perc_normal^2*prob*(1-prob)/error^2
  return(sizep)
}
