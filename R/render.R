#' Renderizar un archivo R Markdown o Quarto en el Viewer
#'
#' Renderiza un archivo con extension `.Rmd` o `.qmd` y abre el resultado en el
#' Viewer de RStudio. Fuera de RStudio, abre el resultado en el navegador
#' configurado por R.
#'
#' @param archivo Ruta al archivo `.Rmd` o `.qmd` que se desea renderizar.
#' @param tipo Motor de renderizado: `"auto"`, `"Rmd"` o `"qmd"`. Con
#'   `"auto"`, el valor predeterminado, se utiliza la extension de `archivo`.
#'
#' @return Invisiblemente, la ruta absoluta al archivo generado.
#' @examples
#' \dontrun{
#' render_rmd("informe.Rmd")
#' render_rmd("informe.qmd")
#' render_rmd("informe.qmd", tipo = "qmd")
#' }
#' @export
render_rmd <- function(archivo, tipo = "auto") {
  if (!is.character(archivo) || length(archivo) != 1L ||
      is.na(archivo) || !nzchar(archivo)) {
    stop("`archivo` debe ser una ruta de texto no vacia.", call. = FALSE)
  }
  if (!grepl("\\.(Rmd|qmd)$", archivo, ignore.case = TRUE)) {
    stop("`archivo` debe tener extension `.Rmd` o `.qmd`.", call. = FALSE)
  }
  if (!file.exists(archivo) || dir.exists(archivo)) {
    stop("No se encontro el archivo: ", archivo, call. = FALSE)
  }

  tipo <- .resolver_tipo_archivo(tipo, archivo)

  if (tipo == "rmd") {
    .comprobar_rmarkdown()
    salida <- rmarkdown::render(input = archivo, envir = parent.frame())
  } else {
    salida <- .renderizar_quarto(archivo)
  }

  salida <- normalizePath(salida, mustWork = TRUE)
  .mostrar_en_viewer(salida)

  invisible(salida)
}

#' Renderizar un proyecto R Markdown o Quarto en el Viewer
#'
#' Renderiza el proyecto R Markdown o Quarto ubicado en el directorio de trabajo
#' actual y abre su pagina principal en el Viewer de RStudio. Fuera de RStudio,
#' abre la pagina en el navegador configurado por R.
#'
#' @param tipo Motor de renderizado: `"auto"`, `"Rmd"` o `"qmd"`. Con
#'   `"auto"`, el valor predeterminado, se selecciona Quarto cuando existe
#'   `_quarto.yml` o `_quarto.yaml`; en caso contrario se utiliza R Markdown.
#'
#' @details
#' Sin parametros, la funcion detecta automaticamente el tipo de proyecto. Un
#' proyecto R Markdown debe incluir la configuracion requerida por
#' [rmarkdown::render_site()]. Un proyecto Quarto debe incluir `_quarto.yml` o
#' `_quarto.yaml` y requiere que la CLI de Quarto este instalada.
#'
#' @return Invisiblemente, la ruta absoluta a la pagina principal generada.
#' @examples
#' \dontrun{
#' render_project()
#' render_project(tipo = "qmd")
#' }
#' @export
render_project <- function(tipo = "auto") {
  tipo <- .resolver_tipo_proyecto(tipo)

  if (tipo == "rmd") {
    .comprobar_rmarkdown()
    salida <- rmarkdown::render_site(envir = parent.frame())
  } else {
    salida <- .renderizar_quarto(".")
  }

  salida <- normalizePath(salida, mustWork = TRUE)
  .mostrar_en_viewer(salida)

  invisible(salida)
}

.normalizar_tipo <- function(tipo) {
  if (!is.character(tipo) || length(tipo) != 1L ||
      is.na(tipo) || !nzchar(tipo)) {
    stop("`tipo` debe ser `\"auto\"`, `\"Rmd\"` o `\"qmd\"`.", call. = FALSE)
  }

  tipo <- tolower(tipo)
  if (!tipo %in% c("auto", "rmd", "qmd")) {
    stop("`tipo` debe ser `\"auto\"`, `\"Rmd\"` o `\"qmd\"`.", call. = FALSE)
  }

  tipo
}

.resolver_tipo_archivo <- function(tipo, archivo) {
  tipo <- .normalizar_tipo(tipo)
  extension <- tolower(tools::file_ext(archivo))

  if (tipo == "auto") {
    return(extension)
  }
  if (tipo != extension) {
    stop(
      "El `tipo` indicado no coincide con la extension de `archivo`.",
      call. = FALSE
    )
  }

  tipo
}

.resolver_tipo_proyecto <- function(tipo) {
  tipo <- .normalizar_tipo(tipo)

  if (tipo == "auto") {
    configuracion_quarto <- file.exists("_quarto.yml") ||
      file.exists("_quarto.yaml")
    return(if (configuracion_quarto) "qmd" else "rmd")
  }

  tipo
}

.comprobar_rmarkdown <- function() {
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop(
      "Debes instalar `rmarkdown` para renderizar archivos o proyectos.",
      call. = FALSE
    )
  }
}

.renderizar_quarto <- function(entrada) {
  ejecutable <- Sys.which("quarto")
  if (!nzchar(ejecutable)) {
    stop(
      "Debes instalar la CLI de Quarto para renderizar archivos o proyectos `.qmd`.",
      call. = FALSE
    )
  }

  entrada <- normalizePath(entrada, mustWork = TRUE)
  directorio_salida <- if (dir.exists(entrada)) entrada else dirname(entrada)
  resultado <- system2(
    command = ejecutable,
    args = c("render", shQuote(entrada), "--to", "html"),
    stdout = TRUE,
    stderr = TRUE,
    env = "NO_COLOR=1"
  )
  estado <- attr(resultado, "status")

  if (!is.null(estado) && estado != 0L) {
    stop(
      "Quarto no pudo completar el renderizado:\n",
      paste(resultado, collapse = "\n"),
      call. = FALSE
    )
  }

  linea_salida <- grep("Output created:", resultado, value = TRUE)
  if (!length(linea_salida)) {
    stop("Quarto no informo la ruta del archivo generado.", call. = FALSE)
  }

  salida <- trimws(sub(
    "^.*Output created:[[:space:]]*",
    "",
    utils::tail(linea_salida, 1L)
  ))
  if (!grepl("^(~|/|[A-Za-z]:[/\\\\])", salida)) {
    salida <- file.path(directorio_salida, salida)
  }

  salida
}

.mostrar_en_viewer <- function(archivo) {
  viewer <- getOption("viewer")

  if (is.function(viewer)) {
    viewer(archivo)
  } else {
    utils::browseURL(archivo)
  }

  invisible(archivo)
}
