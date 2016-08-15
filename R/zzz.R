colClasses <- function(d, colClasses) {
  colClasses <- rep(colClasses, len = length(d))
  d[] <- lapply(seq_along(d), function(i) switch(colClasses[i],
      numeric = as.numeric(d[[i]]), character = as.character(d[[i]]),
      Date =
        as.Date(d[[i]], origin = "1970-01-01"),
      POSIXct = as.POSIXct(d[[i]],
        origin = "1970-01-01"), factor = as.factor(d[[i]]),
      methods::as(d[[i]], colClasses[i])))
  d
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

# General purpose parser fxn to parse apart file names, etc. into their components
parse_landsat_str <- function(x) {
  x <- basename(x)
  ext <- NULL
  # strip off file ext, if any
  if (grepl("\\.[A-Za-z]+", x)) {
    ext <- strextract(x, "\\.[A-Za-z]+")
    x <- gsub("\\.[A-Za-z]+", "", x)
  }
  xsplit <- strsplit(x, "_")[[1]]
  file <- xsplit[2]
  z <- xsplit[1]
  res <- list(landsat = substr(z, 1, 1),
              sensor = substr(z, 2, 2),
              satellite = substr(z, 3, 3),
              wrs_path = substr(z, 4, 6),
              wrs_row = substr(z, 7, 9),
              year = substr(z, 10, 13),
              day_julian = substr(z, 14, 16),
              archive_version = substr(z, 17, 18)
  )
  c(res, str = z, file = file, ext = ext)
}

lsat_GET <- function(x, ...) {
  res <- httr::GET(x, ...)
  httr::stop_for_status(res)
}

getc <- function(x) {
  content(x, "text", encoding = 'UTF-8')
}

parsxml <- function(x) {
  txt <- getc(x)
  xml <- read_xml(txt)
  ch <- xml_children(xml)
  cont <- ch[xml_name(ch) == "Contents"]
  flat_list(lapply(cont, as_list))
}

flat_list <- function(z) {
  Map(function(x) as.list(unlist(x)), z)
}

tc <- function(x) Filter(Negate(is.null), x)

lsat_base <- function() "http://landsat-pds.s3-us-west-2.amazonaws.com"
