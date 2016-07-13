#' List Landsat scenes
#'
#' @export
#' @param ... Further args passed on to \code{\link[readr]{read_csv}}
#'
#' @details We use \code{\link[readr]{read_csv}} to read the scene list file
#' from \url{http://landsat-pds.s3.amazonaws.com/scene_list.gz}. See the help
#' file for \code{read_csv} for what parameter you can pass to modify it's
#' behavior.
#'
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
