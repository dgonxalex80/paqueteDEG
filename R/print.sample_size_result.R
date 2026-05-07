#' @export
print.sample_size_result=function(x,...){
  cat("Tamano de muestra\n")
  cat("-----------------\n")

  campos=names(x)
  campos=campos[campos!="tamano_muestra_final_redondeado"]

  for (campo in campos) {
    valor=x[[campo]]
    if (is.null(valor)) {
      valor="No aplica"
    }
    if (is.numeric(valor)) {
      valor=format(valor, digits=6, scientific=FALSE)
    }
    cat(campo, ": ", valor, "\n", sep="")
  }

  cat("resultado_final: ", x$tamano_muestra_final_redondeado, "\n", sep="")
  invisible(x)
}
