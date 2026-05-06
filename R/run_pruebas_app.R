#' @title Ejecutar App Shiny de Pruebas de Hipotesis
#' @description
#' Lanza una app Shiny con pruebas de hipotesis tradicionales y resumidas.
#' @return Inicia la aplicacion Shiny.
#' @export
run_pruebas_app <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Debes instalar `shiny` para ejecutar esta app.", call. = FALSE)
  }

  app_dir <- system.file("shiny/pruebas-hipotesis", package = "paqueteDEG")
  if (!nzchar(app_dir)) {
    stop("No se encontro la app dentro del paquete.", call. = FALSE)
  }

  shiny::runApp(app_dir, display.mode = "normal")
}
