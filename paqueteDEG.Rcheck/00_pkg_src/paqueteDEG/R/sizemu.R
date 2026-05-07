#' @title Tamano de la muestra para la estimacion de una media
#' @description Funcion que calcula el tamano de la muestra para la estimacion de una media.
#' @param perc_normal valor del percentil normal que indica el nivel de confianza
#' @param varianza valor de la varianza estimada
#' @param error valor del error de muestreo (diferencia entre la media muestral y el parametro)
#' @param pob_size valor opcional del tamano de la poblacion finita
#' @return Lista con la informacion suministrada y el tamano de muestra final
#' @export sizemu
#' @examples sizemu(1.96,245,2)
#' @examples sizemu(1.96,245,2, pob_size = 1000)
# '

sizemu=function(perc_normal,varianza,error,pob_size=NULL){
  if (!is.numeric(perc_normal) || length(perc_normal) != 1 || perc_normal <= 0) {
    stop("`perc_normal` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(varianza) || length(varianza) != 1 || varianza <= 0) {
    stop("`varianza` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(error) || length(error) != 1 || error <= 0) {
    stop("`error` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.null(pob_size) && (!is.numeric(pob_size) || length(pob_size) != 1 || pob_size <= 0)) {
    stop("`pob_size` debe ser NULL o un numero positivo.", call. = FALSE)
  }

  n_inicial=perc_normal^2*varianza/error^2
  n_final=n_inicial
  poblacion_finita=!is.null(pob_size)

  if (poblacion_finita) {
    n_final=(pob_size*n_inicial)/(pob_size+n_inicial-1)
  }

  resultado=list(
    estimacion="media",
    percentil_normal=perc_normal,
    nivel_confianza=2*stats::pnorm(perc_normal)-1,
    varianza=varianza,
    error_muestreo=error,
    poblacion_finita=poblacion_finita,
    tamano_poblacion=pob_size,
    tamano_muestra_inicial=n_inicial,
    tamano_muestra_final=n_final,
    tamano_muestra_final_redondeado=ceiling(n_final)
  )

  class(resultado)="sample_size_result"
  return(resultado)}
