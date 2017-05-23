#' List Landsat images
#'
#' @export
#' @param max (integer) number indicating the maximum number of keys to
#' return (max 1000, default 1000).
#' @param marker (character) string that pecifies the key to start with
#' when listing objects in a AWS bucket. Amazon S3 returns object keys in
#' alphabetical order, starting with key after the marker in order
#' @param prefix (character) string that limits the response to keys
#' that begin with the specified prefix
#' @param delimiter (character) string used to group keys. Read the AWS
#' doc for more detail.
#' @param ... curl args passed on to [crul::HttpClient()]
#'
#' @details This is an alternative to using [lsat_scenes()]. This
#' function uses the AWS S3 API, while [lsat_scenes()] downloads
#' the up to date compressed csv file.
#'
#' @examples \dontrun{
#' lsat_list(max = 10)
#'
#' # paging, start a specific key string
#' res <- lsat_list(max = 10)
#' lsat_list(marker = res$Key[10], max = 10)
#'
#' # curl options
#' lsat_list(max = 3, verbose = TRUE)
#' }
lsat_list <- function(max = NULL, marker = NULL, prefix = NULL,
                      delimiter = NULL, ...) {
  args <- tc(list(`max-keys` = max, marker = marker, prefix = prefix,
                  delimiter = delimiter))
  tmp <- lsat_GET(lsat_base(), args, ...)
  dat <- parsxml(tmp$parse("UTF-8"))
  df <- data.table::setDF(
    data.table::rbindlist(dat, fill = TRUE, use.names = TRUE)
  )
  tibble::as_data_frame(df)
}
