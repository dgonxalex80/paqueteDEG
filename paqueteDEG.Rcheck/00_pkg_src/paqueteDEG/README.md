<!-- README.md is generated from README.Rmd. Please edit that file -->

# paqueteDEG

<!-- badges: start -->
<!-- badges: end -->

El objetivo principal es recopilar una serie de funciones e instructivos
que se utilizan en el curso de Probabilidad y Estadística.

## Instalación

Este paquete está en construcción y se encuentra alojado en GitHub
durante su etapa de elaboración.

``` r
# install.packages("devtools")
devtools::install_github("dgonxalex80/paqueteDEG")
```

## Ejemplo

Con el siguiente comando se cargan las funciones del paquete:

``` r
library(paqueteDEG)

## Código básico para calcular la permutación de n en k: Pnk(n, k), donde n y k son números enteros
Pnk(10,2)
#> [1] 90

## Código básico para calcular la combinación de n en k: Cnk(n, k), donde n y k son números enteros
Cnk(10,2)
#> [1] 45

## Código básico para calcular el tamaño de muestra para la estimación de la media con una confianza del 95%, una varianza estimada de 428 y un error de muestreo de 2: sizemu(perc_normal, varianza, error)
sizemu(1.96,428,2)
#> [1] 411.0512

## Código básico para calcular el tamaño de muestra para la estimación de una proporción con un nivel de confianza del 95%, prop = 0.5 y un error de muestreo de 0.05: sizep(perc_normal, prop, error)
sizep(1.96,0.5,0.05)
#> [1] 384.16

## Corrección del tamaño de la muestra cuando n/N > 0.05: adjusted_size(n, N)
adjusted_size(385,1000)
#> [1] 278.1792

## Estimación del intervalo de confianza para una varianza: intervalo.var(x, 0.95)
intervalo.var(c(3,4,3,2,3,4,5),0.95)
#>   lim_inf   lim_sup
#> 0.2972862 4.6816520
```
