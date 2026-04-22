#' @title Tamano de la muestra para la estimacion de una media
#' @description Funcion que calcula el tamano de la muestra para la estimacion de una media.
#' @param perc_normal valor del percentil normal que indica el nivel de confianza
#' @param varianza valor de la varianza estimada
#' @param error valor del error de muestreo (diferencia entre la media muestral y el parametro)
#' @return nmu tamano de muestra para la estimacion de una media
#' @export sizemu
#' @examples sizemu(1.96,245,2)
# '

sizemu=function(perc_normal,varianza,error){
  if (!is.numeric(perc_normal) || length(perc_normal) != 1 || perc_normal <= 0) {
    stop("`perc_normal` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(varianza) || length(varianza) != 1 || varianza <= 0) {
    stop("`varianza` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(error) || length(error) != 1 || error <= 0) {
    stop("`error` debe ser un numero positivo.", call. = FALSE)
  }
  sizemu=perc_normal^2*varianza/error^2
  return(sizemu)}
