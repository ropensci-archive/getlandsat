colClasses <- function(d, colClasses) {
  colClasses <- rep(colClasses, len = length(d))
  d[] <- lapply(seq_along(d), function(i) switch(colClasses[i],
      numeric = as.numeric(d[[i]]), character = as.character(d[[i]]),
      Date = as.Date(d[[i]], origin = "1970-01-01"), POSIXct = as.POSIXct(d[[i]],
        origin = "1970-01-01"), factor = as.factor(d[[i]]),
      as(d[[i]], colClasses[i])))
  d
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))
