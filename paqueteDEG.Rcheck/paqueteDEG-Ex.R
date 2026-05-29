pkgname <- "paqueteDEG"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('paqueteDEG')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("Cnk")
### * Cnk

flush(stderr()); flush(stdout())

### Name: Cnk
### Title: Combinación
### Aliases: Cnk

### ** Examples

Cnk(10,2)




cleanEx()
nameEx("Colombia23")
### * Colombia23

flush(stderr()); flush(stdout())

### Name: Colombia23
### Title: Colombia 2023
### Aliases: Colombia23
### Keywords: datasets

### ** Examples

data(Colombia23)



cleanEx()
nameEx("Pnk")
### * Pnk

flush(stderr()); flush(stdout())

### Name: Pnk
### Title: Permutación
### Aliases: Pnk

### ** Examples

Pnk(10,2)




cleanEx()
nameEx("adjusted_size")
### * adjusted_size

flush(stderr()); flush(stdout())

### Name: adjusted_size
### Title: Correccion del tamano de la muestra por el factor de poblacion
###   finita
### Aliases: adjusted_size

### ** Examples

 adjusted_size(385,500)



cleanEx()
nameEx("ausentismo")
### * ausentismo

flush(stderr()); flush(stdout())

### Name: ausentismo
### Title: Ausencias al trabajo
### Aliases: ausentismo
### Keywords: datasets

### ** Examples

ausentismo



cleanEx()
nameEx("beer")
### * beer

flush(stderr()); flush(stdout())

### Name: beer
### Title: Cervezas
### Aliases: beer
### Keywords: datasets

### ** Examples

beer



cleanEx()
nameEx("casas")
### * casas

flush(stderr()); flush(stdout())

### Name: casas
### Title: Pricios y caracteristicas de viviendas.
### Aliases: casas
### Keywords: datasets

### ** Examples

casas



cleanEx()
nameEx("ic.var")
### * ic.var

flush(stderr()); flush(stdout())

### Name: ic.var
### Title: Intervalo de confianza para una varianza
### Aliases: ic.var

### ** Examples

ic.var(c(12, 15, 18, 21, 24, 27, 30), 0.95)




cleanEx()
nameEx("intervalo.var")
### * intervalo.var

flush(stderr()); flush(stdout())

### Name: intervalo.var
### Title: Intervalo de confianza para una varianza
### Aliases: intervalo.var

### ** Examples

intervalo.var(c(3,4,3,2,3,4,5),0.95)



cleanEx()
nameEx("inventarioPackages")
### * inventarioPackages

flush(stderr()); flush(stdout())

### Name: inventarioPackages
### Title: Inventario de paquetes
### Aliases: inventarioPackages
### Keywords: datasets

### ** Examples

data(inventarioPackages)



cleanEx()
nameEx("resumen_num")
### * resumen_num

flush(stderr()); flush(stdout())

### Name: resumen_num
### Title: Resumen numerico con histogram y diagrama de cajas
### Aliases: resumen_num

### ** Examples

resumen_num(c(12, 15, 18, 20, 22, 25, 30))



cleanEx()
nameEx("simula_tcl")
### * simula_tcl

flush(stderr()); flush(stdout())

### Name: simula_tcl
### Title: Simulacion del Teorema Central del Limite
### Aliases: simula_tcl

### ** Examples

out1 <- simula_tcl(rexp(m, 1), n = 200, replicas = 200, mostrar = FALSE)
out2 <- simula_tcl(runif(m, 10, 50), n = 200, replicas = 200, mostrar = FALSE)
out3 <- simula_tcl(rexp, n = 200, replicas = 200, rate = 1, mostrar = FALSE)



cleanEx()
nameEx("sizemu")
### * sizemu

flush(stderr()); flush(stdout())

### Name: sizemu
### Title: Tamano de la muestra para la estimacion de una media
### Aliases: sizemu

### ** Examples

sizemu(1.96,245,2)
sizemu(1.96,245,2, pob_size = 1000)



cleanEx()
nameEx("sizep")
### * sizep

flush(stderr()); flush(stdout())

### Name: sizep
### Title: Tamano de la muestra para la estimacion de una proporcion
### Aliases: sizep

### ** Examples

sizep(1.96,0.5,0.02)
sizep(1.96,0.5,0.02, pob_size = 1000)



cleanEx()
nameEx("strata_size")
### * strata_size

flush(stderr()); flush(stdout())

### Name: strata_size
### Title: Distribucion muestral para muestreo estratificado
### Aliases: strata_size

### ** Examples

strata_size(385, c(40, 35, 25), c("Norte", "Centro", "Sur"))
strata_size(100, c(0.5, 0.3, 0.2))



cleanEx()
nameEx("test.mu")
### * test.mu

flush(stderr()); flush(stdout())

### Name: test.mu
### Title: Prueba de hipotesis para una media con datos resumidos
### Aliases: test.mu

### ** Examples

res <- test.mu(media = 52, n = 36, sd = 8, mu0 = 50)
res$int.conf



cleanEx()
nameEx("test.mus")
### * test.mus

flush(stderr()); flush(stdout())

### Name: test.mus
### Title: Prueba de hipotesis para diferencia de medias con datos
###   resumidos
### Aliases: test.mus

### ** Examples

res <- test.mus(80, 25, 10, 74, 22, 12)
res$int.conf



cleanEx()
nameEx("test.var")
### * test.var

flush(stderr()); flush(stdout())

### Name: test.var
### Title: Prueba de hipotesis para una varianza con datos resumidos
### Aliases: test.var

### ** Examples

res <- test.var(sd = 12, n = 30, sigma20 = 100)
res$int.conf



cleanEx()
nameEx("test.vars")
### * test.vars

flush(stderr()); flush(stdout())

### Name: test.vars
### Title: Prueba de hipotesis para razon de dos varianzas con datos
###   resumidos
### Aliases: test.vars

### ** Examples

res <- test.vars(sd1 = 15, n1 = 20, sd2 = 10, n2 = 18)
res$int.conf



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
