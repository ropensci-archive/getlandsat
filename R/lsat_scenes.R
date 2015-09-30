#' List Landsat scenes
#'
#' @export
#' @param ... Further args passed on to \code{\link[readr]{read_csv}}
#' @examples \dontrun{
#' res <- lsat_scenes()
#' head(res)
#'
#' # read only N rows
#' lsat_scenes(n_max = 10)
#' }
lsat_scenes <- function(...) {
  url <- "http://landsat-pds.s3.amazonaws.com/scene_list.gz"
  readr::read_csv(url, ...)
}
