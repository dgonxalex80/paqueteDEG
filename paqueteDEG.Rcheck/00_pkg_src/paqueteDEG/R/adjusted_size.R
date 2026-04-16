#' @title Corrección del tamaño de la muestra por el factor de población finita
#' @description Función que corrige el tamaño de la muestra cuando n/N>0.05
#' @param samp_size valor del tamaño de la muestra inicial
#' @param pob_size valor del tamaño de la población
#' @return n0 tamaño de muestra ajustado
#' @export adjusted_size
#' @examples  adjusted_size(385,500)
# '

adjusted_size=function(samp_size,pob_size){
  adjusted_size=(pob_size*samp_size)/(pob_size+samp_size-1)
  return(adjusted_size)
}
