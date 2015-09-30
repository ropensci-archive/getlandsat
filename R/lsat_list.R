#' @title List Landsat images
#'
#' @description This is an alternative to using lsat_scenes(). This
#' function uses the AWS S3 API, while the other fxn simply downloads
#' the up to date compressed csv file.
#'
#' @export
#' @param ... Further args passed on to \code{\link[aws.s3]{getbucket}}
#' @param max Integer indicating the maximum number of keys to return (max 1000,
#' default 1000).
#' @examples \dontrun{
#' lsat_list(max = 10)
#'
#' # paging, start a specific key string
#' res <- lsat_list(max = 10)
#' lsat_list(marker = res$Key[10], max = 10)
#'
#' # curl options
#' library("httr")
#' lsat_list(config = verbose())
#' }
lsat_list <- function(max = NULL, ...) {
  tmp <- aws.s3::getbucket(bucket = "landsat-pds", max = max, ...)
  tmp <- tmp[names(tmp) == "Contents"]
  df <- do.call("rbind.data.frame", tmp)
  row.names(df) <- NULL
  df <- colClasses(df, "character")
  keys <- df$Key
  lapply(keys, function(z) {
    "x"
  })
}
