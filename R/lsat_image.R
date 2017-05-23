handle_errors <- function(x, path) {
  if (x$status_code > 201) {
    x$raise_for_status()
    unlink(path, recursive = TRUE, force = TRUE)
  }
}

lsatGET <- function(url, dat, overwrite, ...) {
  key <- basename(url)
  fpath <- file.path(lsat_path(), "L8", dat$wrs_path, dat$wrs_row, dat$str, key)
  if (file.exists(fpath)) {
    message("File in cache")
    return(fpath)
  } else {
    temp_path <- tempfile()
    cli <- crul::HttpClient$new(url = url, opts = list(...))
    res <- cli$get(disk = temp_path)

    #if download has failed, it will stop here
    handle_errors(res, fpath)

    # create directory if it doesn't exist yet
    dir.create(dirname(fpath), showWarnings = FALSE, recursive = TRUE)
    file.rename(temp_path, fpath)

    # return file path
    return(fpath)
  }
}

#' Get Landsat image(s)
#'
#' @export
#' @param x (character) A file name for a geotif file, will be more general soon.
#' @param overwrite	(logical) Will only overwrite existing path if `TRUE`.
#' Deprecated, will be removed in the next version. If file exists we return
#' that path so there's no chance of overwriting
#' @param ... Curl args passed on to [crul::HttpClient()]
#' @return Path to the file, whether found in cache or new file
#' requested.
#' @seealso [lsat_cache()]
#' @examples \dontrun{
#' # pass an image name
#' (res <- lsat_list(max = 40))
#' tifs <- grep("\\.TIF$", res$Key, value = TRUE)
#' lsat_image(tifs[5])
#' lsat_image(tifs[6])
#' lsat_image(tifs[9])
#'
#' # caching
#' ## requesting an image you already have will return path if found
#' lsat_image(tifs[5])
#' }
lsat_image <- function(x, overwrite = FALSE, ...) {
  dat <- parse_landsat_str(x)
  url <- sprintf(
    "https://s3-us-west-2.amazonaws.com/landsat-pds/L8/%s/%s/%s/%s",
    dat$wrs_path, dat$wrs_row, dat$str, basename(x)
  )
  lsatGET(url, dat, overwrite, ...)
}
