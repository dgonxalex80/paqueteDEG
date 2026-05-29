<!-- README.md is generated from README.Rmd. Please edit that file -->

# paqueteDEG

<!-- badges: start -->
<!-- badges: end -->

El objetivo principal es recopilar una serie de funciones e instructivos
que se utilizan en el curso de Probabilidad y Estadística.

## Instalación

Este paquete se descarga desde GitHub, desde el usuario `dgonxalex80`.
El nombre del paquete en R es `paqueteDEG`.

``` r
# Opción 1: instalación con devtools
install.packages("devtools")
devtools::install_github("dgonxalex80/paqueteDEG", dependencies = NA)

# Cargar el paquete
library(paqueteDEG)
```

También puedes instalarlo con `pak`:

``` r
# Opción 2: instalación con pak
install.packages("pak")
pak::pak("dgonxalex80/paqueteDEG", dependencies = NA)

# Cargar el paquete
library(paqueteDEG)
```

También puedes instalar desde una copia local del repositorio:

``` r
devtools::install_local("/ruta/a/paqueteDEG", dependencies = NA)
```

`dependencies = NA` instala solo lo necesario para que el paquete cargue y sus
funciones básicas trabajen. Las dependencias opcionales para tutoriales y apps
(`learnr` y `shiny`) se instalan aparte solo cuando se necesiten; esto evita
fallas frecuentes en Windows o en versiones antiguas de R por paquetes
opcionales pesados.

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

## Verificación del paquete

Para validar que el paquete instala y funciona correctamente, desde la raíz del
repositorio ejecuta:

``` bash
./check.sh
```

Este script corre `R CMD build` y `R CMD check --no-manual`.
El detalle completo del check queda en:

``` text
paqueteDEG.Rcheck/00check.log
```

## Tutoriales en PDF para revisión

Se generaron versiones PDF de los tutoriales en:

``` text
inst/tutorials-pdf/
```

Si necesitas regenerarlos desde los `.html` de `inst/tutorials`, puedes usar
Google Chrome en modo headless:

``` bash
mkdir -p inst/tutorials-pdf
for f in inst/tutorials/*/*.html; do
  base="$(basename "$f" .html)"
  [ "$base" = "skeleton" ] && continue
  [ "$base" = "Untitled" ] && continue
  google-chrome --headless --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="$(pwd)/inst/tutorials-pdf/${base}.pdf" \
    "file://$(pwd)/$f"
done
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
#> Tamano de muestra
#> -----------------
#> estimacion: media
#> percentil_normal: 1.96
#> nivel_confianza: 0.950004
#> varianza: 428
#> error_muestreo: 2
#> poblacion_finita: FALSE
#> tamano_poblacion: No aplica
#> tamano_muestra_inicial: 411.051
#> tamano_muestra_final: 411.051
#> resultado_final: 412

## También se puede incorporar población finita en el cálculo inicial
sizemu(1.96,428,2,pob_size = 1000)
#> Tamano de muestra
#> -----------------
#> estimacion: media
#> percentil_normal: 1.96
#> nivel_confianza: 0.950004
#> varianza: 428
#> error_muestreo: 2
#> poblacion_finita: TRUE
#> tamano_poblacion: 1000
#> tamano_muestra_inicial: 411.051
#> tamano_muestra_final: 291.515
#> resultado_final: 292

## Código básico para calcular el tamaño de muestra para la estimación de una proporción con un nivel de confianza del 95%, prop = 0.5 y un error de muestreo de 0.05: sizep(perc_normal, prop, error)
sizep(1.96,0.5,0.05)
#> Tamano de muestra
#> -----------------
#> estimacion: proporcion
#> percentil_normal: 1.96
#> nivel_confianza: 0.950004
#> proporcion: 0.5
#> varianza: 0.25
#> error_muestreo: 0.05
#> poblacion_finita: FALSE
#> tamano_poblacion: No aplica
#> tamano_muestra_inicial: 384.16
#> tamano_muestra_final: 384.16
#> resultado_final: 385

## Corrección del tamaño de la muestra cuando n/N > 0.05: adjusted_size(n, N)
adjusted_size(385,1000)
#> Tamano de muestra
#> -----------------
#> poblacion_finita: TRUE
#> tamano_poblacion: 1000
#> tamano_muestra_inicial: 385
#> fraccion_muestreo: 0.385
#> requiere_correccion: TRUE
#> tamano_muestra_final: 278.179
#> resultado_final: 279

## Distribución muestral para muestreo estratificado usando porcentajes de estratos: strata_size(n, porcentajes, estratos)
strata_size(385,c(40,35,25),c("Estrato A","Estrato B","Estrato C"))
#> Distribucion muestral estratificada
#> -----------------------------------
#> tamano_muestra_total: 385
#> escala_suministrada: porcentaje
#> suma_porcentajes_suministrados: 100
#>
#>    estrato porcentaje_suministrado porcentaje tamano_muestra_exacto tamano_muestra
#>  Estrato A                      40         40                154.00            154
#>  Estrato B                      35         35                134.75            135
#>  Estrato C                      25         25                 96.25             96

## Estimación del intervalo de confianza para una varianza: intervalo.var(x, 0.95)
intervalo.var(c(3,4,3,2,3,4,5),0.95)
#>   lim_inf   lim_sup
#> 0.2972862 4.6816520
```

## Pruebas de hipótesis con datos resumidos

El paquete incluye pruebas cuando no se tienen datos crudos, sino
estadísticos resumen (media, desviación estándar y tamaño de muestra).

``` r
library(paqueteDEG)

# Una media
test.mu(media = 52, n = 36, sd = 8, mu0 = 50)

# Diferencia de medias (Welch por defecto)
test.mus(
  media1 = 80, n1 = 25, sd1 = 10,
  media2 = 74, n2 = 22, sd2 = 12
)

# Una varianza
test.var(sd = 12, n = 30, sigma20 = 100)

# Razón de varianzas
test.vars(sd1 = 15, n1 = 20, sd2 = 10, n2 = 18, ratio0 = 1)
```

Las funciones devuelven objetos de clase `htest`, por lo que al imprimir el
resultado se ve el intervalo como en las pruebas convencionales de R. Para
extraerlo directamente se puede usar `$int.conf`, que es un alias de
`$conf.int`:

``` r
res <- test.mu(media = 52, n = 36, sd = 8, mu0 = 50)
res$int.conf
#> [1] 49.29319 54.70681
#> attr(,"conf.level")
#> [1] 0.95

identical(res$int.conf, res$conf.int)
#> [1] TRUE
```

## Resumen numérico y gráfico

`resumen_num()` genera indicadores descriptivos y, opcionalmente, un gráfico
acompañante (`histograma` o `cajas`) con los indicadores al lado.

``` r
library(paqueteDEG)

x <- c(12, 15, 18, NA, 22, 25, 30)

# Tabla de indicadores (2 decimales por defecto)
resumen_num(x, na.rm = TRUE, graficar = FALSE)

# Indicadores + histograma
resumen_num(x, na.rm = TRUE, grafico = "histograma", decimals = 2)

# Indicadores + diagrama de cajas
resumen_num(x, na.rm = TRUE, grafico = "cajas", decimals = 3)
```

## App Shiny integrada

La app Shiny del paquete reúne pruebas tradicionales, pruebas resumidas y
resumen descriptivo.

``` r
library(paqueteDEG)
run_pruebas_app()
```
