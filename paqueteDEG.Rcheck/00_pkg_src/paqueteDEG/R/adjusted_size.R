#' @title Correccion del tamano de la muestra por el factor de poblacion finita
#' @description Funcion que corrige el tamano de la muestra cuando n/N>0.05
#' @param samp_size valor del tamano de la muestra inicial
#' @param pob_size valor del tamano de la poblacion
#' @return Lista con la informacion suministrada y el tamano de muestra ajustado
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
  resultado=list(
    poblacion_finita=TRUE,
    tamano_poblacion=pob_size,
    tamano_muestra_inicial=samp_size,
    fraccion_muestreo=samp_size/pob_size,
    requiere_correccion=samp_size/pob_size>0.05,
    tamano_muestra_final=adjusted_size,
    tamano_muestra_final_redondeado=ceiling(adjusted_size)
  )

  class(resultado)="sample_size_result"
  return(resultado)
}
