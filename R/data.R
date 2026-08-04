#' Pricios y caracteristicas de viviendas.
#'
#' Esta data contiene los precios y principales caraceristica de vienes inmuebles
#'
#' @format Una data con 54 filas y 10 variables:
#' \describe{
#'   \item{id}{consecutivo}
#'   \item{precio}{precio de la vivienda en miles de U$D}
#'   \item{imp.pred}{valor impuesto predial}
#'   \item{num.ban}{numero de banos}
#'   \item{area.lot}{area del lote}
#'   \item{area.con}{area construida}
#'   \item{num.gar}{numero de garajes}
#'   \item{num.cua}{numero de cuartos}
#'   \item{num.hab}{numero de habitaciones}
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
#'  \item{ausen}{dias ausentes del trabajo por ano}
#'  \item{taller}{1 trabaja en el taller, 0 no trabaja en el taller}
#'  \item{sexo}{1 hombre, 0 mujer}
#'  \item{edad}{edad del trabajador en anos}
#'  \item{antg}{antiguedad del trabajador en anos}
#'  \item{sala}{salario del trabajador en miles de pesos}
#' }
#' @examples
#' ausentismo
"ausentismo"


#' Cervezas
#'
#' Esta data recoge algunas de las caracteristicas de la cerveza
#' @format Data frame con 69 marcas de cerveza y 6 variables
#' \describe{
#'  \item{marca}{marca de la cerveza}
#'  \item{precio}{precio de presentacion de 6 botellas de 12 onzas}
#'  \item{calorias}{cantidad de calorias por unidad de 12 onzas}
#'  \item{poralcoh}{porcentaje de alcohol por volumen}
#'  \item{tipo}{1 lager artesanal, 2 clara artesanal, 3 lager importada, 4 cerveza normal y helada, y 5 cerveza baja en calorias y sin alcohol}
#'  \item{origen}{0 importada, 1 nacional}
#' }
#' @examples
#' beer
"beer"


#' Colombia 2023
#'
#' Base de datos usada como apoyo en ejercicios del curso.
#' @format Data frame con variables socioeconomicas y demograficas.
#' @examples
#' Colombia23
"Colombia23"


#' Inventario de paquetes
#'
#' Base de datos con inventario de paquetes utilizados en el curso.
#' @format Data frame.
#' @examples
#' inventarioPackages
"inventarioPackages"




#' Descargar la base de cervezas en formato CSV
#'
#' Copia el archivo original de la base beer incluido en la instalacion de
#' paqueteDEG a una ubicacion elegida por el usuario.
#'
#' @param destino Ruta y nombre del archivo CSV que se desea crear.
#' @param sobrescribir Si es TRUE, reemplaza un archivo existente.
#' @return La ruta absoluta del archivo creado, de forma invisible.
#' @examples
#' \dontrun{
#' descargar_beer("beer.csv")
#' }
#' @export
descargar_beer <- function(destino = "beer.csv", sobrescribir = FALSE) {
  origen <- system.file("extdata", "beer.csv", package = "paqueteDEG")
  if (!nzchar(origen)) {
    stop("No se encontr\u00f3 beer.csv dentro de la instalaci\u00f3n de paqueteDEG.")
  }
  if (file.exists(destino) && !isTRUE(sobrescribir)) {
    stop("El archivo ya existe. Use sobrescribir = TRUE para reemplazarlo.")
  }
  creado <- file.copy(origen, destino, overwrite = sobrescribir)
  if (!creado) stop("No fue posible copiar beer.csv en el destino indicado.")
  ruta <- normalizePath(destino, mustWork = TRUE)
  message("Archivo creado en: ", ruta)
  invisible(ruta)
}
