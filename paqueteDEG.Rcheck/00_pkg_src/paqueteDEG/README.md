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
# Opción recomendada (más robusta para GitHub)
install.packages("pak")
pak::pak("dgonxalex80/paqueteDEG")
```

También puedes instalar desde una copia local del repositorio:

``` r
devtools::install_local("/ruta/a/paqueteDEG", dependencies = TRUE)
```

## Solución de problemas de instalación

Si aparece un error al abrir `https://api.github.com/...`, el problema suele
ser de conectividad o autenticación con GitHub.

``` r
# Diagnóstico rápido de red
curl::has_internet()
download.file("https://api.github.com", tempfile(), quiet = FALSE)
```

Si tienes acceso a internet pero falla la descarga desde GitHub, configura un
token personal:

``` r
usethis::create_github_token()
gitcreds::gitcreds_set()
```

## Uso de tutoriales

El paquete incluye tutoriales interactivos (formato `learnr`) en
`inst/tutorials`.

Algunos tutoriales disponibles son: `Modelos`, `Taller-bases`,
`Taller-sumatoria`, `Taller_regresion1` y `Taller-Intervalos2`.

``` r
# Si no tienes learnr instalado
install.packages("learnr")

# Listar tutoriales disponibles del paquete
tuts <- learnr::available_tutorials(package = "paqueteDEG")
tuts[, c("name", "title")]

# Ejecutar tutoriales específicos
learnr::run_tutorial(name = "Modelos", package = "paqueteDEG")
learnr::run_tutorial(name = "Taller-bases", package = "paqueteDEG")
learnr::run_tutorial(name = "Taller-Intervalos2", package = "paqueteDEG")
```

También puedes abrirlos desde RStudio en la pestaña **Tutorial**.

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
