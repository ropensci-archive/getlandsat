#' GET Landsat image(s)
#'
#' @export
#' @param x (character) A file name for a geotif file, will be more general soon.
#' @param path (character) Path to content to.
#' @param overwrite	(logical) Will only overwrite existing path if \code{TRUE}
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # pass an image name
#' lsat_image(x = "LC80101172015002LGN00_B5.TIF")
#' }
lsat_image <- function(x, path = NULL, overwrite = FALSE, ...) {
  if (is.null(path)) path <- tempfile(fileext = ".TIF")
  dat <- parse_landsat_str(x)
  url <- sprintf("https://s3-us-west-2.amazonaws.com/landsat-pds/L8/%s/%s/%s/%s",
                 dat$wrs_path, dat$wrs_row, dat$str, x)
  res <- GET(url, write_disk(path = path, overwrite = overwrite), ...)
  stop_for_status(res)
  res$request$output$path
}
