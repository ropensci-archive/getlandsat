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
#' lsat_list(max = 3, config = verbose())
#' }
lsat_list <- function(max = NULL, marker = NULL, ...) {
  args <- tc(list(`max-keys` = max, marker = marker))
  tmp <- parsxml(lsat_GET(lsat_base(), query = args, ...))
  tmp <- flat_list(tmp[names(tmp) == "Contents"])
  df <- data.table::setDF(data.table::rbindlist(tmp, fill = TRUE, use.names = TRUE))
  tibble::as_data_frame(df)
}
