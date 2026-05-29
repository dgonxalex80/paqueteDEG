#' @title Prueba de hipotesis para una media con datos resumidos
#' @description
#' Realiza una prueba t para una media cuando solo se dispone de la media
#' muestral, la desviacion estandar muestral y el tamano de muestra.
#' @param media media muestral.
#' @param n tamano de muestra.
#' @param sd desviacion estandar muestral.
#' @param mu0 media poblacional bajo la hipotesis nula.
#' @param alternative tipo de hipotesis alternativa: "two.sided", "less" o "greater".
#' @param conf.level nivel de confianza para el intervalo de confianza.
#' @return Objeto clase `htest`, con estadistico, grados de libertad, p-value,
#'   intervalo de confianza en `conf.int` y alias `int.conf`, estimacion e hipotesis alternativa.
#' @examples
#' res <- test.mu(media = 52, n = 36, sd = 8, mu0 = 50)
#' res$int.conf
#' @export

test.mu <- function(media,
                    n,
                    sd,
                    mu0,
                    alternative = c("two.sided", "less", "greater"),
                    conf.level = 0.95) {
  alternative <- match.arg(alternative)

  if (!is.numeric(media) || length(media) != 1) {
    stop("`media` debe ser un numero.", call. = FALSE)
  }
  if (!is.numeric(n) || length(n) != 1 || n <= 1 || n != as.integer(n)) {
    stop("`n` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(sd) || length(sd) != 1 || sd <= 0) {
    stop("`sd` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(mu0) || length(mu0) != 1) {
    stop("`mu0` debe ser un numero.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe estar entre 0 y 1.", call. = FALSE)
  }

  se <- sd / sqrt(n)
  gl <- n - 1
  estadistico <- (media - mu0) / se

  p.value <- switch(
    alternative,
    two.sided = 2 * stats::pt(-abs(estadistico), df = gl),
    less = stats::pt(estadistico, df = gl),
    greater = stats::pt(estadistico, df = gl, lower.tail = FALSE)
  )

  alpha <- 1 - conf.level
  if (alternative == "two.sided") {
    tcrit <- stats::qt(1 - alpha / 2, df = gl)
    conf.int <- c(media - tcrit * se, media + tcrit * se)
  } else if (alternative == "less") {
    tcrit <- stats::qt(conf.level, df = gl)
    conf.int <- c(-Inf, media + tcrit * se)
  } else {
    tcrit <- stats::qt(conf.level, df = gl)
    conf.int <- c(media - tcrit * se, Inf)
  }
  attr(conf.int, "conf.level") <- conf.level

  out <- list(
    statistic = c(t = estadistico),
    parameter = c(df = gl),
    p.value = p.value,
    conf.int = conf.int,
    int.conf = conf.int,
    estimate = c("mean of x" = media),
    null.value = c("mean" = mu0),
    alternative = alternative,
    method = "One Sample t-test (summary stats)",
    data.name = sprintf("summary: mean = %s, sd = %s, n = %s", media, sd, n)
  )
  class(out) <- "htest"
  out
}

#' @title Prueba de hipotesis para diferencia de medias con datos resumidos
#' @description
#' Realiza una prueba t para la diferencia de medias usando solo
#' estadisticas resumidas de dos muestras independientes.
#'
#' Tambien acepta la forma abreviada `test.mus(n, media, sd)`, donde
#' cada argumento es un vector de longitud 2 para los dos grupos.
#' @param media1 media muestral del grupo 1.
#' @param n1 tamano de muestra del grupo 1.
#' @param sd1 desviacion estandar del grupo 1.
#' @param media2 media muestral del grupo 2.
#' @param n2 tamano de muestra del grupo 2.
#' @param sd2 desviacion estandar del grupo 2.
#' @param delta0 diferencia bajo H0 (por defecto 0).
#' @param alternative tipo de hipotesis alternativa: "two.sided", "less" o "greater".
#' @param var.equal si `TRUE`, usa varianzas iguales (pooled); si `FALSE`, Welch.
#' @param conf.level nivel de confianza para el intervalo de confianza.
#' @return Objeto clase `htest`, con estadistico, grados de libertad, p-value,
#'   intervalo de confianza en `conf.int` y alias `int.conf`, estimacion e hipotesis alternativa.
#' @examples
#' res <- test.mus(80, 25, 10, 74, 22, 12)
#' res$int.conf
#'
#' res2 <- test.mus(c(42, 39), c(68.4, 63.1), c(10.2, 11.5))
#' res2$int.conf
#' @export

test.mus <- function(media1,
                     n1,
                     sd1,
                     media2 = NULL,
                     n2 = NULL,
                     sd2 = NULL,
                     delta0 = 0,
                     alternative = c("two.sided", "less", "greater"),
                     var.equal = FALSE,
                     conf.level = 0.95) {
  alternative <- match.arg(alternative)

  if (is.null(media2) && is.null(n2) && is.null(sd2) &&
      is.numeric(media1) && is.numeric(n1) && is.numeric(sd1) &&
      length(media1) == 2 && length(n1) == 2 && length(sd1) == 2) {
    if (all(media1 > 1) && all(media1 == as.integer(media1))) {
      n_vec <- media1
      media_vec <- n1
    } else if (all(n1 > 1) && all(n1 == as.integer(n1))) {
      media_vec <- media1
      n_vec <- n1
    } else {
      stop("En la forma abreviada use test.mus(n, media, sd) o test.mus(media, n, sd), con n entero.", call. = FALSE)
    }

    media1 <- media_vec[1]
    media2 <- media_vec[2]
    n1 <- n_vec[1]
    n2 <- n_vec[2]
    sd2 <- sd1[2]
    sd1 <- sd1[1]
  }

  if (!is.numeric(media1) || length(media1) != 1 || !is.numeric(media2) || length(media2) != 1) {
    stop("`media1` y `media2` deben ser numeros.", call. = FALSE)
  }
  if (!is.numeric(n1) || length(n1) != 1 || n1 <= 1 || n1 != as.integer(n1)) {
    stop("`n1` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(n2) || length(n2) != 1 || n2 <= 1 || n2 != as.integer(n2)) {
    stop("`n2` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(sd1) || length(sd1) != 1 || sd1 <= 0) {
    stop("`sd1` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(sd2) || length(sd2) != 1 || sd2 <= 0) {
    stop("`sd2` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(delta0) || length(delta0) != 1) {
    stop("`delta0` debe ser un numero.", call. = FALSE)
  }
  if (!is.logical(var.equal) || length(var.equal) != 1) {
    stop("`var.equal` debe ser TRUE o FALSE.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe estar entre 0 y 1.", call. = FALSE)
  }

  diff_est <- media1 - media2

  if (isTRUE(var.equal)) {
    sp2 <- ((n1 - 1) * sd1^2 + (n2 - 1) * sd2^2) / (n1 + n2 - 2)
    se <- sqrt(sp2 * (1 / n1 + 1 / n2))
    gl <- n1 + n2 - 2
    metodo <- "Two Sample t-test (summary stats, pooled variance)"
  } else {
    se <- sqrt(sd1^2 / n1 + sd2^2 / n2)
    gl <- (sd1^2 / n1 + sd2^2 / n2)^2 /
      ((sd1^2 / n1)^2 / (n1 - 1) + (sd2^2 / n2)^2 / (n2 - 1))
    metodo <- "Welch Two Sample t-test (summary stats)"
  }

  estadistico <- (diff_est - delta0) / se

  p.value <- switch(
    alternative,
    two.sided = 2 * stats::pt(-abs(estadistico), df = gl),
    less = stats::pt(estadistico, df = gl),
    greater = stats::pt(estadistico, df = gl, lower.tail = FALSE)
  )

  alpha <- 1 - conf.level
  if (alternative == "two.sided") {
    tcrit <- stats::qt(1 - alpha / 2, df = gl)
    conf.int <- c(diff_est - tcrit * se, diff_est + tcrit * se)
  } else if (alternative == "less") {
    tcrit <- stats::qt(conf.level, df = gl)
    conf.int <- c(-Inf, diff_est + tcrit * se)
  } else {
    tcrit <- stats::qt(conf.level, df = gl)
    conf.int <- c(diff_est - tcrit * se, Inf)
  }
  attr(conf.int, "conf.level") <- conf.level

  out <- list(
    statistic = c(t = estadistico),
    parameter = c(df = gl),
    p.value = p.value,
    conf.int = conf.int,
    int.conf = conf.int,
    estimate = c("mean of x" = media1, "mean of y" = media2),
    null.value = c("difference in means" = delta0),
    alternative = alternative,
    method = metodo,
    data.name = sprintf(
      "summary x: mean = %s, sd = %s, n = %s and summary y: mean = %s, sd = %s, n = %s",
      media1, sd1, n1, media2, sd2, n2
    )
  )
  class(out) <- "htest"
  out
}

#' @title Prueba de hipotesis para una varianza con datos resumidos
#' @description
#' Realiza una prueba chi-cuadrado para una varianza cuando solo se dispone
#' de la desviacion estandar muestral y el tamano de muestra.
#' @param sd desviacion estandar muestral.
#' @param n tamano de muestra.
#' @param sigma20 varianza poblacional bajo H0.
#' @param alternative tipo de hipotesis alternativa: "two.sided", "less" o "greater".
#' @param conf.level nivel de confianza para el intervalo de confianza.
#' @return Objeto clase `htest`, con estadistico, grados de libertad, p-value,
#'   intervalo de confianza en `conf.int` y alias `int.conf`, estimacion e hipotesis alternativa.
#' @examples
#' res <- test.var(sd = 12, n = 30, sigma20 = 100)
#' res$int.conf
#' @export
test.var <- function(sd,
                     n,
                     sigma20,
                     alternative = c("two.sided", "less", "greater"),
                     conf.level = 0.95) {
  alternative <- match.arg(alternative)

  if (!is.numeric(sd) || length(sd) != 1 || sd <= 0) {
    stop("`sd` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(n) || length(n) != 1 || n <= 1 || n != as.integer(n)) {
    stop("`n` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(sigma20) || length(sigma20) != 1 || sigma20 <= 0) {
    stop("`sigma20` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe estar entre 0 y 1.", call. = FALSE)
  }

  s2 <- sd^2
  gl <- n - 1
  estadistico <- gl * s2 / sigma20

  p.value <- switch(
    alternative,
    two.sided = {
      p_left <- stats::pchisq(estadistico, df = gl)
      2 * min(p_left, 1 - p_left)
    },
    less = stats::pchisq(estadistico, df = gl),
    greater = stats::pchisq(estadistico, df = gl, lower.tail = FALSE)
  )

  alpha <- 1 - conf.level
  if (alternative == "two.sided") {
    li <- gl * s2 / stats::qchisq(1 - alpha / 2, df = gl)
    ls <- gl * s2 / stats::qchisq(alpha / 2, df = gl)
    conf.int <- c(li, ls)
  } else if (alternative == "less") {
    ls <- gl * s2 / stats::qchisq(alpha, df = gl)
    conf.int <- c(0, ls)
  } else {
    li <- gl * s2 / stats::qchisq(1 - alpha, df = gl)
    conf.int <- c(li, Inf)
  }
  attr(conf.int, "conf.level") <- conf.level

  out <- list(
    statistic = c("X-squared" = estadistico),
    parameter = c(df = gl),
    p.value = p.value,
    conf.int = conf.int,
    int.conf = conf.int,
    estimate = c("sample variance" = s2),
    null.value = c("variance" = sigma20),
    alternative = alternative,
    method = "Chi-squared test for one variance (summary stats)",
    data.name = sprintf("summary: sd = %s, n = %s", sd, n)
  )
  class(out) <- "htest"
  out
}

#' @title Prueba de hipotesis para razon de dos varianzas con datos resumidos
#' @description
#' Realiza una prueba F para comparar dos varianzas poblacionales
#' independientes usando desviaciones estandar y tamanos muestrales.
#' @param sd1 desviacion estandar del grupo 1.
#' @param n1 tamano de muestra del grupo 1.
#' @param sd2 desviacion estandar del grupo 2.
#' @param n2 tamano de muestra del grupo 2.
#' @param ratio0 razon bajo H0 (var1/var2), por defecto 1.
#' @param alternative tipo de hipotesis alternativa: "two.sided", "less" o "greater".
#' @param conf.level nivel de confianza para el intervalo de confianza.
#' @return Objeto clase `htest`, con estadistico, grados de libertad, p-value,
#'   intervalo de confianza en `conf.int` y alias `int.conf`, estimacion e hipotesis alternativa.
#' @examples
#' res <- test.vars(sd1 = 15, n1 = 20, sd2 = 10, n2 = 18)
#' res$int.conf
#' @export
test.vars <- function(sd1,
                      n1,
                      sd2,
                      n2,
                      ratio0 = 1,
                      alternative = c("two.sided", "less", "greater"),
                      conf.level = 0.95) {
  alternative <- match.arg(alternative)

  if (!is.numeric(sd1) || length(sd1) != 1 || sd1 <= 0) {
    stop("`sd1` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(sd2) || length(sd2) != 1 || sd2 <= 0) {
    stop("`sd2` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(n1) || length(n1) != 1 || n1 <= 1 || n1 != as.integer(n1)) {
    stop("`n1` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(n2) || length(n2) != 1 || n2 <= 1 || n2 != as.integer(n2)) {
    stop("`n2` debe ser un entero mayor que 1.", call. = FALSE)
  }
  if (!is.numeric(ratio0) || length(ratio0) != 1 || ratio0 <= 0) {
    stop("`ratio0` debe ser un numero positivo.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe estar entre 0 y 1.", call. = FALSE)
  }

  v1 <- sd1^2
  v2 <- sd2^2
  gl1 <- n1 - 1
  gl2 <- n2 - 1

  estadistico <- (v1 / v2) / ratio0

  p.value <- switch(
    alternative,
    two.sided = {
      p_left <- stats::pf(estadistico, df1 = gl1, df2 = gl2)
      2 * min(p_left, 1 - p_left)
    },
    less = stats::pf(estadistico, df1 = gl1, df2 = gl2),
    greater = stats::pf(estadistico, df1 = gl1, df2 = gl2, lower.tail = FALSE)
  )

  alpha <- 1 - conf.level
  if (alternative == "two.sided") {
    li <- (v1 / v2) / stats::qf(1 - alpha / 2, df1 = gl1, df2 = gl2)
    ls <- (v1 / v2) / stats::qf(alpha / 2, df1 = gl1, df2 = gl2)
    conf.int <- c(li, ls)
  } else if (alternative == "less") {
    ls <- (v1 / v2) / stats::qf(alpha, df1 = gl1, df2 = gl2)
    conf.int <- c(0, ls)
  } else {
    li <- (v1 / v2) / stats::qf(1 - alpha, df1 = gl1, df2 = gl2)
    conf.int <- c(li, Inf)
  }
  attr(conf.int, "conf.level") <- conf.level

  out <- list(
    statistic = c(F = estadistico),
    parameter = c(num.df = gl1, den.df = gl2),
    p.value = p.value,
    conf.int = conf.int,
    int.conf = conf.int,
    estimate = c("ratio of variances" = v1 / v2),
    null.value = c("ratio of variances" = ratio0),
    alternative = alternative,
    method = "F test to compare two variances (summary stats)",
    data.name = sprintf("summary x: sd = %s, n = %s and summary y: sd = %s, n = %s", sd1, n1, sd2, n2)
  )
  class(out) <- "htest"
  out
}
