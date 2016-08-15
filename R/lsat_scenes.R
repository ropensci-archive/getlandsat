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
#' This is an alternative to using \code{\link{lsat_list}}. This function
#' downloads the up to date compressed csv file, while \code{\link{lsat_list}}
#' uses the AWS S3 API.
#'
#' @seealso \code{\link{lsat_scene_files}}
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
  args <- list(...)
  if (any(names(args) %in% 'skip')) {
    warning(
      "you probably don't want to use 'skip' as that skips the table header",
      call. = FALSE
    )
  }
  readr::read_csv(url, ...)
}
