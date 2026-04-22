#' @title Correccion del tamano de la muestra por el factor de poblacion finita
#' @description Funcion que corrige el tamano de la muestra cuando n/N>0.05
#' @param samp_size valor del tamano de la muestra inicial
#' @param pob_size valor del tamano de la poblacion
#' @return n0 tamano de muestra ajustado
#' @export adjusted_size
#' @examples  adjusted_size(385,500)
# '

adjusted_size=function(samp_size,pob_size){
  if (!is.numeric(samp_size) || length(samp_size) != 1 || samp_size <= 0) {
    stop("`samp_size` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(pob_size) || length(pob_size) != 1 || pob_size <= 0) {
    stop("`pob_size` debe ser un numero positivo.", call. = FALSE)
  }
  adjusted_size=(pob_size*samp_size)/(pob_size+samp_size-1)
  return(adjusted_size)
}
