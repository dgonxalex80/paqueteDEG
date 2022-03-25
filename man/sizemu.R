#' @title Tamaño de la muestra para la estimación de una media
#' @description Función que calcula el tamaño de la muestra para la estimación de un media
#' @param perc_normal valor del percentil normal que indica el nivel de confianza
#' @param varianza valor de la varianza estimada
#' @param error valor del error de muestreo (diferencia entre la media muestral y el parámetro)
#' @return nmu tamaño de muestra para la estimación de una media
#' @export sizemu
#' @examples sizemu(1.96,245,2)
# '

sizemu=function(perc_normal,varianza,error){
  sizemu=perc_normal^2*varianza/error^2
  return(sizemu)}

