#' @title Permutación
#' @description Función que calcula n permutado k
#' @param n tamaño de la población, número entero
#' @param k tamaño de la muestra, número entero
#' @return Pnk  permutacion de n con k
#' @export Pnk
#' @examples Pnk(10,2)
#'

Pnk=function(n,k){
  Pnk=choose(n,k)*factorial(k)
  return(Pnk)}


