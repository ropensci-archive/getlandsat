#' GET Landsat image(s)
#'
#' @export
#' @param x (character) A file name for a geotif file, will be more general soon.
#' @param overwrite	(logical) Will only overwrite existing path if \code{TRUE}
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @return Path to the file, whether found in cache or new file
#' requested.
#' @seealso \code{\link{lsat_cache}}
#' @examples \dontrun{
#' # pass an image name
#' lsat_image("LC80101172015002LGN00_B5.TIF")
#' lsat_image("LC81390452014295LGN00_B2.TIF")
#'
#' # caching
#' ## requesting an image you already have will return path if found
#' lsat_image("LC80101172015002LGN00_B5.TIF")
#' }
lsat_image <- function(x, overwrite = FALSE, ...) {
  dat <- parse_landsat_str(x)
  url <- sprintf("https://s3-us-west-2.amazonaws.com/landsat-pds/L8/%s/%s/%s/%s",
                 dat$wrs_path, dat$wrs_row, dat$str, x)
  lsatGET(url, dat, overwrite, ...)
}

lsatGET <- function(url, dat, overwrite, ...) {
  key <- basename(url)
  fpath <- file.path(lsat_path(), "L8", dat$wrs_path, dat$wrs_row, dat$str, key)
  if (file.exists(fpath)) {
    message("File in cache")
    return(fpath)
  } else {
    dir.create(dirname(fpath), showWarnings = FALSE, recursive = TRUE)
    res <- GET(url, write_disk(path = fpath, overwrite = overwrite), ...)
    # delete file if error, and stop message
    handle_errors(res, fpath)
    # return file path
    return(res$request$output$path)
  }
}

handle_errors <- function(x, path) {
  if (x$status_code > 201) {
    stop_for_status(x)
    unlink(path, recursive = TRUE, force = TRUE)
  }
}
