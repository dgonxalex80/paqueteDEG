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



cleanEx()
nameEx("sizep")
### * sizep

flush(stderr()); flush(stdout())

### Name: sizep
### Title: Tamano de la muestra para la estimacion de una proporcion
### Aliases: sizep

### ** Examples

sizep(1.96,0.5,0.02)



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
