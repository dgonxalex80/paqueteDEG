#' @title Distribucion muestral para muestreo estratificado
#' @description
#' Distribuye un tamano de muestra total entre estratos usando los porcentajes
#' suministrados para cada estrato.
#' @param samp_size tamano total de la muestra.
#' @param porcentajes vector numerico con los porcentajes de los estratos.
#'   Puede estar en escala 0-100 o 0-1.
#' @param estratos vector opcional con los nombres de los estratos.
#' @return Lista con la informacion suministrada y la distribucion muestral por estrato.
#' @export strata_size
#' @examples
#' strata_size(385, c(40, 35, 25), c("Norte", "Centro", "Sur"))
#' strata_size(100, c(0.5, 0.3, 0.2))

strata_size=function(samp_size,porcentajes,estratos=NULL){
  if (!is.numeric(samp_size) || length(samp_size) != 1 || samp_size <= 0) {
    stop("`samp_size` debe ser un numero positivo.", call. = FALSE)
  }
  if (samp_size != floor(samp_size)) {
    stop("`samp_size` debe ser un numero entero positivo.", call. = FALSE)
  }
  if (!is.numeric(porcentajes) || length(porcentajes) < 1 || any(!is.finite(porcentajes))) {
    stop("`porcentajes` debe ser un vector numerico finito.", call. = FALSE)
  }
  if (any(porcentajes < 0)) {
    stop("`porcentajes` no debe contener valores negativos.", call. = FALSE)
  }
  if (sum(porcentajes) <= 0) {
    stop("La suma de `porcentajes` debe ser positiva.", call. = FALSE)
  }
  if (!is.null(estratos) && length(estratos) != length(porcentajes)) {
    stop("`estratos` debe tener la misma longitud que `porcentajes`.", call. = FALSE)
  }

  if (is.null(estratos)) {
    estratos=paste0("Estrato_", seq_along(porcentajes))
  }

  escala=if (sum(porcentajes) <= 1.0000001 && max(porcentajes) <= 1) "proporcion" else "porcentaje"
  proporcion=porcentajes/sum(porcentajes)
  porcentaje=proporcion*100
  n_exacto=samp_size*proporcion
  n_entero=floor(n_exacto)
  faltantes=samp_size-sum(n_entero)

  if (faltantes > 0) {
    orden=order(n_exacto-n_entero, decreasing=TRUE)
    n_entero[orden[seq_len(faltantes)]]=n_entero[orden[seq_len(faltantes)]]+1
  }

  distribucion=data.frame(
    estrato=estratos,
    porcentaje_suministrado=porcentajes,
    porcentaje=porcentaje,
    tamano_muestra_exacto=n_exacto,
    tamano_muestra=n_entero,
    stringsAsFactors=FALSE
  )

  resultado=list(
    muestreo="estratificado",
    tamano_muestra_total=samp_size,
    escala_suministrada=escala,
    suma_porcentajes_suministrados=sum(porcentajes),
    distribucion=distribucion
  )

  class(resultado)="stratified_sample_result"
  return(resultado)
}
