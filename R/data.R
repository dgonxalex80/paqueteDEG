#' Pricios y caracteristicas de viviendas.
#'
#' Esta data contiene los precios y principales caraceristica de vienes inmuebles
#'
#' @format Una data con 54 filas y 10 variables:
#' \describe{
#'   \item{id}{consecutivo}
#'   \item{precio}{precio de la vivienda en miles de U$D}
#'   \item{imp.pred}{valor impuesto predial}
#'   \item{num.ban}{número de baños}
#'   \item{area.lot}{área del lote}
#'   \item{area.con}{área construida}
#'   \item{num.gar}{número de garajes}
#'   \item{num.cua}{número de cuartos}
#'   \item{num.hab}{número de habitaciones}
#'   \item{edad}{edad de la vivienda}
#'   ...
#' }
#' @examples
#' casas
"casas"

#' Ausencias al trabajo
#'
#' Esta data contiene caracteristicas de trabajadores que faltan a su trabajo
#' @format Data con 48 registros y 7 variables
#' \describe{
#'  \item{id}{identificador del trabajador}
#'  \item{ausen}{dias ausentes del trabajo por año}
#'  \item{taller}{1 trabaja en el taller, 0 no trabaja en el taller}
#'  \item{sexo}{1 hombre, 0 mujer}
#'  \item{edad}{edad del trabajador en años}
#'  \item{antg}{antiguedad del trabajador en años}
#'  \item{sala}{salario del trabajador en miles de pesos}
#' }
#' @examples
#' ausentismo
"ausentismo"


#' Cervezas
#'
#' Esta data recoge algunas de las caracteristicas de la cerveza
#' @format Data compuesta por 69 marcas de cerveza y 6 variables
#' \describe{
#'  \item{marca}{marca de la cerveza}
#'  \item{precio}{precio de presentación de 6 botellas de 12 onzas}
#'  \item{calorias}{cantidad de caloroas por unidad de 12 onzas}
#'  \item{poralcoh}{porcentaje de alcohol por 12 onzas de contenido}
#'  \item{tipo}{1 lager artesanal, 2 clara artesanal, 3 lager importada, 4 cerveza normal y helada, y 5 cerveza baja en calorías y sin alcohol}
#'  \item{origen}{1 nacional, 2 importada}
#' }
#' @examples
#' beer
"beer"



