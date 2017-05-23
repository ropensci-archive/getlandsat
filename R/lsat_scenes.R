#' List Landsat scenes
#'
#' @export
#' @param ... Further args passed on to [readr::read_csv()]
#'
#' @details We use [readr::read_csv()] to read the scene list file
#' from <http://landsat-pds.s3.amazonaws.com/scene_list.gz>. See the help
#' file for [readr::read_csv()] for what parameter you can pass to modify it's
#' behavior.
#'
#' This is an alternative to using [lsat_list()]. This function
#' downloads the up to date compressed csv file, while [lsat_list()]
#' uses the AWS S3 API.
#'
#' @seealso [lsat_scene_files()]
#'
#' @examples \dontrun{
#' res <- lsat_scenes()
#' res
#'
#' # read only N rows
#' lsat_scenes(n_max = 10)
#' }
lsat_scenes <- function(...) {
  url <- "http://landsat-pds.s3.amazonaws.com/scene_list.gz"
  args <- list(...)
  if (any(names(args) %in% 'skip')) {
    warning(
      "you probably don't want to use 'skip' as that skips the table header",
      call. = FALSE
    )
  }
  readr::read_csv(url, ...)
}
