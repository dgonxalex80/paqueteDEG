#' @export
print.stratified_sample_result=function(x,...){
  cat("Distribucion muestral estratificada\n")
  cat("-----------------------------------\n")
  cat("tamano_muestra_total: ", x$tamano_muestra_total, "\n", sep="")
  cat("escala_suministrada: ", x$escala_suministrada, "\n", sep="")
  cat("suma_porcentajes_suministrados: ", x$suma_porcentajes_suministrados, "\n\n", sep="")
  print(x$distribucion, row.names=FALSE)
  invisible(x)
}
