#' @title Prueba z de hipotesis para proporciones con datos resumidos
#' @description
#' Realiza una prueba z para una proporcion o para la diferencia de dos
#' proporciones usando el numero de exitos y el tamano de muestra.
#'
#' Esta prueba esta pensada para muestras grandes. Por eso exige que todos los
#' tamanos de muestra sean mayores que 30.
#' @param x numero de exitos. Para dos proporciones, vector de longitud 2.
#' @param n tamano de muestra. Para dos proporciones, vector de longitud 2.
#' @param p proporcion bajo H0 en la prueba de una proporcion. Para dos
#'   proporciones se usa diferencia nula igual a 0.
#' @param alternative tipo de hipotesis alternativa: "two.sided", "less" o "greater".
#' @param conf.level nivel de confianza para el intervalo de confianza.
#' @return Objeto clase `htest`, con estadistico z, p-value, intervalo de
#'   confianza en `conf.int` y alias `int.conf`, estimacion e hipotesis alternativa.
#' @examples
#' res <- test.prop(x = 45, n = 100, p = 0.5)
#' res$int.conf
#'
#' res2 <- test.prop(x = c(56, 42), n = c(120, 110))
#' res2$int.conf
#' @export
test.prop <- function(x,
                      n,
                      p = NULL,
                      alternative = c("two.sided", "less", "greater"),
                      conf.level = 0.95) {
  alternative <- match.arg(alternative)

  if (!is.numeric(x) || !is.numeric(n) || length(x) != length(n) || !length(x) %in% c(1, 2)) {
    stop("`x` y `n` deben ser vectores numericos de longitud 1 o 2 y de la misma longitud.", call. = FALSE)
  }
  if (any(!is.finite(x)) || any(!is.finite(n))) {
    stop("`x` y `n` deben contener valores finitos.", call. = FALSE)
  }
  if (any(n <= 30) || any(n != as.integer(n))) {
    stop("Todos los tamanos de muestra `n` deben ser enteros mayores que 30.", call. = FALSE)
  }
  if (any(x < 0) || any(x > n) || any(x != as.integer(x))) {
    stop("`x` debe contener numeros enteros de exitos entre 0 y n.", call. = FALSE)
  }
  if (!is.numeric(conf.level) || length(conf.level) != 1 || conf.level <= 0 || conf.level >= 1) {
    stop("`conf.level` debe estar entre 0 y 1.", call. = FALSE)
  }

  phat <- x / n
  alpha <- 1 - conf.level

  p.value <- function(z) {
    switch(
      alternative,
      two.sided = 2 * stats::pnorm(-abs(z)),
      less = stats::pnorm(z),
      greater = stats::pnorm(z, lower.tail = FALSE)
    )
  }

  make_ci <- function(estimate, se, lower_bound, upper_bound) {
    if (alternative == "two.sided") {
      zcrit <- stats::qnorm(1 - alpha / 2)
      ci <- c(estimate - zcrit * se, estimate + zcrit * se)
    } else if (alternative == "less") {
      zcrit <- stats::qnorm(conf.level)
      ci <- c(lower_bound, estimate + zcrit * se)
    } else {
      zcrit <- stats::qnorm(conf.level)
      ci <- c(estimate - zcrit * se, upper_bound)
    }
    ci <- pmax(lower_bound, pmin(upper_bound, ci))
    attr(ci, "conf.level") <- conf.level
    ci
  }

  if (length(x) == 1) {
    if (is.null(p)) {
      stop("Para una proporcion debe suministrar `p`, la proporcion bajo H0.", call. = FALSE)
    }
    if (!is.numeric(p) || length(p) != 1 || p <= 0 || p >= 1) {
      stop("`p` debe ser una proporcion bajo H0 entre 0 y 1.", call. = FALSE)
    }

    se0 <- sqrt(p * (1 - p) / n)
    estadistico <- (phat - p) / se0
    se_ci <- sqrt(phat * (1 - phat) / n)
    conf.int <- make_ci(phat, se_ci, 0, 1)

    out <- list(
      statistic = c(z = estadistico),
      parameter = c(n = n),
      p.value = p.value(estadistico),
      conf.int = conf.int,
      int.conf = conf.int,
      estimate = c("sample proportion" = phat),
      null.value = c(proportion = p),
      alternative = alternative,
      method = "One-sample z-test for proportion (summary stats)",
      data.name = sprintf("summary: x = %s, n = %s", x, n)
    )
    class(out) <- "htest"
    return(out)
  }

  if (!is.null(p)) {
    warning("`p` se ignora en la prueba de dos proporciones; se usa diferencia bajo H0 igual a 0.", call. = FALSE)
  }

  pooled <- sum(x) / sum(n)
  if (pooled <= 0 || pooled >= 1) {
    stop("La proporcion combinada debe estar entre 0 y 1 para calcular el estadistico z.", call. = FALSE)
  }

  diff_est <- phat[1] - phat[2]
  se0 <- sqrt(pooled * (1 - pooled) * (1 / n[1] + 1 / n[2]))
  estadistico <- diff_est / se0
  se_ci <- sqrt(phat[1] * (1 - phat[1]) / n[1] + phat[2] * (1 - phat[2]) / n[2])
  conf.int <- make_ci(diff_est, se_ci, -1, 1)

  out <- list(
    statistic = c(z = estadistico),
    parameter = c(n1 = n[1], n2 = n[2]),
    p.value = p.value(estadistico),
    conf.int = conf.int,
    int.conf = conf.int,
    estimate = c("proportion 1" = phat[1], "proportion 2" = phat[2]),
    null.value = c("difference in proportions" = 0),
    alternative = alternative,
    method = "Two-sample z-test for proportions (summary stats)",
    data.name = sprintf("summary x: successes = %s, n = %s and summary y: successes = %s, n = %s", x[1], n[1], x[2], n[2])
  )
  class(out) <- "htest"
  out
}
