#' @title Combinación
#' @description Función que calcula n permutado k
#' @param n tamaño de la población, número entero
#' @param k tamaño de la muestra, número entero
#' @return Cnk  combinación de n con k
#' @export Cnk
#' @examples Cnk(10,2)
#'

Cnk=function(n,k){
  Cnk=choose(n,k)
  return(Cnk)}


