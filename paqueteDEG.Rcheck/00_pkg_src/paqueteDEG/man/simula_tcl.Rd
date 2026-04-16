\name{simula_tcl}
\alias{simula_tcl}
\title{Simulacion del Teorema Central del Limite}
\usage{
simula_tcl(
  generador,
  n = 1000,
  replicas = 1000,
  tamanos = c(2, 30, 50, 100, 1000),
  tipo_grafico = c("densidad", "histograma", "qqplot"),
  mostrar = TRUE,
  par_original = TRUE,
  ...
)
}
\arguments{
\item{generador}{funcion o llamada para generar aleatorios.}

\item{n}{numero maximo de columnas (tamano maximo de muestra).}

\item{replicas}{numero de replicas (numero de filas de la matriz).}

\item{tamanos}{vector con tamanos de muestra para calcular medias.}

\item{tipo_grafico}{tipo de grafico: \code{"densidad"}, \code{"histograma"} o \code{"qqplot"}.}

\item{mostrar}{si \code{TRUE}, dibuja los graficos.}

\item{par_original}{si \code{TRUE}, usa la configuracion de \code{par()} del codigo
original: \code{cex=.5}, \code{cex.axis=.5}, \code{cex.lab=.5}, \code{cex.main=.5},
\code{cex.sub=.5}, \code{mfrow=c(3,2)}, \code{mai=c(.5,.5,.5,.5)}.}

\item{...}{parametros adicionales para el generador cuando se pasa como nombre
de funcion (por ejemplo, \code{rate = 1} en \code{rexp}).}
}
\value{
Una lista con:
\describe{
\item{X}{matriz de datos simulados}
\item{muestras}{lista con \code{X1} y las medias muestrales por tamano}
\item{densidades}{lista de densidades empiricas}
}
}
\description{
Genera muestras aleatorias y calcula las medias muestrales para distintos
tamanos de muestra, con el fin de visualizar el Teorema Central del Limite.
}
\details{
El argumento \code{generador} puede pasarse de dos formas:
\enumerate{
\item Como llamada: \code{rexp(m, 1)} o \code{runif(m, 10, 50)}.
\item Como nombre de funcion: \code{rexp} o \code{runif} y sus parametros en \code{...}.
}
}
\examples{
out1 <- simula_tcl(rexp(m, 1), n = 200, replicas = 200, mostrar = FALSE)
out2 <- simula_tcl(runif(m, 10, 50), n = 200, replicas = 200, mostrar = FALSE)
out3 <- simula_tcl(rexp, n = 200, replicas = 200, rate = 1, mostrar = FALSE)
}
