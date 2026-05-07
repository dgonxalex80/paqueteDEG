#' @title Tamano de la muestra para la estimacion de una proporcion
#' @description Funcion que calcula el tamano de la muestra para la estimacion de una proporcion.
#' @param perc_normal valor del percentil normal que indica el nivel de confianza
#' @param prob valor de la proporcion estimada
#' @param error valor del error de muestreo (diferencia entre la media muestral y el parametro)
#' @param pob_size valor opcional del tamano de la poblacion finita
#' @return Lista con la informacion suministrada y el tamano de muestra final
#' @export sizep
#' @examples sizep(1.96,0.5,0.02)
#' @examples sizep(1.96,0.5,0.02, pob_size = 1000)
# '

sizep=function(perc_normal,prob,error,pob_size=NULL){
  if (!is.numeric(perc_normal) || length(perc_normal) != 1 || perc_normal <= 0) {
    stop("`perc_normal` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(prob) || length(prob) != 1 || prob < 0 || prob > 1) {
    stop("`prob` debe ser un numero entre 0 y 1.", call. = FALSE)
  }
  if (!is.numeric(error) || length(error) != 1 || error <= 0) {
    stop("`error` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.null(pob_size) && (!is.numeric(pob_size) || length(pob_size) != 1 || pob_size <= 0)) {
    stop("`pob_size` debe ser NULL o un numero positivo.", call. = FALSE)
  }

  n_inicial=perc_normal^2*prob*(1-prob)/error^2
  n_final=n_inicial
  poblacion_finita=!is.null(pob_size)

  if (poblacion_finita) {
    n_final=(pob_size*n_inicial)/(pob_size+n_inicial-1)
  }

  resultado=list(
    estimacion="proporcion",
    percentil_normal=perc_normal,
    nivel_confianza=2*stats::pnorm(perc_normal)-1,
    proporcion=prob,
    varianza=prob*(1-prob),
    error_muestreo=error,
    poblacion_finita=poblacion_finita,
    tamano_poblacion=pob_size,
    tamano_muestra_inicial=n_inicial,
    tamano_muestra_final=n_final,
    tamano_muestra_final_redondeado=ceiling(n_final)
  )

  class(resultado)="sample_size_result"
  return(resultado)
}
