#' @title Intervalo de confianza para una varianza
#' @description Funcion que calcula un intervalo de confianza para una varianza.
#' @param x vector con variable numerica
#' @param niv.conf nivel de confianza (por ejemplo, 0.95)
#' @return Vector con los limites inferior y superior del intervalo de confianza.
#' @export intervalo.var
#' @importFrom  stats  qchisq var
#' @examples intervalo.var(c(3,4,3,2,3,4,5),0.95)
# '

intervalo.var=function(x,niv.conf=0.95){
  if (!is.numeric(x) || length(x) < 2) {
    stop("`x` debe ser numerico y tener al menos 2 observaciones.", call. = FALSE)
  }
  if (!is.numeric(niv.conf) || length(niv.conf) != 1 || niv.conf <= 0 || niv.conf >= 1) {
    stop("`niv.conf` debe ser un numero entre 0 y 1.", call. = FALSE)
  }

  n=length(x)
  alpha <- 1 - niv.conf
  per.chi2=qchisq(c(1 - alpha/2, alpha/2), n-1)
  ic <- (n-1)*var(x)/per.chi2
  names(ic) <- c("lim_inf", "lim_sup")
  return(ic)
}
