#' List files for a Landsat scene
#'
#' @export
#' @param x (character) A URL to a scene html file
#' @param ... Curl options passed on to [crul::HttpClient()]
#'
#' @details This function fetches files available in a scene, while
#' [lsat_scenes()] lists the scenes, but not their files
#'
#' @seealso [lsat_scenes()]
#'
#' @return A data.frame with two columns:
#' \itemize{
#'  \item file - file name
#'  \item size - file size
#' }
#'
#' @examples \dontrun{
#' res <- lsat_scenes(n_max = 10)
#' lsat_scene_files(x = res$download_url[1])
#' lsat_scene_files(x = res$download_url[2])
#' }
lsat_scene_files <- function(x, ...) {
  path <- strextract(x, "L8.+")
  if (length(path) == 0) {
    stop("input needs to be a URL for a scene html file", call. = FALSE)
  }
  url <- file.path(lsat_base(), path)
  res <- lsat_GET(url, ...)
  txt <- res$parse("UTF-8")
  html <- xml2::read_html(txt)
  df <- do.call(
    "rbind.data.frame",
    lapply(xml2::xml_find_all(html, '//li'), function(x) {
      al <- xml2::as_list(x)
      size <- strextract(strextract(al[[2]], "\\(.+"), "[0-9\\.]+[A-Z]+")
      list(file = al$a[[1]], size = size)
    }))
  colClasses(df, "character")
}
